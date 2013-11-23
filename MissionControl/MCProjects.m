//
//  MCProjects.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCProjects.h"
#import "NSArray+JSON.h"

NSString * const MCProjectNameKey = @"name";
NSString * const MCProjectCodeKey = @"code";
NSString * const MCProjectCreatorKey = @"creator";

@implementation MCProjects

+(MCProjects*)shareData {
    static MCProjects *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [self new];
    });
    return shareInstance;
}

-(id)init {
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test-projects" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        id JSONObject = [NSArray arrayWithContentsOfJSONData:data];
        projects = [JSONObject objectForKey:@"projects"];
        count = [[JSONObject objectForKey:@"count"] integerValue];
    }
    return self;
}

-(NSDictionary *)projectForCode:(int)code {
    NSDictionary *result;
    for (NSDictionary *project in projects) {
        if ([project[MCProjectCodeKey] integerValue] == code) {
            result = project;
        }
    }
    return result;
}

-(int)count {
    return count;
}

- (NSDictionary *)projectAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *continentName = [self arrayWithContinents][indexPath.section];
//    NSDictionary *city = [self arrayWithCityInContinent:continentName][indexPath.row];
    
    return projects[indexPath.row];
}

@end
