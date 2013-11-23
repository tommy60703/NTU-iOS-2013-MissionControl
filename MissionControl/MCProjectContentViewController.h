//
//  MCProjectContentViewController.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCProjectContentViewController : UIViewController

@property (strong, nonatomic) NSDictionary *project;
@property (strong, nonatomic) IBOutlet UILabel *projectName;
@property (strong, nonatomic) IBOutlet UILabel *projectCreator;

@end
