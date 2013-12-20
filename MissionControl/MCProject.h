//
//  MCProject.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/12/19.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCWorkNode.h"
#import "MCNodeEditDelegate.h"

@interface MCProject : PFObject <MCNodeEditDelegate>
@property (strong, nonatomic) NSMutableArray *workNodes;

- (void)addWorkNode:(MCWorkNode *)node;
- (MCWorkNode *)findNodeByTask:(NSString *)task;
- (void)addAPreviousNode:(MCWorkNode *)previousNode ToNode:(MCWorkNode *)node;

@end
