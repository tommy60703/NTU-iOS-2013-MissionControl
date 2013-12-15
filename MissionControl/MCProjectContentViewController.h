//
//  MCProjectContentViewController.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MCDrawLine.h"
@protocol MCAddNodeDelegate <NSObject>

@optional
- (void)addNodeTask:(NSString *)task Worker:(NSString*)worker Previous:(NSString*)previous;

@end


@interface MCProjectContentViewController : UIViewController <MCAddNodeDelegate>{
    int seq;
}
- (IBAction)saveWorkFlow:(id)sender;

- (void) pushToServerTask:(NSString *)task Worker:(NSString *)worker Prev:(NSString *)previous Tag:(int)tag Status:(bool)status Location:(CGPoint) point;
- (void) pullFromServerProject;
@property (strong, nonatomic) MCDrawLine *drawLine;
@property NSDictionary *project;
@property NSArray *WorkNodes;
@end
