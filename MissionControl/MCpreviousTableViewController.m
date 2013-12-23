//
//  MCpreviousTableViewController.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/20.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCpreviousTableViewController.h"

@interface MCpreviousTableViewController ()

@end

@implementation MCpreviousTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.previousSelectionList = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadPreviousList:) name:@"LoadPreviousList" object:nil];

    self.delegate = [self.storyboard instantiateViewControllerWithIdentifier:@"NodeInputController"];
    
    //NSLog(@"%d", [self.delegate getPreviousList].count);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.previousList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell...
    NSString *previousForThisCell = [self.previousList objectAtIndex:indexPath.row];
    
    UILabel *previousTask = (UILabel *)[cell viewWithTag:1001];
    
    previousTask.text = previousForThisCell;
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellText = self.previousList[indexPath.row];
    NSLog(@"%@", cellText);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.previousSelectionList addObject:cellText];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:self.previousSelectionList forKey:@"previousSelectionList"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPreviousList" object:self userInfo:dict];
        //NSLog(@"%@",self.previousSelectionList);
//        [self.delegate getPreviousList:self.previousSelectionList];
        
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.previousSelectionList removeObject:cellText];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:self.previousSelectionList forKey:@"previousSelectionList"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPreviousList" object:self userInfo:dict];

//        [self.delegate getPreviousList:self.previousSelectionList];
        //[self.delegate deletePreviousList:cellText];

    }
    
    
}

-(void)LoadPreviousList:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    
    self.previousList = [dict valueForKey:@"previousList"];
    NSArray *prevSelect;
    if ([[dict valueForKey:@"tag"]integerValue] != -1) {
        prevSelect = [dict valueForKey:@"previous"];
        NSLog(@"%@", prevSelect);
        //NSIndexPath *indexPath = ;
        
    }
//    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            for (NSString *prev in prevSelect) {
                if([self.previousList[i] isEqualToString:prev]){
                    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].accessoryType = UITableViewCellAccessoryCheckmark;
                    [self.previousSelectionList addObject:self.previousList[i]];
                    NSDictionary *dict1 = [NSDictionary dictionaryWithObject:self.previousSelectionList forKey:@"previousSelectionList"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPreviousList" object:self userInfo:dict1];
                }
//            [cells addObject:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
            }
        }
    }
    
}
@end
