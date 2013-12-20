//
//  MCProjects.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCBrain : NSObject

@property (strong, nonatomic) NSString *deviceUDID;
@property (strong, nonatomic) NSArray *projectMetas;

+ (MCBrain *)shareInstance;
+ (NSInteger)getUniquePasscode;

- (void)updateProjects;

@end