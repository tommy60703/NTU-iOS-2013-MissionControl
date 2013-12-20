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
    [node.previousNodes addObject:previousNode];
    node.previousCompleteCountDown++;
    [previousNode addObserver:node forKeyPath:@"complete" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
}

- (void)clean {
    [self.workNodes removeAllObjects];
}

- (void)pushToDatabase {
    
}

- (void)pullFromDatabase {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *passcode = [self.projectMeta[@"projectPasscode"] stringValue];
        NSString *projectClassName = [@"A" stringByAppendingString:passcode];
        PFQuery *query = [PFQuery queryWithClassName:projectClassName];
        NSArray *newWorkNodes = [query findObjects];
        for (PFObject *newNode in newWorkNodes) {
            NSString *task = newNode[@"task"];
            NSString *worker = newNode[@"worker"];
            NSArray *previousNodes = newNode[@"previous"];
            BOOL completion = newNode[@"state"]? NO:YES;
            
            MCWorkNode *workNode = [[MCWorkNode alloc] initWithTask:task Worker:worker PreviousNodes:previousNodes Completion:completion];
            [self addWorkNode:workNode];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"projectContentLoaded" object:self];
        });
    });
}

@end
