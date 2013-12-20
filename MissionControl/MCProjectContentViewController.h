//
//  MCProjectContentViewController.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCDrawLine.h"
#import "MCNodeDelegate.h"

@interface MCProjectContentViewController : UIViewController <MCNodeDelegate>

#pragma mark - IBOutlet

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UISwitch *editSwitcher;
@property (strong, nonatomic) IBOutlet UIButton *addNodeButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

#pragma mark - Properties

@property (strong, nonatomic) NSString *passcode;
@property (strong, nonatomic) MCDrawLine *drawLine;
@property BOOL isEditingProjectContent;
@property NSInteger nodeNumber;

#pragma mark - IBAction

- (IBAction)saveWorkFlow:(id)sender;
- (IBAction)switcherToggled:(UISwitch *)sender;

#pragma mark - Instance Method

@end
