//
//  MCJoinViewController.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCJoinViewController.h"
#import "MCProjects.h"
#import <Parse/Parse.h>

@interface MCJoinViewController () {
    MCProjects *projects;
}

@end

@implementation MCJoinViewController

- (void)viewWillAppear:(BOOL)animated {
    self.projectName.text = @"";
    self.projectCreator.text = @"";
    
}
- (void) viewDidAppear:(BOOL)animated{
    projects = [MCProjects shareData];
    PFQuery *query = [PFQuery queryWithClassName:@"project"];
    allProject = [query findObjects];
    
    [self.textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
}
- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)joinButtonClicked:(id)sender {
    if ([self.textField.text isEqualToString:@""]) {
        NSLog(@"Funny. Haha...");
    } else {
        NSLog(@"Join %@", self.textField.text);
        PFQuery *query = [PFQuery queryWithClassName:@"project"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [query whereKey:@"projectPasscode" equalTo:[f numberFromString:self.textField.text]];
        
        PFObject *aProject = [query getFirstObject];
        NSLog(@"%@",self.passwordField.text);
        NSLog(@"%@",[aProject objectForKey:@"projectName"]);
        NSLog(@"%@",[aProject objectForKey:@"projectPassword"]);
        
        
        if (![self.passwordField.text isEqualToString:[aProject objectForKey:@"projectPassword"]]) {
            NSLog(@"wrong password!");
        }
        else{
            NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
            PFObject *projectParticipate = [PFObject objectWithClassName:@"projectParticipate"];
            projectParticipate[@"user"] = udid;
            projectParticipate[@"projectName"] = [aProject objectForKey:@"projectName"];
            projectParticipate[@"projectPasscode"] = [aProject objectForKey:@"projectPasscode"];
            [projectParticipate saveInBackground];
            NSLog(@"successed!");
        }
        sleep(1);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DoUpdateProject" object:nil userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)textChanged:(UITextField*)sender {
    if ([sender.text isEqualToString:@""]) {
        self.projectName.text = @"";
        self.projectCreator.text = @"";
    } else {
//        NSDictionary *queryProject = [projects projectForCode:[sender.text integerValue]];
//        self.projectName.text = queryProject[MCProjectNameKey];
//        self.projectCreator.text = queryProject[MCProjectCreatorKey];
                //NSLog(@"%@", [allProject[0] objectForKey:@"projectName"]);
        for (PFObject *project in allProject) {
            if ([sender.text integerValue] == [[project objectForKey:@"projectPasscode"] intValue]) {
                self.projectName.text = project[@"projectName"];
                //self.projectCreator.text = queryProject[MCProjectCreatorKey];
            }
        }
        
    }
}

@end
