//
//  MCWorkNode.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCNodeDelegate.h"

@interface MCWorkNode : UIView <UIActionSheetDelegate> {
    CGPoint location;
}

@property (strong) UILabel *xLabel;
@property (strong) UILabel *yLabel;
@property (strong) NSString *task;
@property (strong) NSString *worker;
@property  bool status;
@property (strong) NSMutableArray *previousNodes;
@property (strong) id<MCNodeDelegate> delegate;

@property BOOL isMakingFather;
@property BOOL editing;

- (MCWorkNode *)initWithPoint:(CGPoint)point Seq:(int)seq Task:(NSString*)task Worker:(NSString*)worker Prev:(NSMutableArray*)previous Status:(bool)status Me:(NSString *)job;
+ (void)WorkNodeChange:(MCWorkNode *) finder Me:(NSString *)job;
+ (void)WorkNodeEdit:(MCWorkNode *) finder Task:(NSString *)task Worker:(NSString*)worker Previous:(NSMutableArray*)previous Me:(NSString *)job;

@end