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

@property (strong, nonatomic) NSString *projectClassName;
@property (strong, nonatomic) PFObject *projectMeta;
@property (strong, nonatomic) NSMutableArray *workNodes;
@property (strong, nonatomic) NSDate *lastModifyTime;

+ (instancetype)shareInstance;

- (void)addWorkNode:(MCWorkNode *)node New:(BOOL)newObject;
- (MCWorkNode *)findNodeByTask:(NSString *)task;
- (void)addAPreviousNode:(MCWorkNode *)previousNode ToNode:(MCWorkNode *)node;

- (void)clean;
- (void)pullFromDatabase;
- (void)updateWorkNode:(MCWorkNode *)updateNode;

@end
