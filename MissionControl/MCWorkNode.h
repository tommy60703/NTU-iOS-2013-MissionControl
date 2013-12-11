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

-(MCWorkNode *)initWithPoint:(CGPoint)point;

@end
