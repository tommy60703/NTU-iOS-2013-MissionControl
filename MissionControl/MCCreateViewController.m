//
//  MCCreateViewController.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCCreateViewController.h"
#import <Parse/Parse.h>

@interface MCCreateViewController ()

@end

@implementation MCCreateViewController

- (void)viewDidLoad {
    [self.projectName performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonClicked:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSInteger random = [MCBrain getUniquePasscode];
        NSString *udid = [MCBrain shareInstance].deviceUDID;
        
        PFObject *project = [PFObject objectWithClassName:@"project"];
        project[@"projectName"] = self.projectName.text;
        project[@"projectPasscode"] = [NSNumber numberWithInt:random];
        project[@"projectPassword"] = self.projectPassword.text;
        project[@"projectOwner"] = udid;
        
        NSMutableArray *projectMember = [[NSMutableArray alloc]init];
        [projectMember addObject:self.userJob.text];
        [project addUniqueObjectsFromArray:projectMember forKey:@"projectWorkers"];
        [project saveInBackground];
        
        PFObject *projectParticipate = [PFObject objectWithClassName:@"projectParticipate"];
        projectParticipate[@"user"] = udid;
        projectParticipate[@"owner"] = udid;
        projectParticipate[@"job"] = self.userJob.text;
        projectParticipate[@"projectName"] = self.projectName.text;
        projectParticipate[@"projectPasscode"] = [NSNumber numberWithInt:random];
        [projectParticipate saveInBackground];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doUpdateProjects" object:self];
            NSLog(@"project \"%@\" with passcode %d has been created", self.projectName.text, random);
        });
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
