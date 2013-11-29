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

- (void)viewDidLoad {
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"projectContent.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSLog(@"NO");
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"projectContent" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
    [self addToMyPlist];
}

/* Code to write into file */

- (void)addToMyPlist {
    // check if file exists
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    plistPath = [plistPath stringByAppendingPathComponent:@"projectContent.plist"];
    
    // get data from plist file
    NSMutableArray *plistArray = [[NSMutableArray alloc]
                                  initWithContentsOfFile:plistPath];
    
    // create dictionary using array data and bookmarkKeysArray keys
    NSArray *keysArray = [[NSArray alloc] initWithObjects:@"StudentNo", nil];
    NSArray *valuesArray = [[NSArray alloc] initWithObjects:
                            [NSString stringWithFormat:@"1234"], nil];
    
    NSDictionary *plistDict = [[NSDictionary alloc]
                              initWithObjects:valuesArray
                              forKeys:keysArray];
    
    [plistArray addObject:plistDict];
    
    // write data to  plist file
    //BOOL isWritten = [plistArray writeToFile:plistPath atomically:YES];
    [plistArray writeToFile:plistPath atomically:YES];
}



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
//        MCProjectContentViewController *destinationViewController = segue.destinationViewController;
//        destinationViewController.project = [[MCProjects shareData] projectAtIndexPath:indexPath];
    }
}


@end
