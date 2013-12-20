//
//  MCWokeNodeView.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/12/20.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCNodeDelegate.h"

@interface MCWokeNodeView : UIView

@property (strong, nonatomic) id<MCNodeDelegate> viewControllerDelegate;
@property (strong, nonatomic) MCWorkNode *workNodeContent;

@property (strong, nonatomic) UIImageView *nodeImageView;
@property (strong, nonatomic) UILabel *TaskLabel;
@property (strong, nonatomic) UILabel *workerLabel;
@property CGPoint position;

- (instancetype)initWithWorkNodeContent:(MCWorkNode *)workNodeContent;

@end
