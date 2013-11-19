//
//  DetailViewController.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/11/19.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

//1242ersgvrawbtaz