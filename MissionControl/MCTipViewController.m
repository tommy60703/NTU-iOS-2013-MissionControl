//
//  MCTipViewController.m
//  MissionControl
//
//  Created by Pai YuXuan on 12/22/13.
//  Copyright (c) 2013 Tommy Lin. All rights reserved.
//

#import "MCTipViewController.h"

@interface MCTipViewController ()
@property (strong, nonatomic) NSArray *images;
@end

@implementation MCTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *tip0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip0.png"]];
    UIImageView *tip4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip4.png"]];
    UIImageView *tip1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip1.png"]];
    UIImageView *tip2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip2.png"]];
    tip0.contentMode = tip4.contentMode = tip1.contentMode = tip2.contentMode = UIViewContentModeScaleAspectFit;
    self.images = @[tip0, tip4, tip1, tip2];
    
    CGRect rect = self.scrollView.frame;
    tip0.frame = rect;
    tip4.frame = CGRectOffset(tip0.frame, tip0.frame.size.width, 0);
    tip1.frame = CGRectOffset(tip4.frame, tip4.frame.size.width, 0);
    tip2.frame = CGRectOffset(tip1.frame, tip1.frame.size.width, 0);
    
    CGSize size = CGSizeMake(tip0.frame.size.width * 4, rect.origin.y);
    self.scrollView.contentSize = size;
    
    for (UIImageView *tip in self.images) {
        [self.scrollView addSubview:tip];
    }
    
    self.pageControl.numberOfPages = self.images.count;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 1;
    self.pageControl.currentPage = currentPage;
//    NSLog(@"%d",currentPage);
//    self.pageIndicator.text = [NSString stringWithFormat:@"%d/%d", currentPage+1, self.images.count];
}

@end