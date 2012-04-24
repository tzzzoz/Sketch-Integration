//
//  DKDrawBoard.h
//  SketchWonderLand
//
//  Created by  on 12-4-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKWaterColorPen.h"
#import "DKDrawCanvas.h"

@class DKWaterColorPen;
@class BroadView;

@interface DKDrawBoard : NSObject{
    DKWaterColorPen *waterColorPen;
    DKDrawCanvas *drawCanvas;
    BOOL isLikely;
    
 //   NSMutableArray *storke;
    
    
    
   // @private
 //   BOOL state;
}

@property (retain, nonatomic) DKWaterColorPen* waterColorPen;
@property (retain, nonatomic) DKDrawCanvas* drawCanvas;
@property (nonatomic) BOOL isLikely;

//-(void)drawComplete:(BOOL)isLike;

@end
