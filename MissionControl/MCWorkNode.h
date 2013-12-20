//
//  MCWorkNode.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProject.h"
#import "MCNodeDelegate.h"
#import "MCNodeEditDelegate.h"

@interface MCWorkNode : UIView <UIAlertViewDelegate>

#pragma mark - Properties

@property (strong) UIImageView *nodeImageView;
@property (strong) NSString *task;
@property (strong) NSString *worker;
@property (strong) NSMutableArray *previousNodes;   // array of MCWorkNode
@property (strong) id<MCNodeDelegate> viewControllerDelegate;     // should be the MCProjectContentViewController
@property (strong) id<MCNodeEditDelegate> editDelegate;

@property CGPoint location;
@property NSInteger previousNodesCompletionCountdown;
@property BOOL completion;
@property BOOL isMakingFather;
@property BOOL editing;

#pragma mark - Instance Methods

- (instancetype)initWithTask:(NSString *)task Worker:(NSString *)worker PreviousNodes:(NSArray*)previousNodes Completion:(BOOL)completion;
- (void)changeState;

@end