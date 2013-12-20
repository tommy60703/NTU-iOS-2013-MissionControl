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

- (void)viewDidLoad {
    [self.projectName performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self saveProject];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveProject {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSInteger random = [MCBrain getUniquePasscode];
        NSString *udid = [MCBrain shareInstance].deviceUDID;
        
        PFObject *projectMeta = [PFObject objectWithClassName:@"project"];
        projectMeta[@"projectPasscode"] = [NSNumber numberWithInt:random];
        projectMeta[@"projectPassword"] = self.projectPassword.text;
        projectMeta[@"projectName"] = self.projectName.text;
        projectMeta[@"projectOwner"] = udid;
        projectMeta[@"lastModifyTime"] = [NSDate date];
        projectMeta[@"lastModifyItem"] = @"";
        
        NSMutableArray *projectMember = [NSMutableArray new];
        [projectMember addObject:udid];
        [projectMeta addUniqueObjectsFromArray:projectMember forKey:@"projectMember"];
        [projectMeta save];
        
        PFObject *projectParticipate = [PFObject objectWithClassName:@"projectParticipate"];
        projectParticipate[@"idOfProjectClass"] = projectMeta.objectId;
        projectParticipate[@"projectPasscode"] = [NSNumber numberWithInt:random];
        projectParticipate[@"projectName"] = self.projectName.text;
        projectParticipate[@"owner"] = udid;
        projectParticipate[@"user"] = udid;
        projectParticipate[@"job"] = self.userJob.text;
        [projectParticipate save];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doUpdateProjects" object:self];
            NSLog(@"project \"%@\" with passcode %d has been created", self.projectName.text, random);
        });
    });
}

@end
