//
//  MCWorkNode.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCWorkNode.h"

@implementation MCWorkNode

#pragma mark - Lifecycle

- (instancetype)initWithTask:(NSString *)task Worker:(NSString *)worker PreviousNodes:(NSArray *)previousNodes Completion:(BOOL)completion {
    if (self = [super init]) {
        // node's basic property settings
        self.task = task;
        self.worker = worker;
        self.previousNodes = (NSMutableArray *)previousNodes;
        self.previousNodesCompletionCountdown = self.previousNodes.count;
        self.completion = completion;
        [self setClipsToBounds:NO];
        
        // Add Long Press Gesture Recognizer
        UILongPressGestureRecognizer *longPressGestureRecognizer =
        [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editNode)];
        [self addGestureRecognizer:longPressGestureRecognizer];
        
        // Load undo circle image
        // set the view size of MCWorkNode as same as undo circle image
        self.nodeImageView = completion ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"done.png"]] :
                                            [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"undo.png"]];
        
        CGSize imageSize = self.nodeImageView.frame.size;
        self.frame = CGRectMake(120, 150, imageSize.width, imageSize.height);
        [self addSubview:self.nodeImageView];
        
        // set node's label
        UILabel *taskNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width+5, 5.0, 100.0, 20.0)];
        UIFont *taskFont = [UIFont fontWithName:@"helvetica" size:18.0];
        taskNameLabel.font = taskFont;
        taskNameLabel.text = task;
        [taskNameLabel setBackgroundColor:[UIColor clearColor]];
        
        UILabel *workerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width+5, 22.0, 100.0, 20.0)];
        UIFont *workerFont = [UIFont fontWithName:@"helvetica" size:15.0];
        workerNameLabel.font = workerFont;
        workerNameLabel.text = worker;
        [workerNameLabel setBackgroundColor:[UIColor clearColor]];
        workerNameLabel.textColor = [UIColor lightGrayColor];
        
        [self addSubview:taskNameLabel];
        [self addSubview:workerNameLabel];
    }
    return self;
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.viewControllerDelegate isEditingContent]) {
        [self.viewControllerDelegate disableScroll];
        
        // 將被觸碰到鍵移動到所有畫面的最上層
        [[self superview] bringSubviewToFront:self];
        CGPoint point = [[touches anyObject] locationInView:self];
        self.location = point;
    } else {
        [self changeState];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.viewControllerDelegate isEditingContent]) {
        // Move the node
        CGPoint point = [[touches anyObject] locationInView:self];
        CGRect frame = self.frame;
        frame.origin.x += point.x - self.location.x;
        frame.origin.y += point.y - self.location.y;
        self.frame = frame;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveWorkNodes" object:nil userInfo:nil];
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.viewControllerDelegate isEditingContent]) {
        [self.viewControllerDelegate enableScroll];
    } else {
        NSDictionary *dict = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:self.tag] forKey:@"tag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishWorkNodes" object:self userInfo:dict];
    }
}

#pragma mark - Instance Methods

- (void)changeState {
    self.completion = !self.completion;
    self.nodeImageView = self.completion ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"done.png"]] :
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"undo.png"]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"completion"]) {
        self.previousNodesCompletionCountdown -= 1;
    }
}

#pragma mark - Private Methods

- (void)editNode {
    if ([self.viewControllerDelegate isEditingContent]) {
        if (!self.isMakingFather) {
            self.isMakingFather = YES;
            UIAlertView *newFatherAlert = [[UIAlertView alloc] initWithTitle:@"輸入上一個工作" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
            [newFatherAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [newFatherAlert show];
        }
        self.isMakingFather = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"%@", [alertView textFieldAtIndex:0].text);
        MCWorkNode *prev = [self.editDelegate findNodeByTask:[alertView textFieldAtIndex:0].text];
        [self.editDelegate addAPreviousNode:prev ToNode:self];
        [self.previousNodes addObject:[alertView textFieldAtIndex:0].text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveWorkNodes" object:nil userInfo:nil];
    }
}

@end
