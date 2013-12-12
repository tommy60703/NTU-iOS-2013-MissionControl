//
//  MCProjectContentViewController.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCAddNodeDelegate <NSObject>

@optional
- (void)addNodeTask:(NSString *)task Worker:(NSString*)worker Previous:(NSString*)previous;

@end


@interface MCProjectContentViewController : UIViewController <MCAddNodeDelegate>
- (IBAction)addWorkNode:(id)sender;
@property NSDictionary *project;
@end
