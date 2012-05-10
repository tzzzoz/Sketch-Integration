//
//  Stroke.h
//  Dudel
//
//  Created by tzzzoz on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPoint.h"
#import "Threshold.h"
#import "Gunit.h"
#import "PointUnit.h"
#import "LineUnit.h"
#import "CurveUnit.h"

@interface Stroke : NSObject 
{
    NSMutableArray *pList;
    NSMutableArray *gList;
    NSMutableArray *specialList;
    float as,ad,ac;
}
@property (retain,nonatomic) NSMutableArray *pList;
@property (retain,nonatomic) NSMutableArray *gList;
@property (retain,nonatomic) NSMutableArray *specialList;
-(id) initWithPoints:(NSMutableArray *) x;
-(void) findSpecialPoints;
-(Gunit*) recognize:(NSMutableArray *)tempPoints;
-(BOOL) rebuild_line;
-(BOOL) rebuild_triangle;
-(BOOL) rebuild_rectangle;
-(BOOL) rebuild_hybridunit;

-(void) speed;// 速 度 过 滤 方 法 ： 低 于 平 均 值 的 一 定 百 分 比 算 是 特 征 点
-(void) curvity;// 曲 率 过 滤
-(void) direction;// 方 向 过 滤
-(void) space;// 进 一 步 处 理

@end
