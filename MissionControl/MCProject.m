//
//  MCProject.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/12/19.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCProject.h"

@implementation MCProject
@synthesize workNodes;

- (MCWorkNode *)findNodeByTask:(NSString *)task {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF.task == %@", task];
    MCWorkNode *result = [self.workNodes filteredArrayUsingPredicate:p][0];
    if (result) {
        return result;
    }
    return nil;
}

- (void)addWorkNode:(MCWorkNode *)node {
    node.editDelegate = self;
    [self.workNodes addObject:node];
}

- (void)addAPreviousNode:(MCWorkNode *)previousNode ToNode:(MCWorkNode *)node {
    [node.previousNodes addObject:previousNode];
    [previousNode addObserver:node forKeyPath:@"completion" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    node.previousNodesCompletionCountdown += 1;
}

@end
