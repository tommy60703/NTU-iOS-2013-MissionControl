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

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

int randomCode(){
    int random = 0;
    bool uniquePasscode = FALSE;
    while (!uniquePasscode) {
        random = arc4random() % 9000 + 1000;
        PFQuery *query =[PFQuery queryWithClassName:@"project"];
        NSLog(@"%@",[NSNumber numberWithInt:random]);
        [query whereKey:@"projectPasscode" equalTo:[NSNumber numberWithInt:random]];
        NSArray *equalArray = [query findObjects];
        if (equalArray.count != 0) {
            NSLog(@"same code, wait for another random code");
        }
        else{
            uniquePasscode = TRUE;
        }
        NSLog(@"%d",equalArray.count);

    }
        return random;
}
- (IBAction)doneButtonClicked:(id)sender {
    NSLog(@"Something created...");
    NSLog(@"%@", self.projectName.text);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        int random = randomCode();
        NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        PFObject *project = [PFObject objectWithClassName:@"project"];
        project[@"projectName"] = self.projectName.text;
        project[@"projectPasscode"] = [NSNumber numberWithInt:random];
        //    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        //    [f setNumberStyle:NSNumberFormatterDecimalStyle];
        //    project[@"projectPassword"] = [f numberFromString:self.projectPassword.text];
        project[@"projectPassword"] = self.projectPassword.text;
        project[@"projectOwner"] = udid;
        NSMutableArray *projectMember = [[NSMutableArray alloc]init];
        [projectMember addObject:udid];
        //NSLog(@"%d", projectMember.count);
        [project addUniqueObjectsFromArray:projectMember forKey:@"projectMember"];
        [project saveInBackground];
        
        PFObject *projectParticipate = [PFObject objectWithClassName:@"projectParticipate"];
        projectParticipate[@"user"] = udid;
        projectParticipate[@"owner"] = udid;
        projectParticipate[@"projectName"] = self.projectName.text;
        projectParticipate[@"projectPasscode"] = [NSNumber numberWithInt:random];
        [projectParticipate saveInBackground];
        //sleep(1);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DoUpdateProject" object:nil userInfo:nil];
        });
        [self dismissViewControllerAnimated:YES completion:nil];
}


@end
