//
//  MCNodeDelegate.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/15.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCNodeDelegate <NSObject>

@required
- (void)disableScroll;
- (void)enableScroll;
- (BOOL)isEditingContent;

@optional
- (void)addNodeTask:(NSString *)task Worker:(NSString*)worker Previous:(NSMutableArray*)previous;
@end
