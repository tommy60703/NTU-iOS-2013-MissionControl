//
//  MCCreateViewController.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCCreateViewController.h"

@interface MCCreateViewController ()

@end

@implementation MCCreateViewController

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonClicked:(id)sender {
    NSLog(@"Something created...");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
