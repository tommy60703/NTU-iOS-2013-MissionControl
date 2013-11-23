//
//  NSArray+JSON.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSON)

+ (instancetype)arrayWithContentsOfJSONData:(NSData *)data;

@end
