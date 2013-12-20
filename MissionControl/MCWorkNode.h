//
//  MCWorkNode.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCNodeDelegate.h"
#import "MCNodeEditDelegate.h"

@interface MCWorkNode : NSObject

#pragma mark - Properties

@property (strong) NSString *task;
@property (strong) NSString *worker;
@property (strong) NSMutableArray *previousNodes;

@property BOOL complete;
@property NSInteger previousCompleteCountDown;

#pragma mark - Instance Methods

- (instancetype)initWithTask:(NSString *)task Worker:(NSString *)worker PreviousNodes:(NSArray *)previousNodes Completion:(BOOL)completion;
- (NSInteger)getCountdown;
- (void)changeState;

@end