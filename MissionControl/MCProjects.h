//
//  MCProjects.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCProjects : NSObject {
    NSArray *projects;
    int count;
}
+(MCProjects *)shareData;
-(NSDictionary *)projectForCode:(int)code;
-(int)count;
-(NSDictionary *)projectAtIndexPath:(NSIndexPath *)indexPath;
@end

extern NSString * const MCProjectNameKey;
extern NSString * const MCProjectCodeKey;
extern NSString * const MCProjectCreatorKey;

