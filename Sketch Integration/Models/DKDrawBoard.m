//
//  DKDrawBoard.m
//  SketchWonderLand
//
//  Created by  on 12-4-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKDrawBoard.h"

@implementation DKDrawBoard
@synthesize waterColorPen, drawCanvasView;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
       drawCanvasView =[[SmoothLineView alloc] initWithFrame:CGRectMake(110.0, 60.0, 860.0, 600.0)];
        waterColorPen = [[DKWaterColorPen alloc]init];
    }
    
    return self;
}

@end
