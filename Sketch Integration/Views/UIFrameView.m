//
//  UIFrameView.m
//  Sketch Integration
//
//  Created by kwan terry on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIFrameView.h"

@implementation UIFrameView

@synthesize isFoul,currentPasterView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(currentPasterView.isGeometrySelected && !isFoul)
        [currentPasterView drawFrameWithContext:context];
}


@end
