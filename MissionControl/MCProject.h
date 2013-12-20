//
//  MCProject.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/12/19.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCWorkNode.h"

@interface MCProject : NSObject

@property (strong, nonatomic) NSDictionary *projectMeta;
@property (strong, nonatomic) NSMutableArray *workNodes;

+ (instancetype)shareInstance;

- (void)addWorkNode:(MCWorkNode *)node;
- (MCWorkNode *)findNodeByTask:(NSString *)task;
- (void)addAPreviousNode:(MCWorkNode *)previousNode ToNode:(MCWorkNode *)node;

- (void)clean;
- (void)pushToDatabase;
- (void)pullFromDatabase;

@end
