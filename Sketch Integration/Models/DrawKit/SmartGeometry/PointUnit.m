//
//  PointUnit.m
//  Dudel
//
//  Created by tzzzoz on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PointUnit.h"

@implementation PointUnit

- (id)init
{
    self = [super init];
    if (self) {
        type=0;
    }
    
    return self;
}

-(id)initWithPoint:(SCPoint *)a 
{
    self = [super init];
    type=0;
    self.end.originalX = self.start.originalX = self.end.x = self.start.x = a.x;
    self.end.originalY = self.start.originalY = self.end.y = self.start.y = a.y;
    return self;
}

-(id)initWithPoints:(NSMutableArray *)points 
{
    self = [super init];
    SCPoint *middle;
    middle = [points objectAtIndex:[points count]/2];
    NSLog(@"%f,%f",middle.x,middle.y);
    type=0;
    self.end.originalX = self.start.originalX = self.end.x = self.start.x = middle.x;
    self.end.originalY = self.start.originalY = self.end.y = self.start.y = middle.y;
    
    return self;
}

-(void)drawWithContext:(CGContextRef)context
{
    CGContextFillEllipseInRect(context, CGRectMake(start.x, start.y, 10, 10));
}

-(void)setOriginal {
    start.originalX=start.x;
    start.originalY=start.y;
}

@end
