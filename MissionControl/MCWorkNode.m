//
//  MCWorkNode.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCWorkNode.h"

@implementation MCWorkNode

@synthesize xLabel, yLabel;

- (MCWorkNode *)initWithPoint:(CGPoint)point Seq:(int)seq Task:(NSString *)task Worker:(NSString *)worker Prev:(NSString *)previous {
    self = [super init];
    if (self) {
        UILongPressGestureRecognizer *longPressGestureRecognizer =
            [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(makingFather)];
        [self addGestureRecognizer:longPressGestureRecognizer];
        
        // Load undo circle image
        // set the view size of MCWorkNode as same as undo circle image
        UIImageView *dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"undo.png"]];
        CGSize imageSize = dotImageView.frame.size;
        self.frame = CGRectMake(point.x, point.y, imageSize.width, imageSize.height);
        [self addSubview:dotImageView];
        
        // set node's label
        xLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width + 1, 0.0, 20.0, 15.0)];
        yLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width + 1, 16.0, 20.0, 15.0)];
        
        UIFont *font = [UIFont fontWithName:@"Arial" size:10.0];
        xLabel.font = font;
        yLabel.font = font;
        xLabel.text = task;
        yLabel.text = worker;
        [xLabel setBackgroundColor:[UIColor clearColor]];
        [yLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:xLabel];
        [self addSubview:yLabel];
        
        // node's basic property settings
        self.tag = seq;
        self.task = task;
        self.worker = worker;
        self.previous = previous;
        [self setClipsToBounds:NO];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate disableScroll];
    
    // 將被觸碰到鍵移動到所有畫面的最上層
    [[self superview] bringSubviewToFront:self];
    CGPoint point = [[touches anyObject] locationInView:self];
    location = point;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    CGRect frame = self.frame;
    frame.origin.x += point.x - location.x;
    frame.origin.y += point.y - location.y;
    self.frame = frame;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moveWorkNodes" object:nil userInfo:nil];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate enableScroll];
}

- (void)makingFather {
    NSLog(@"loooooooooong press");
    if (!self.isMakingFather) {
        self.isMakingFather = YES;
        UIAlertView *newFatherAlert = [[UIAlertView alloc] initWithTitle:@"father" message:@"輸入新父點" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
        [newFatherAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [newFatherAlert show];
    }
    self.isMakingFather = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"%@", [alertView textFieldAtIndex:0].text);
        [self.previousNodes addObject:[alertView textFieldAtIndex:0].text];
    }
}

@end
