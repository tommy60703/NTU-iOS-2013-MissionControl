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
- (void)addNodeTask:(NSString *)task Worker:(NSString*)worker Previous:(NSMutableArray*)previous Tag:(int)tag;

@end

@interface MCProjectContentViewController : UIViewController <MCAddNodeDelegate, MCNodeDelegate> {
    int seq;
}

#pragma mark - IBOutlet

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addNodeButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *resetButton;


#pragma mark - Properties

@property (strong, nonatomic) MCDrawLine *drawLine;
@property NSDictionary *project;
@property NSArray *workNodes;
@property NSArray *workerList;
@property NSMutableArray *previousList;
@property BOOL isEditingProjectContent;

#pragma mark - IBAction

- (void)saveWorkFlow;
- (IBAction)editPressed:(UIBarButtonItem *)sender;
- (IBAction)resetPressed:(id)sender;

#pragma mark - Instance Method

- (void) pushToServerTask:(NSString *)task Worker:(NSString *)worker Prev:(NSMutableArray *)previous Tag:(int)tag Status:(BOOL)status Location:(CGPoint) point;
- (void) pullFromServerProject;
- (void) refreshWorkNodes:(int)tag;
- (BOOL)checkFinished;

@end
