//
//  MCJoinViewController.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCJoinViewController : UIViewController {
    NSArray *allProject;
}

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *projectName;
@property (strong, nonatomic) IBOutlet UITextField *userJob;
@property (strong, nonatomic) IBOutlet UILabel *projectCreator;

@end
