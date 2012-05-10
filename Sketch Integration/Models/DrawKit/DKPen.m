//
//  DKPen.m
//  SketchWonderLand
//
//  Created by  on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKPen.h"

@implementation DKPen
@synthesize color, penDrawState, penSelectedState; 

-(id)init
{
    self = [super init];
    if(self)
    {
        penDrawState = YES;
        penSelectedState = NO;
        
        UIColor* colorTemp = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        color = [[DKColor alloc]initWithColorType:black ImageView:NULL Color:colorTemp];
    }
    return self;
}

-(void)setColorWithColor:(UIColor *)colorForUI
{
    color.color = colorForUI;
}

-(void)dealloc
{
    [color release];
    [super dealloc];
}

@end