//
//  MCRootViewController.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCRootViewController.h"
#import "MCBrain.h"
#import "MCProjectContentViewController.h"
#import <Parse/Parse.h>

@interface MCRootViewController ()

@end

@implementation MCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"didUpdateProjects" object:nil];
    [[MCBrain shareInstance] updateProjects];
    
    [self performSegueWithIdentifier:@"tips" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MCBrain shareInstance].projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *projectForThisCell = [[MCBrain shareInstance].projects objectAtIndex:indexPath.row];
    
    UILabel *projectName = (UILabel *)[cell viewWithTag:1101];
    UILabel *passcode = (UILabel *)[cell viewWithTag:1102];
    UILabel *worker = (UILabel *)[cell viewWithTag:1103];
    passcode.text = [projectForThisCell[@"projectPasscode"] stringValue];
    projectName.text = projectForThisCell[@"projectName"];
    worker.text = projectForThisCell[@"job"];
    
    return cell;
}

- (void)reloadTableViewData {
    NSLog(@"MCRootView got to reload tableView");
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"ShowProjectContent"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        MCProjectContentViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.project = [[MCBrain shareInstance].projects objectAtIndex:indexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject: [MCBrain shareInstance].projects[indexPath.row][@"projectPasscode"] forKey:@"deleteNode"];
        [dict setValue:[MCBrain shareInstance].projects[indexPath.row][@"job"] forKey:@"job"];
       
        NSLog(@"%@", dict);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteProject" object:self userInfo:dict];
        [[MCBrain shareInstance].projects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        

    }
}
@end
