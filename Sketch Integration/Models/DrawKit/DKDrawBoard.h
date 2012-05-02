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
#import "PKGeometryPasterTemplate.h"

@class DKWaterColorPen;
@class BroadView;

@interface DKDrawBoard : NSObject{
    NSMutableArray *colorPenArray;
//    DKWaterColorPen *waterColorPen;
    DKDrawCanvas *drawCanvas;
    PKGeometryPasterTemplate *geoPasterTemplate;
    //判断drawWork跟提供的模板相似度，如果相似，则提示完成，drawWork入库，跳转到贴贴纸界面（）
    BOOL isLikely;
    
 //   NSMutableArray *storke;
    
    
    
   // @private
    BOOL boardState;
}

@property (retain, nonatomic) NSMutableArray* colorPenArray;
//@property (retain, nonatomic) DKWaterColorPen* waterColorPen;
@property (retain, nonatomic) DKDrawCanvas* drawCanvas;
@property (retain, nonatomic) PKGeometryPasterTemplate *geoPasterTemplate;
@property (nonatomic) BOOL isLikely;
@property (nonatomic) BOOL boardState;


-(id)initWithBoardState:(BOOL)toDraw;
-(void)drawComplete:(BOOL)isLike;
-(void)clearDrawWork;
//没实现
//-(BOOL)compareDrawWorkWithTemplate:(PKGeometryPasterTemplate *) geoPasterTemplate;

@end
