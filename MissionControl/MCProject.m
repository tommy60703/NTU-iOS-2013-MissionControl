//
//  MCProject.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/12/19.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCProject.h"

@implementation MCProject

+ (instancetype)shareInstance {
    static MCProject *shareInstnace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstnace = [MCProject new];
    });
    return shareInstnace;
}

- (instancetype)init {
    if (self = [super init]) {
        self.workNodes = [NSMutableArray new];
    }
    return self;
}

- (MCWorkNode *)findNodeByTask:(NSString *)task {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"task == %@", task];
    MCWorkNode *result = [self.workNodes filteredArrayUsingPredicate:p][0];
    return result;
}

- (void)addWorkNode:(MCWorkNode *)node {
    [self.workNodes addObject:node];
}

- (void)addAPreviousNode:(MCWorkNode *)previousNode ToNode:(MCWorkNode *)node {
    [previousNode addObserver:node forKeyPath:@"complete" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    [node.previousNodes addObject:previousNode];
    node.previousCompleteCountDown++;
}

- (void)clean {
    [self.workNodes removeAllObjects];
}

- (void)pullFromDatabase {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *passcode = [self.projectMeta[@"projectPasscode"] stringValue];
        NSString *projectClassName = [@"A" stringByAppendingString:passcode];
        self.projectClassName = projectClassName;
        
        PFQuery *query = [PFQuery queryWithClassName:projectClassName];
        NSArray *newWorkNodes = [query findObjects];
        for (PFObject *newNode in newWorkNodes) {
            NSString *nodeId = newNode.objectId;
            NSString *task = newNode[@"task"];
            NSString *worker = newNode[@"worker"];
            NSArray *previousNodesString = newNode[@"previous"];
            bool completion = [newNode[@"state"] boolValue];
            
            NSMutableArray *previousNodes = [NSMutableArray new];
            for (NSString *previousString in previousNodesString) {
                [previousNodes addObject: [[MCProject shareInstance] findNodeByTask:previousString]];
            }
            
            MCWorkNode *workNode = [[MCWorkNode alloc] initWithTask:task Worker:worker PreviousNodes:previousNodes Completion:completion];
            workNode.objectId = nodeId;
            [self addWorkNode:workNode];
        }
        
        query = [PFQuery queryWithClassName:@"project"];
        PFObject *object = [query getObjectWithId:self.projectMeta[@"idOfProjectClass"]];
        self.lastModifyTime = object[@"lastModifyTime"];
        NSLog(@"%@", self.lastModifyTime);

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"projectContentLoaded" object:self];
        });
    });
}

- (void)updateWorkNode:(MCWorkNode *)updateNode {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *projectClassName = [@"A" stringByAppendingString:[self.projectMeta[@"projectPasscode"] stringValue]];
        PFQuery *query = [PFQuery queryWithClassName:projectClassName];
        // Retrieve the object by id
        PFObject *updated = [query getObjectWithId:updateNode.objectId];
        updated[@"state"] = @(updateNode.complete);
        [updated save];
        
        query = [PFQuery queryWithClassName:@"project"];
        [query getObjectInBackgroundWithId:self.projectMeta[@"idOfProjectClass"] block:^(PFObject *object, NSError *error) {
            object[@"lastModifyTime"] = [NSDate date];
            [object save];
        }];
    });
}

@end
