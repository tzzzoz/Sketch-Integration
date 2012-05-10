//
//  SCCurveGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 12-1-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "SCPointGraph.h"
#import "SCLineGraph.h"
#import "SCTriangleGraph.h"
#import "CurveUnit.h"
#import "LineUnit.h"

@class LineUnit;
@class CurveUnit;
@class SCLineGraph;
@class SCTriangleGraph;
@class SCPointGraph;

@interface SCCurveGraph : SCGraph
{
    CurveUnit* curveUnit;
    
    Boolean hasStart;
    Boolean hasEnd;
    
    NSMutableArray* twoPointOnCurveLineList;
    NSMutableArray* onePointOnCurveLineList;
}
@property (retain)  CurveUnit* curveUnit;

@property (readwrite) Boolean hasStart;
@property (readwrite) Boolean hasEnd;

@property (retain)  NSMutableArray* twoPointOnCurveLineList;
@property (retain)  NSMutableArray* onePointOnCurveLineList;

-(id)initWithCurveUnit:(CurveUnit*)curveUnitLocal ID:(int)tempLocalGraphID;

-(void)drawWithContext:(CGContextRef)context;

-(void)getCurveUnitByUnit:(CurveUnit*)tempCurveUnit;
-(void)setOrigalMajorMinorAxis;

////识别外切三角形
//-(Boolean)recognizeExternallyTangentConstraintWithTriangleGraph:(SCTriangleGraph*)triangleGraph;

//识别相关的函数
//用于识别圆形与直线之间的关系，总领函数
-(Boolean)recognizeConstraintWithLineGraph:(SCLineGraph*)lineGraphTemp PointList:(NSMutableArray*)pointList;
//用于识别曲线和点集合之间的关系
-(void)recognizeConstraintWithPointList:(NSMutableArray*)pointList;
//用于识别圆与圆之间的关系，内外切，或者相交
-(Boolean)recognizeConstraintWithCurveGraph:(SCCurveGraph*)curveGraphTemp PointList:(NSMutableArray*)pointList;
//用于识别跟三角形的交点，非内切和外接
-(Boolean)recognizeConstraintWithTriangleGraph:(SCTriangleGraph*)triangleGraphTemp PointList:(NSMutableArray*)pointList;
//识别切线
-(Boolean)recognizeLineTangentConstraintWithLineGraph:(SCLineGraph*)lineGraphTemp;
//用于识别直径
-(Boolean)recognizeDiameterWithLineGraph:(SCLineGraph*)lineGraphTemp PointList:(NSMutableArray*)pointList;
//用于识别半径
-(Boolean)recognizeRadiusWithLineGraph:(SCLineGraph*)lineGraphTemp PointList:(NSMutableArray*)pointList;
//识别与直线的一般约束
-(Boolean)recognizeCommonLineConstraintWithLineGraph:(SCLineGraph*)lineGraphTemp PointList:(NSMutableArray*)pointList;
//判断是否应该进行直径半径和一般直线的识别
-(Boolean)judgeRecognizationWithLineGraph:(SCLineGraph*)lineGraphTemp;
//判断直线与圆的交点是否符合条件:-1为不在直线上，0为在直线上，1为起点，2为末尾点
-(int)judgeLegalIntersectionWithLineGraph:(SCLineGraph*)lineGraphTemp Point:(SCPoint*)pointTemp;
//生成直线和圆相交的点的有关约束
-(void)makeConstraintWithLineGraph:(SCLineGraph*)lineGraphTemp Point:(SCPoint*)pointTemp PointList:(NSMutableArray*)pointList;
//总领的函数
-(Boolean)recognizeConstraintWithGraph:(SCGraph *)graphTemp PointList:(NSMutableArray *)pointList;
-(Boolean)fixPointLineTangent:(SCLineGraph*)lineGraphTemp;
-(Boolean)fixPointLineTangentJudge:(SCLineGraph*)lineGraphTemp;
-(SCPoint*)fixPointLineWithPoint:(SCPoint*)pointTemp LineGraph:(SCLineGraph*)lineGraphTemp;

//编辑操作相关函数
-(void)translationWithPoint:(SCPoint *)point;
-(void)rotationWithAngle:(const float)angle Center:(const SCPoint *)rotaitonCenter;
-(void)scaleWithFactor:(const float)scaleFactor;
-(Boolean)graphIsSelectedWithPoint:(SCPoint *)pointTemp;
-(void)setSelectedWithBool:(const _Bool)boolValue;
-(void)setOriginal;
-(void)pointOnCurveAfterScale:(SCPoint*)pointTemp;
-(void)stretchWithPoint:(SCPoint*)pointTemp;

//保持约束关系相关函数
-(void)keepConstraintsWithGraph:(SCGraph*)graphTemp;
-(void)keepLineTangent:(SCLineGraph*)lineGraphTemp;
-(void)findSecantLine;
-(void)keepIntersectionOnCircleWithLineUnit:(LineUnit*)lineUnitTemp PointGraph:(SCPointGraph*)pointGraphTemp;
-(void)keepIntersectionOnCircleWithCurveGraph:(SCCurveGraph*)curveUnitTemp PointGraph:(SCPointGraph*)pointGraphTemp;

@end
