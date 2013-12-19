//
//  MCProjects.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCBrain.h"

@interface MCBrain ()

@end

@implementation MCBrain

#pragma mark - Lifecycle

+ (MCBrain *)shareInstance {
    static MCBrain *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [self new];
    });
    return shareInstance;
}

- (id)init {
    if (self = [super init]) {
        self.deviceUDID = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProjects) name:@"doUpdateProjects" object:nil];
    }
    return self;
}

+ (NSInteger)getUniquePasscode {
    NSInteger random = 0;
    BOOL unique = NO;
    while (!unique) {
        random = arc4random() % 9000 + 1000;
        PFQuery *query =[PFQuery queryWithClassName:@"project"];
        [query whereKey:@"projectPasscode" equalTo:[NSNumber numberWithInt:random]];
        NSArray *equalArray = [query findObjects];
        if (equalArray.count != 0) {
            NSLog(@"same code, wait for another random code");
        } else {
            unique = YES;
        }
    }
    return random;
}

- (void)updateProjects {
    PFQuery *query = [PFQuery queryWithClassName:@"projectParticipate"];
    [query whereKey:@"user" equalTo:self.deviceUDID];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"MCBrain is loading projects asynchronously");
        self.projects = [query findObjects];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateProjects" object:self];
        });
    });

}

@end
