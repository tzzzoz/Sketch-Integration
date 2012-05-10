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
#import "DKColorPalette.h"
#import "PKGeometryPasterTemplate.h"

@class DKWaterColorPen;
@class BroadView;

@interface DKDrawBoard : NSObject
{
    DKColorPalette  *colorPalette;
    DKWaterColorPen *waterColorPen;
    DKDrawCanvas    *drawCanvas;
    PKGeometryPasterTemplate *geoPasterTemplate;
    
    //判断drawWork跟提供的模板相似度，如果相似，则提示完成，drawWork入库，跳转到贴贴纸界面（）
    BOOL isLikely;
    //画板时候需要显示
    BOOL isBoardShow;
}

@property (retain,nonatomic) DKColorPalette     *colorPalette;
@property (retain,nonatomic) DKWaterColorPen    *waterColorPen;
@property (retain,nonatomic) DKDrawCanvas       *drawCanvas;
@property (retain,nonatomic) PKGeometryPasterTemplate *geoPasterTemplate;
@property (assign,nonatomic) BOOL isLikely;
@property (assign,nonatomic) BOOL isBoardShow;

-(id)initWithBoardState:(BOOL)toDraw;
-(void)drawComplete:(BOOL)isLike;
-(void)clearDrawWork;

//没实现
//-(BOOL)compareDrawWorkWithTemplate:(PKGeometryPasterTemplate *) geoPasterTemplate;

@end
