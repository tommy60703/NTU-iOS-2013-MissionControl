//
//  MCNodeInputViewController.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCNodeInputViewController.h"
#import "MCWorkNode.h"

@interface MCNodeInputViewController ()

@end

@implementation MCNodeInputViewController

- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonClick:(id)sender {
    NSString *task = self.taskInput.text;
    NSString *worker = self.workerInput.text;
    MCWorkNode *previousNode = [[MCProject shareInstance] findNodeByTask:self.previousInput.text];
    NSMutableArray *previous = [NSMutableArray new];
    if (previousNode) {
        [previous addObject:previousNode];
    }
    MCWorkNode *newNode = [[MCWorkNode alloc] initWithTask:task Worker:worker PreviousNodes:previous Completion:NO];
    [[MCProject shareInstance] addWorkNode:newNode New:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNodeAdded" object:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
