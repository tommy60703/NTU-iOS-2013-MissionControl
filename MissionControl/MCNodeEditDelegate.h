//
//  MCNodeEditDelegate.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/12/19.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCWorkNode, MCProject;
@protocol MCNodeEditDelegate <NSObject>

@optional
- (MCWorkNode *)findNodeByTask:(NSString *)task;
- (void)addAPreviousNode:(MCWorkNode *)previousNode ToNode:(MCWorkNode *)node;

@end
