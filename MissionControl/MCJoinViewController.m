//
//  MCJoinViewController.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCJoinViewController.h"

@interface MCJoinViewController ()

@end

@implementation MCJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textChanged:(UITextField*)sender {
    if ([sender.text isEqualToString:@""]) {
        self.navigationItem.title = @"Join Project";
    } else {
        self.navigationItem.title = sender.text;
    }
}

@end
