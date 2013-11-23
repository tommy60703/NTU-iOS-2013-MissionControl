//
//  MCRootViewController.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCRootViewController.h"
#import "MCProjectContentViewController.h"
#import "MCProjects.h"

@interface MCRootViewController ()

@end

@implementation MCRootViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[MCProjects shareData] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *projectForThisCell = [[MCProjects shareData] projectAtIndexPath:indexPath];
    
    UILabel *projectName = (UILabel *)[cell viewWithTag:1101];
    UILabel *projectCreator = (UILabel *)[cell viewWithTag:1102];
    projectName.text = projectForThisCell[MCProjectNameKey];
    projectCreator.text = projectForThisCell[MCProjectCreatorKey];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"ShowCityDetail"]) {
//        UITableViewCell *cell = (UITableViewCell *)sender;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        NSDictionary *city = [[CLDataSource sharedDataSource] dictionaryWithCityAtIndexPath:indexPath];
//        
//        CLCityViewController *detailViewController = segue.destinationViewController;
//        detailViewController.city = city;
//        NSLog(@"%@", city);
//    }
    if ([segue.identifier isEqualToString:@"ShowProjectContent"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        MCProjectContentViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.project = [[MCProjects shareData] projectAtIndexPath:indexPath];
    }
}


@end
