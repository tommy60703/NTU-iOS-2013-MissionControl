//
//  MCJoinViewController.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCJoinViewController.h"

@interface MCJoinViewController ()
@property (strong, nonatomic) NSArray *allProjects;
@end

@implementation MCJoinViewController

- (void) viewDidAppear:(BOOL)animated {
    PFQuery *query = [PFQuery queryWithClassName:@"project"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.allProjects = [query findObjects];
    });
    
    [self.passcodeField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)joinButtonClicked:(id)sender {
    if ([self.passcodeField.text isEqualToString:@""]) {
        NSLog(@"Funny. Haha...");
    } else {
        [self joinProject];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)textChanged:(UITextField *)sender {
    if ([sender.text isEqualToString:@""]) {
        self.projectName.text = @"";
    } else {
        for (PFObject *project in self.allProjects) {
            if ([sender.text integerValue] == [[project objectForKey:@"projectPasscode"] intValue]) {
                self.projectName.text = project[@"projectName"];
            }
        }
    }
}

- (void)joinProject {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"Try to join project with passcode %@", self.passcodeField.text);
        PFQuery *query = [PFQuery queryWithClassName:@"project"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [query whereKey:@"projectPasscode" equalTo:[f numberFromString:self.passcodeField.text]];
        
        PFObject *aProject = [query getFirstObject];
        if (![self.passwordField.text isEqualToString:[aProject objectForKey:@"projectPassword"]]) {
            NSLog(@"wrong password!");
        } else {
            NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
            PFObject *projectParticipate = [PFObject objectWithClassName:@"projectParticipate"];
            projectParticipate[@"user"] = udid;
            projectParticipate[@"job"] = self.userJob.text;
            projectParticipate[@"owner"] = [aProject objectForKey:@"projectOwner"];
            projectParticipate[@"projectName"] = [aProject objectForKey:@"projectName"];
            projectParticipate[@"projectPasscode"] = [aProject objectForKey:@"projectPasscode"];
            [projectParticipate saveInBackground];
            NSLog(@"Joined project \"%@\"!", [aProject objectForKey:@"projectName"]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doUpdateProjects" object:self];
        });
    });
}

@end
