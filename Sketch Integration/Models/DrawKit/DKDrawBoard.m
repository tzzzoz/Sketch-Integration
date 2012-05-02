//
//  DKDrawBoard.m
//  SketchWonderLand
//
//  Created by  on 12-4-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKDrawBoard.h"

@implementation DKDrawBoard
@synthesize colorPenArray, drawCanvas, isLikely, boardState, geoPasterTemplate;

-(id)initWithBoardState:(BOOL)toDraw{
    self = [super init];
    if (self) {
        colorPenArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 18; i++) {
            DKWaterColorPen *waterColorPen = [[DKWaterColorPen alloc] initWithColorNumber:i];
            [colorPenArray addObject:waterColorPen];
        }
        
        //     state = YES;
        isLikely = YES;
        //YES means board is in the draw state and NO for edit
//        boardState = NO;
        if (toDraw) {
            drawCanvas = [[DKDrawCanvas alloc]init];
        }
    }
    return self;
}


//当画作完成是，判断识别出来的跟模板是否匹配，是的话就给予鼓励，并提示填充颜色，否则清空画纸，并提醒重画
-(void)drawComplete:(BOOL)isLike{
    if (!isLike) {
        //清空
        [self clearDrawWork];
    }
    else{
        
    }
}

//清空画纸
-(void)clearDrawWork{
    [drawCanvas.drawCanvasView deleteFunc];
    [drawCanvas.drawCanvasView setNeedsDisplay];
}

@end
