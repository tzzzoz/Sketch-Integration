//
//  DKDrawBoard.m
//  SketchWonderLand
//
//  Created by  on 12-4-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKDrawBoard.h"

@implementation DKDrawBoard
@synthesize waterColorPen, drawCanvas, isLikely;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
      // drawCanvasView =[[SmoothLineView alloc] initWithFrame:CGRectMake(110.0, 60.0, 860.0, 600.0)];
        drawCanvas = [[DKDrawCanvas alloc]init];
        waterColorPen = [[DKWaterColorPen alloc]init];
   //     state = YES;
        isLikely = YES;
        
      //  storke = [[NSMutableArray alloc]init];
    }
    
 //   [storke addObject:drawCanvasView.curImage];
    
    return self;
}

//-(void)drawComplete:(BOOL)isLike{
//    if (!isLike) {
//        
//    }
//}

@end
