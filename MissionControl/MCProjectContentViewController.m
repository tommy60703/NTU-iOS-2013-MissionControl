//
//  MCProjectContentViewController.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCProjectContentViewController.h"
#import "MCNodeInputViewController.h"
#import "MCWorkNode.h"
#import "MCWokeNodeView.h"

@interface MCProjectContentViewController ()
//@property (strong, nonatomic) NSTimer *syncWithServerTimer;
@property BOOL finished;
@end

@implementation MCProjectContentViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initCanvas) name:@"projectContentLoaded" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCanvas) name:@"newNodeAdded" object:nil];
    
    CGSize size = self.view.frame.size;
    self.myScrollView.contentSize = CGSizeMake(size.width, size.height*2);
    
    self.isEditingProjectContent = NO;
    self.finished = NO;
    self.editSwitcher.hidden = [[MCBrain shareInstance].deviceUDID isEqualToString:[MCProject shareInstance].projectMeta[@"owner"]] ? NO:YES;
    self.addNodeButton.hidden = YES;
    self.saveButton.hidden = YES;
    
    [[MCProject shareInstance] clean];
    [[MCProject shareInstance] pullFromDatabase];
}

-(void)viewWillAppear:(BOOL)animated {
    if (!self.isEditingProjectContent) {
//        self.syncWithServerTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(pullProjectContent) userInfo:nil repeats:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self.syncWithServerTimer invalidate];
}

- (void)pullProjectContent {
    [[MCProject shareInstance] pullFromDatabase];
}

- (void)initCanvas {
    NSInteger count = 100;
    for (MCWorkNode *node in [MCProject shareInstance].workNodes) {
        MCWokeNodeView *newNodeView = [[MCWokeNodeView alloc] initWithWorkNodeContent:node];
        newNodeView.center = CGPointMake(100, count);
        [self.myScrollView addSubview:newNodeView];
        count += 100;
    }
}


#pragma mark - IBAction

- (IBAction)saveWorkFlow:(id)sender {
    
}

- (IBAction)switcherToggled:(UISwitch *)sender {
    
}


- (void)drawAllLines {
    for (UIView *subview in self.myScrollView.subviews) {
        if (subview.tag == -1) {
            [subview removeFromSuperview];
        }
    }
    CGSize size = self.myScrollView.frame.size;
    self.drawLine = [[MCDrawLine alloc] initWithFrame:CGRectMake(0, 0, size.width , size.height)];
    [self.drawLine setBackgroundColor:[UIColor whiteColor]];
    [self.drawLine addPoints:[MCProject shareInstance].workNodes];
    self.drawLine.tag = -1;
    [self.myScrollView insertSubview:self.drawLine atIndex:0];
    
}

#pragma mark - MCNodeDelegate

- (void)disableScroll {
    self.myScrollView.scrollEnabled = NO;
}

- (void)enableScroll {
    self.myScrollView.scrollEnabled = YES;
}

- (BOOL)isEditingContent {
    return self.isEditingProjectContent;
}

@end
