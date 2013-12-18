//
//  MCProjectContentViewController.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MCDrawLine.h"
#import "MCNodeDelegate.h"

@protocol MCAddNodeDelegate <NSObject>

@optional
- (void)addNodeTask:(NSString *)task Worker:(NSString*)worker Previous:(NSMutableArray*)previous;

@end

@interface MCProjectContentViewController : UIViewController <MCAddNodeDelegate, MCNodeDelegate> {
    int seq;
}

#pragma mark - IBOutlet

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UISwitch *editSwitcher;
@property (strong, nonatomic) IBOutlet UIButton *addNodeButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;


#pragma mark - Properties

@property (strong, nonatomic) MCDrawLine *drawLine;
@property NSDictionary *project;
@property NSArray *workNodes;
@property BOOL isEditingProjectContent;

#pragma mark - IBAction

- (IBAction)saveWorkFlow:(id)sender;
- (IBAction)switcherToggled:(UISwitch *)sender;

#pragma mark - Instance Method

- (void) pushToServerTask:(NSString *)task Worker:(NSString *)worker Prev:(NSMutableArray *)previous Tag:(int)tag Status:(bool)status Location:(CGPoint) point;
- (void) pullFromServerProject;
- (void) refreshWorkNodes:(int)tag;
- (bool)checkFinished;

@end
