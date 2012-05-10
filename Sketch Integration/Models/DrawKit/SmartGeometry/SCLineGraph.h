//
//  SCLineGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineUnit.h"
#import "SCGraph.h"
#import "SCTriangleGraph.h"
#import "SCRectangleGraph.h"
#import "SCPointGraph.h"
#import "Constraint.h"
#import "ConstraintGraph.h"

@class LineUnit;
@class SCGraph;
@class SCPoint;
@class SCPointGraph;
@class SCLineGraph;
@class SCTriangleGraph;
@class SCRectangleGraph;
@class Constraint;
@class ConstraintGraph;

@interface SCLineGraph : SCGraph
{
    LineUnit* lineUnit;
    
    //用于识别约束时表示直线的端点有没有跟点列表的点图形连到一起
    bool hasStart;
    bool hasEnd;
    
    //用于标识直线是否为三角形的三角形的特殊线
    bool isSpecial;
    //用于标识直线是否为切线
    bool isTangent;
}

@property (retain) LineUnit* lineUnit;
@property (readwrite) bool      hasStart;
@property (readwrite) bool      hasEnd;
@property (readwrite) bool      isSpecial;
@property (readwrite) bool      isTangent;

-(id)initWithLine:(LineUnit*)lineUnit1 andId:(int)temp_local_graph_id;

-(void)drawWithContext:(CGContextRef)context;

//识别约束部分
//用以约束识别开始阶段时的直线和存在的点之间的约束识别
-(void)recognizeConstraint:(NSMutableArray*)plist;
//用于固定一端后来根据一个直线上新的点来调整另一端的位置,0为start，1为end
-(void)adjustVertex:(SCPoint*)point :(int)num;
-(Boolean)recognizeConstraintWithGraph:(SCGraph*)graph PointList:(NSMutableArray*)plist;
-(Boolean)recognizeConstraintWithLineGraph:(SCLineGraph*)lineGraph PointList:(NSMutableArray*)plist;
-(int)judgeLegalIntersectionWithLine1:(LineUnit*)line1 Line2:(LineUnit*)line2 Point:(SCPoint*)p2;
-(Boolean)judgeLegalIntersectionWithPoint:(SCPoint*)p;
-(Boolean)recognizeConstraintWithTriangleGraph:(SCTriangleGraph*)triangleGraphTemp PointList:(NSMutableArray*)pointList;
-(Boolean)recognizeConstraintWithRectangleGraph:(SCRectangleGraph*)rectangleGraphTemp PointList:(NSMutableArray*)pointList;

//保持约束相关函数
//主要用于当直线的位置改变的时候，改变其上面存在的点的位置（非自身端点），然后再通过这些被改变的点去带动其他直线
-(void)keepConstraint;
//主要用于那些非限制点的位置变动
-(void)keepPointOnLineWithPointGraph:(SCPointGraph*)pointGraphTemp;
//用于计算交点的新位置
-(void)keepIntersectionPoint:(SCPointGraph*)pointGraphTemp;
-(void)adjustPointGraph;

//编辑操作相关函数
-(SCPoint*)calculatePointAfterRotationWithMove:(const SCPoint*)move Angle:(const float)angle Center:(SCPoint*)rotationCenter;
-(void)translationWithPoint:(SCPoint *)point;
-(void)rotationWithAngle:(const float)angle Center:(const SCPoint *)rotaitonCenter;
-(void)scaleWithFactor:(const float)scaleFactor;
-(Boolean)graphIsSelectedWithPoint:(SCPoint *)pointTemp;
-(void)setSelectedWithBool:(const _Bool)boolValue;
-(void)setOriginal;

@end
