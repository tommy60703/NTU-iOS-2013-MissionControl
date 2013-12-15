//
//  MCDrawLine.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/15.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCDrawLine.h"

@implementation MCDrawLine
@synthesize beginPoint;
@synthesize endPoint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawLine:(CGContextRef)context Begin:(CGPoint)begin End:(CGPoint)end{
    NSLog(@"x:(%f, %f)", begin.x, begin.y);
    NSLog(@"x:(%f, %f)", end.x, end.y);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextMoveToPoint(context, begin.x, begin.y);
    CGContextAddLineToPoint(context, end.x , end.y);
    
    CGContextStrokePath(context);

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.beginPoint = CGPointMake(100, 100);
    self.endPoint = CGPointMake(200, 200);
    
    [self drawLine:context Begin:self.beginPoint End:self.endPoint];
}


@end
