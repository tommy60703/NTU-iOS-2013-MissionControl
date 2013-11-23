//
//  MCJoinViewController.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCJoinViewController.h"
#import "MCProjects.h"

@interface MCJoinViewController () {
    MCProjects *projects;
}

@end

@implementation MCJoinViewController

- (void)viewWillAppear:(BOOL)animated {
    self.projectName.text = @"";
    self.projectCreator.text = @"";
    projects = [MCProjects shareData];
    [self.textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)jionButtonClicked:()sender {
    if ([self.textField.text isEqualToString:@""]) {
        NSLog(@"Funny. Haha...");
    } else {
        NSLog(@"Join %@", self.textField.text);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)textChanged:(UITextField*)sender {
    if ([sender.text isEqualToString:@""]) {
        self.projectName.text = @"";
        self.projectCreator.text = @"";
    } else {
        NSDictionary *queryProject = [projects projectForCode:[sender.text integerValue]];
        self.projectName.text = queryProject[MCProjectNameKey];
        self.projectCreator.text = queryProject[MCProjectCreatorKey];
    }
}

@end
