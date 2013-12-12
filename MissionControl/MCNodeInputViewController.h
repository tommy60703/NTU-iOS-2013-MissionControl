//
//  MCNodeInputViewController.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProjectContentViewController.h"


@interface MCNodeInputViewController : UIViewController

@property id<MCAddNodeDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *taskInput;
@property (strong, nonatomic) IBOutlet UITextField *workerInput;
@property (strong, nonatomic) IBOutlet UITextField *previousInput;

- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)doneButtonClick:(id)sender;

@end
