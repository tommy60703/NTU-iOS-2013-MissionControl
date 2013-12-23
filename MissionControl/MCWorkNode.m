//
//  MCWorkNode.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCWorkNode.h"
#import "MCNodeInputViewController.h"
@implementation MCWorkNode

@synthesize xLabel, yLabel;

- (MCWorkNode *)initWithPoint:(CGPoint)point Seq:(int)seq Task:(NSString *)task Worker:(NSString *)worker Prev:(NSMutableArray *)previous Status:(bool)status Me:(NSString *)job{
    self = [super init];
    if (self) {
        UILongPressGestureRecognizer *longPressGestureRecognizer =
            [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(makingFather)];
        [self addGestureRecognizer:longPressGestureRecognizer];
        
        // Load undo circle image
        // set the view size of MCWorkNode as same as undo circle image
        UIImageView *dotImageView;
        if (status == false && [worker isEqualToString:job]) {
        dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myundo.png"]];
        }
        else if(status == false && ![worker isEqualToString:job]){
        dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"undo.png"]];
        }
        else{
        dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"done.png"]];
        }
        CGSize imageSize = dotImageView.frame.size;
        self.frame = CGRectMake(point.x, point.y, imageSize.width, imageSize.height);
        [self addSubview:dotImageView];
        
        // set node's label
        xLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width+1, 5.0, 50.0, 20.0)];
        yLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width+1, 25.0, 50.0, 15.0)];
        
        UIFont *font = [UIFont fontWithName:@"helvetica" size:18.0];
        xLabel.font = font;
        font = [UIFont fontWithName:@"helvetica" size:15.0];
        yLabel.font = font;
        xLabel.text = task;
        yLabel.text = worker;
        [xLabel setBackgroundColor:[UIColor clearColor]];
        [yLabel setBackgroundColor:[UIColor clearColor]];
        yLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:xLabel];
        [self addSubview:yLabel];
        
        // node's basic property settings
        self.tag = seq;
        self.task = task;
        self.worker = worker;
        self.previousNodes = previous;
        self.status = status;
        [self setClipsToBounds:NO];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate isEditingContent]) {
        [self.delegate disableScroll];
        
        // 將被觸碰到鍵移動到所有畫面的最上層
        [[self superview] bringSubviewToFront:self];
        CGPoint point = [[touches anyObject] locationInView:self];
        location = point;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate isEditingContent]) {
        CGPoint point = [[touches anyObject] locationInView:self];
        CGRect frame = self.frame;
        frame.origin.x += point.x - location.x;
        frame.origin.y += point.y - location.y;
        self.frame = frame;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveWorkNodes" object:nil userInfo:nil];
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate isEditingContent]) {
        [self.delegate enableScroll];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveWorkNode" object:nil];
        
    }
    else{
        //self.status = (!self.status);
        NSDictionary *dict = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:self.tag] forKey:@"tag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishWorkNodes" object:self userInfo:dict];
    }
}

- (void)makingFather {
    if ([self.delegate isEditingContent]) {
        if (!self.isMakingFather) {
            self.isMakingFather = YES;
            UIActionSheet *action  =
            [[UIActionSheet alloc] initWithTitle:self.task
                                        delegate:self
                               cancelButtonTitle:@"取消"
                          destructiveButtonTitle:@"刪除"
                               otherButtonTitles:@"編輯", nil];

            [action showInView:self];   //顯示actionsheet
        }
        self.isMakingFather = NO;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject: [NSNumber numberWithInteger:self.tag] forKey:@"tag"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteWorkNode" object:self userInfo:dict];

    
    }else if (buttonIndex ==1){
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject: [NSNumber numberWithInteger:self.tag] forKey:@"tag"];
        [dict setValue:self.task forKey:@"task"];
        [dict setValue:self.worker forKey:@"worker"];
        [dict setValue:self.previousNodes forKey:@"previous"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editWorkNode" object:self userInfo:dict];
        NSLog(@"Delete message pressed.");

        NSLog(@"Option1 pressed.");
    }else{
        NSLog(@"Nothing happened.");
    }
}


+ (void)WorkNodeEdit:(MCWorkNode *) finder Task:(NSString *)task Worker:(NSString*)worker Previous:(NSMutableArray*)previous Me:(NSString *)job{

        finder.task = task;
        finder.worker = worker;
        finder.previousNodes = previous;
        for (UIImageView *oldimage in finder.subviews) {
            [oldimage removeFromSuperview];
        }
        UIImageView *dotImageView;
        if (finder.status == false && [worker isEqualToString:job]) {
            dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myundo.png"]];
        }
        else if(finder.status == false && ![worker isEqualToString:job]){
            dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"undo.png"]];
        }
        else{
            dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"done.png"]];
        }
        CGSize imageSize = dotImageView.frame.size;
        finder.frame = CGRectMake(finder.frame.origin.x, finder.frame.origin.y, imageSize.width, imageSize.height);
        [finder addSubview:dotImageView];
        
        // set node's label
        UILabel *AxLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width + 1, 5.0, 50.0, 20.0)];
        UILabel *AyLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width + 1, 25.0, 50.0, 15.0)];
        
        UIFont *font = [UIFont fontWithName:@"helvetica" size:18.0];
        AxLabel.font = font;
        font = [UIFont fontWithName:@"helvetica" size:15.0];
        AyLabel.font = font;
        AxLabel.text = finder.task;
        AyLabel.text = finder.worker;
        [AxLabel setBackgroundColor:[UIColor clearColor]];
        [AyLabel setBackgroundColor:[UIColor clearColor]];
        AyLabel.textColor = [UIColor lightGrayColor];
        [finder addSubview:AxLabel];
        [finder addSubview:AyLabel];
    
    
    }
+ (void)WorkNodeChange:(MCWorkNode *) finder Me:(NSString *)job{
    finder.status = !finder.status;
    for (UIImageView *oldimage in finder.subviews) {
        [oldimage removeFromSuperview];
    }
    UIImageView *dotImageView;
    if (finder.status == false && [finder.worker isEqualToString:job]) {
        dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myundo.png"]];
    }
    else if(finder.status == false && ![finder.worker isEqualToString:job]){
        dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"undo.png"]];
    }
    else{
        dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"done.png"]];
    }
    CGSize imageSize = dotImageView.frame.size;
    finder.frame = CGRectMake(finder.frame.origin.x, finder.frame.origin.y, imageSize.width, imageSize.height);
    [finder addSubview:dotImageView];
    
    // set node's label
    UILabel *AxLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width + 1, 5.0, 50.0, 20.0)];
    UILabel *AyLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageSize.width + 1, 25.0, 50.0, 15.0)];
    
    UIFont *font = [UIFont fontWithName:@"helvetica" size:18.0];
    AxLabel.font = font;
    font = [UIFont fontWithName:@"helvetica" size:15.0];
    AyLabel.font = font;
    AxLabel.text = finder.task;
    AyLabel.text = finder.worker;
    [AxLabel setBackgroundColor:[UIColor clearColor]];
    [AyLabel setBackgroundColor:[UIColor clearColor]];
    AyLabel.textColor = [UIColor lightGrayColor];
    [finder addSubview:AxLabel];
    [finder addSubview:AyLabel];
    
}
@end
