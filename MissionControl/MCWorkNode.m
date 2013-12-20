//
//  MCWorkNode.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCWorkNode.h"

@implementation MCWorkNode

#pragma mark - Lifecycle

- (instancetype)initWithTask:(NSString *)task Worker:(NSString *)worker PreviousNodes:(NSArray *)previousNodes Completion:(BOOL)completion {
    if (self = [super init]) {
        self.task = task;
        self.worker = worker;
        self.previousNodes = (NSMutableArray *)previousNodes;
        self.complete = completion;
        self.previousCompleteCountDown = [self getCountdown];
    }
    return self;
}

#pragma mark - Instance Methods

- (NSInteger)getCountdown {
    NSInteger count = 0;
    for (NSString *taskName in self.previousNodes) {
        MCWorkNode *node = [[MCProject shareInstance] findNodeByTask:taskName];
        if (!node.complete) {
            count++;
        }
    }
    return count;
}

- (void)changeState {
    self.complete = !self.complete;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"complete"]) {
        self.previousCompleteCountDown--;
    }
}

@end
