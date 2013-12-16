//
//  MCDrawLine.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/15.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCDrawLine : UIView

@property CGPoint beginPoint;
@property CGPoint endPoint;
@property NSArray *points;

- (void)addPoints:(NSMutableArray *)allpoints;

@end
