//
//  MCWokeNodeView.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/12/20.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCWokeNodeView.h"

@implementation MCWokeNodeView

- (instancetype)init {
    if (self = [super init]) {
        CGRect rect = CGRectMake(0, 0, 120, 60);
        self.frame = rect;
        self.TaskLabel = [UILabel new];
        self.workerLabel = [UILabel new];
        self.nodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
    }
    return self;
}

- (instancetype)initWithWorkNodeContent:(MCWorkNode *)workNodeContent {
    if (self = [self init]) {
        [self setClipsToBounds:NO];
        
        self.workNodeContent = workNodeContent;
        
        [self putNodeImage];
        
        CGSize imageSize = self.nodeImageView.frame.size;
        self.TaskLabel.text = self.workNodeContent.task;
        self.TaskLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        self.TaskLabel.frame = CGRectMake(imageSize.width+5, 0, 100, 25);
        self.TaskLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.TaskLabel];
        
        self.workerLabel.text = self.workNodeContent.worker;
        self.workerLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        self.workerLabel.frame = CGRectMake(imageSize.width+5, 25, 100, 20);
        self.workerLabel.textColor = [UIColor lightGrayColor];
        self.workerLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.workerLabel];
        
    }
    return self;
}

- (void)putNodeImage {
    if (self.workNodeContent.complete) {
        self.nodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"done.png"]];
    } else {
        self.nodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"undo.png"]];
    }
    
    [self addSubview:self.nodeImageView];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.viewControllerDelegate isEditingContent]) {
        [self.viewControllerDelegate disableScroll];
        NSLog(@"editing");
    } else if (self.workNodeContent.previousCompleteCountDown == 0 && !self.workNodeContent.complete) {
        NSLog(@"change complete");
        [self.workNodeContent changeState];
        [self putNodeImage];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.viewControllerDelegate isEditingContent]) {
        [self.viewControllerDelegate enableScroll];
    }
}
@end
