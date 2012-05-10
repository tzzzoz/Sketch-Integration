//
//  LineUnit.h
//  Dudel
//
//  Created by tzzzoz on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Gunit.h"
#import "SCPoint.h"
#import "Threshold.h"

@interface LineUnit : Gunit 
{
    double k;// 斜 率
    double b;// 偏 移
    
    bool isCutLine;
    SCPoint* cutPoint;
}

@property (readwrite) double k;
@property (readwrite) double b;
@property (readwrite) bool   isCutLine;
@property (retain)    SCPoint* cutPoint;

-(BOOL) judge:(NSMutableArray *) pList;// 计 算 出 直 线 的 相 关 系 数   通 过 相 关 系 数 进 行 判 断 是 否 为 直 线
-(void) setstart:(SCPoint *) newstart;
-(id)initWithPoints:(NSMutableArray *)points ;
-(void) setend:(SCPoint*) newend;
-(void) setstartX:(float) newstart_x  Y:(float) newstart_y;
-(void) setendX:(float) newend_x  Y:(float) newend_y;
-(void) calculateK_B;
-(void) setOriginal;
-(double) OriginalK;
-(double) OriginalB;

-(void)drawWithContext:(CGContextRef)context;

@end
