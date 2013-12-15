//
//  MCDrawLine.m
//  MissionControl
//
//  Created by 楊順堯 on 2013/12/15.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCDrawLine.h"
#import <Parse/Parse.h>
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

- (void)drawLine:(CGContextRef)context{
    
    
    
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    for (PFObject *point1 in self.points) {
        for (PFObject *point2 in self.points) {
            if ([[point1 objectForKey:@"previous"] isEqualToString:[point2 objectForKey:@"task"]]) {
                CGContextMoveToPoint(context, [[point1 objectForKey:@"location_x"] floatValue]+30, [[point1 objectForKey:@"location_y"] floatValue]+30);
                CGContextAddLineToPoint(context,[[point2 objectForKey:@"location_x"] floatValue]+30, [[point2 objectForKey:@"location_y"] floatValue]+30);
                
                CGContextStrokePath(context);
            }
        }
    }
   
}

- (void)addPoints:(NSMutableArray *)allpoints{
    //NSLog(@"%@",allpoints);
    self.points = allpoints;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawLine:context];
}


@end
