//
//  NSArray+JSON.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "NSArray+JSON.h"

@implementation NSArray (JSON)

+(instancetype)arrayWithContentsOfJSONData:(NSData *)data {
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

@end
