//
//  MCTipViewController.h
//  MissionControl
//
//  Created by Pai YuXuan on 12/22/13.
//  Copyright (c) 2013 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCTipViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    BOOL pageControlBeingUsed;
}

@property NSInteger page;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage;
- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *done2;
@property (weak, nonatomic) IBOutlet UILabel *pageIndicator;

@end