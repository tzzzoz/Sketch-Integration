//
//  DKDrawBoard.h
//  SketchWonderLand
//
//  Created by  on 12-4-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKWaterColorPen.h"
#import "SmoothLineView.h"

@class DKWaterColorPen;
@class SmoothLineView;

@interface DKDrawBoard : NSObject{
    DKWaterColorPen *waterColorPen;
    SmoothLineView *drawCanvasView;
}

@property (retain, nonatomic) DKWaterColorPen* waterColorPen;
@property (retain, nonatomic) SmoothLineView* drawCanvasView;

@end
