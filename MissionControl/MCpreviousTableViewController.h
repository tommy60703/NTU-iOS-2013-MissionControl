//
//  MCpreviousTableViewController.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/20.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCNodeInputViewController.h"
@interface MCpreviousTableViewController : UITableViewController

@property id<MCPreviousInputDelegate> delegate;
@property (strong, nonatomic) NSArray *previousList;
@property NSMutableArray *previousSelectionList;
@end
