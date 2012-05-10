//
//  SCRectangleGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "SCCurveGraph.h"
#import "SCLineGraph.h"
#import "SCPointGraph.h"
#import "LineUnit.h"
#import "Gunit.h"

@class LineUnit;
@class SCCurveGraph;
@class SCLineGraph;
@class SCPointGraph;

typedef enum
{
    OrdinaryRectangleForGraph = 0,
    SquareForGraph = 1,
    RectangleForGraph = 2,
    PrismaticForGraph = 3,
    ParallelForGraph  = 4,
    TrapezoidForGraph = 5,
    IscoTrapezoidForGraph = 6,
    RightTrapezoidForGraph = 7
}RectangleType;

@interface SCRectangleGraph : SCGraph
{
    NSMutableArray* rec_vertexes;
    NSMutableArray* rec_lines;
    
    NSMutableArray* vertical_index;    //记录哪些角是直角
    NSMutableArray* node_index;        //通过标识顶点来标识不同内心的四边形
    
    //代表四边形的类型
    //0代表一般四边形，1代表正方形，2代表矩形，3代表菱形，4代表平行四边形，5代表一般梯形，6代表等腰梯形，7代表直角梯形
    RectangleType rectangleType;
}

@property (retain) NSMutableArray* rec_vertexes;
@property (retain) NSMutableArray* rec_lines;

-(id)initWithLine0:(LineUnit*)line0 Line1:(LineUnit*)line1 Line2:(LineUnit*)line2 Line3:(LineUnit*)line3 Id:(int)temp_local_id;
-(SCPointGraph*)bindVertexOnRectangleWithLineGraph:(SCLineGraph*)lineGraphTemp Index:(int)index StartEnd:(int)startEnd;

//将四边形整成逆时针
-(void)setLinePointsLine0:(LineUnit*)line1 Line1:(LineUnit*)line2 Line2:(LineUnit*)line3 Line3:(LineUnit*)line4;
-(Boolean)is_not_connect:(LineUnit*)line1 :(LineUnit*)line2;
-(Boolean)is_anticloclkwise:(SCPoint*)v0 :(SCPoint*)v1 :(SCPoint*)v2;
-(Boolean)is_exist_pointWithPoint:(SCPoint*)pointTemp LineGraph:(SCLineGraph*)lineGraphTemp;

-(void)setVertexOnLineWithLineUnit:(LineUnit*)lineUnitTemp LineGraph:(SCLineGraph*)lineGraphTemp PointGraph:(SCPointGraph*)pointGraphTemp StartEnd:(int)startEnd;
-(Boolean)isLineVertexOnRectangleWithLineUnit:(LineUnit*)lineUnitTemp Point:(SCPoint*)pointTemp;


-(void)drawWithContext:(CGContextRef)context;

//识别约束部分
-(Boolean)recognizeConstraintWithGraph:(SCGraph*)graphTemp PointList:(NSMutableArray*)pointList;
-(Boolean)recognizeConstraintWithLineGraph:(SCLineGraph*)lineGraphTemp PointList:(NSMutableArray*)pointList;
-(int)recognizeRectangleType;
-(Boolean)recognizeLineVertexOnRectangleWithLineGraph:(SCLineGraph*)lineTemp PointList:(NSMutableArray*)pointList;
-(Boolean)recognizeConnectLineWithLineGraph:(SCLineGraph*)lineTemp PointList:(NSMutableArray*)pointList;
-(Boolean)judgeConnectLineWithLineGraph:(SCLineGraph*)lineGraphTemp LineUnit:(LineUnit*)lineUnitTemp PointList:(NSMutableArray*)pointList;

//保持约束部分
-(void)followPointGraph;
//用pointGraphTemp来调整两个list的东西
-(void)followPointGraphWithVertexIndex:(int)whichVertex PointGraph:(SCPointGraph*)pointGraphTemp;
//用两个list来调整所有四个pointGraph的位置
-(void)adjustPointGraph;
-(void)keepConstraint;
-(void)keepPointOnRectangleLine:(LineUnit*)lineUnit PointGraph:(SCPointGraph*)pointGraphTemp;
-(void)keepIntersectionOnRectangleLineWithConstraint:(Constraint*)constraint LineUnit:(LineUnit*)lineUnitTemp Point:(SCPoint*)pontTemp;
-(void)keepIntersectionOnRectangleLineWithConstraint:(Constraint*)constraint CurveGraph:(SCCurveGraph*)curveGraphTemp Point:(SCPoint*)pointTemp;

//编辑操作相关函数
-(void)translationWithPoint:(SCPoint *)point;
-(void)rotationWithAngle:(const float)angle Center:(const SCPoint *)rotaitonCenter;
-(void)scaleWithFactor:(const float)scaleFactor;
-(Boolean)graphIsSelectedWithPoint:(SCPoint *)pointTemp;
-(void)setSelectedWithBool:(const _Bool)boolValue;
-(void)setOriginal;
-(SCPoint*)calculatePointAfterRotationWithMove:(const SCPoint*)move Angle:(const float)angle Center:(SCPoint *)rotationCenter;
-(void)changeRectangleLines;
-(void)stretchWithLineIndex:(int)whichLine Point:(SCPoint*)move;
-(SCPoint*)calculateDiagonalIntersectionPoint;

@end
