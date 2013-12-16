//
//  MCNodeInputViewController.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCNodeInputViewController.h"

@interface MCNodeInputViewController ()

@end

@implementation MCNodeInputViewController

- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)doneButtonClick:(id)sender {
    [self.delegate addNodeTask:self.taskInput.text Worker:self.workerInput.text Previous:self.previousInput.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
