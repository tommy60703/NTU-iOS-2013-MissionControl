//
//  MCTipViewController.m
//  MissionControl
//
//  Created by Pai YuXuan on 12/22/13.
//  Copyright (c) 2013 Tommy Lin. All rights reserved.
//

#import "MCTipViewController.h"

@interface MCTipViewController ()

@end

@implementation MCTipViewController
@synthesize scrollView,pageControl;

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeingUsed) {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *images = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"tip1.png"], [UIImage imageNamed:@"tip2.png"], nil];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*images.count, self.scrollView.frame.size.height);
    [scrollView setShowsHorizontalScrollIndicator: NO];
    
    [scrollView setShowsVerticalScrollIndicator: NO];
    
    for (int i = 0; i < images.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width*i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        UIImageView* imgView = [[UIImageView alloc] init];
        imgView.image = [images objectAtIndex:i];
        imgView.frame = frame;
        [scrollView addSubview:imgView];
    }
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = images.count;
    [self.view insertSubview:pageControl atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.pageControl = nil;
}

- (IBAction)changePage{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated: YES];
    pageControlBeingUsed = YES;
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end