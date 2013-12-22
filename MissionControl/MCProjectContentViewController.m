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
@property (strong, nonatomic) NSTimer *checkModifyTimer;
@property BOOL finished;

@property BOOL checking;
@end

@implementation MCProjectContentViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initCanvas) name:@"projectContentLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initCanvas) name:@"newNodeAdded" object:nil];
    
    CGSize size = self.view.frame.size;
    self.myScrollView.contentSize = CGSizeMake(size.width, size.height*2);
    
    self.isEditingProjectContent = NO;
    self.finished = NO;
    self.editSwitcher.hidden = [[MCBrain shareInstance].deviceUDID isEqualToString:[MCProject shareInstance].projectMeta[@"owner"]] ? NO:YES;
    self.addNodeButton.hidden = YES;
    self.saveButton.hidden = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self pullProjectContent];
    });
    
    self.checkModifyTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkModify) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {

}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.checkModifyTimer invalidate];
    [[MCProject shareInstance] clean];
}

- (void)checkModify {
    NSLog(@"checking, %d nodes in canvas", self.myScrollView.subviews.count);
    if (!self.checking) {
        self.checking = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            PFQuery *query = [PFQuery queryWithClassName:@"project"];
            PFObject *object = [query getObjectWithId:[MCProject shareInstance].projectMeta[@"idOfProjectClass"]];
            if (![[MCProject shareInstance].lastModifyTime isEqualToDate:object[@"lastModifyTime"]]) {
                NSLog(@"need to update");
                [self pullProjectContent];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initCanvas];
                });

            }
        });
    }
    self.checking = NO;
}

- (void)pullProjectContent {
    [[MCProject shareInstance] pullFromDatabase];
}

- (void)initCanvas {
    NSInteger count = 100;
    for (UIView *view in self.myScrollView.subviews) {
        [view removeFromSuperview];
    }
    for (MCWorkNode *node in [MCProject shareInstance].workNodes) {
        MCWokeNodeView *newNodeView = [[MCWokeNodeView alloc] initWithWorkNodeContent:node];
        newNodeView.viewControllerDelegate = self;
        newNodeView.center = CGPointMake(100, count);
        [self.myScrollView addSubview:newNodeView];
        count += 100;
    }
}

#pragma mark - IBAction

- (IBAction)saveWorkFlow:(id)sender {
    
}

- (IBAction)switcherToggled:(UISwitch *)sender {
    self.isEditingProjectContent = !self.isEditingProjectContent;
    self.addNodeButton.hidden = !self.addNodeButton.hidden;
    self.saveButton.hidden = !self.saveButton.hidden;
    
    if (self.isEditingProjectContent) {
        [self.checkModifyTimer invalidate];
    } else {
        self.checkModifyTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkModify) userInfo:nil repeats:YES];
    }
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
