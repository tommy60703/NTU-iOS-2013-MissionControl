//
//  MCWorkNode.h
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/12.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCWorkNode : UIView{
    CGPoint location;
}

@property (strong)UILabel *xLabel;
@property (strong)UILabel *yLabel;
@property (strong)NSString *task;
@property (strong)NSString *worker;
@property (strong)NSString *previous;

-(MCWorkNode *)initWithPoint:(CGPoint)point Seq:(int)seq Task:(NSString*)task Worker:(NSString*)worker Prev:(NSString*)previous;

@end
