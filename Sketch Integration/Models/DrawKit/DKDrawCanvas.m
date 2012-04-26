//
//  DKDrawCanvas.m
//  Sketch Integration
//
//  Created by  on 12-4-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKDrawCanvas.h"

@implementation DKDrawCanvas
@synthesize drawCanvasView;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
//        strokes = [[NSMutableArray alloc]init];
//        points = [[NSMutableArray alloc]init];
        drawCanvasView =[[BroadView alloc] initWithFrame:CGRectMake(110.0, 60.0, 860.0, 600.0)];
    }
    
    return self;
}

@end
