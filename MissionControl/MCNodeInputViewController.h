//
//  MCNodeInputViewController.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProjectContentViewController.h"

@protocol MCPreviousInputDelegate <NSObject>
@optional - (void)getPreviousList:(NSMutableArray *)selectPrevious;

@end


@interface MCNodeInputViewController : UIViewController <MCPreviousInputDelegate>

@property id<MCAddNodeDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *taskInput;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property NSArray *workerList;
@property NSArray *previousList;
@property NSMutableArray *previousSelectionList;
@property NSString *worker;

- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)doneButtonClick:(id)sender;

@end
