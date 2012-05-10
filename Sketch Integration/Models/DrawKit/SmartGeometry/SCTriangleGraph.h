//
//  SCTriangleGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "SCRectangleGraph.h"
#import "SCCurveGraph.h"
#import "LineUnit.h"
#import "Gunit.h"
#import "Constraint.h"

@class LineUnit;
@class SCCurveGraph;
@class SCRectangleGraph;

typedef enum 
{
    OridinaryTriangle = 0,
    RightTriangle = 1,
    IsoscelesTriangle = 2,
    RightIsoTriagnle = 3,
    RegularTriangle = 4
}TriangleType;

@interface SCTriangleGraph : SCGraph
{
    //三角形的顶点和它的对边的下标保持着对应关系
    NSMutableArray* triangleLines;
    NSMutableArray* triangleVertexes;
    NSMutableArray* triangleAngles;
    NSMutableArray* triangleLineDistance;
    
    //标识三角形的类型
    //0代表普通三角形
    //1代表直角三角形
    //2代表等腰三角形
    //3代表等腰直角三角形
    //4代表正三角形
    TriangleType triangleType;
    int typeVertexIndex;
}

@property (retain) NSMutableArray* triangleLines;
@property (retain) NSMutableArray* triangleVertexes;
@property (retain) NSMutableArray* triangleAngles;
@property (retain) NSMutableArray* triangleLineDistance;
@property (readwrite) TriangleType triangleType;
@property (readwrite) int          typeVertexIndex;

-(void)initValuesWithLine0:(LineUnit *)line0 Line1:(LineUnit *)line1 Line2:(LineUnit *)line2;
-(id)initWithLine0:(LineUnit*)line0 Line1:(LineUnit *)line1 Line2:(LineUnit *)line2 Id:(int)temp_local_id;
-(id)initWithLine0:(LineUnit*)line0 Line1:(LineUnit*)line1 Line2:(LineUnit*)line2 Id:(int)temp_local_graph_id Vertex0:(SCPoint*)vertex0 Vertex1:(SCPoint*)vertex1 Vertex2:(SCPoint*)vertex2;
-(int[])returnVertexTagWithIndex:(int)vertexIndex;
-(void)drawWithContext:(CGContextRef)context;

//约束部分的相关函数
//使得三角形的边和顶点为严格的逆时针
-(void)setVertex;
//获得三角形的三条边
-(void)getLinesWithLine1:(LineUnit*)line1 Line2:(LineUnit*)line2 Line3:(LineUnit*)line3;
//根据直线和三角形的位置范围来判断是否应该进行具体的约束识别
-(Boolean)judgeRecognizationWithLineGraph:(SCLineGraph*)lineGraph;
-(void)recognizeCommonConstraintWithLineGraph:(SCLineGraph*)lineGraph PointList:(NSMutableArray*)pointList;
-(Boolean)recognizeConstraintWithCurveGraph:(SCCurveGraph*)curveGraph PointList:(NSMutableArray*)pointList;
-(Boolean)recognizeConstraintWithGraph:(SCGraph*)graphTemp PointList:(NSMutableArray*)pointList;
//确定哪种类型的约束会被识别
-(Boolean)willRecognizeType;

//保持约束部分
-(void)followPointGraph:(SCPointGraph*)pointGraph WithVertexIndex:(int)vertexIndex;
-(void)followPointGraph;
-(void)adjustPointGraph;
-(void)keepConstraintWithGraph:(SCGraph*)graphTemp;
-(void)keepConstraintWithGraph:(SCGraph*)graphTemp Angle:(const float)angle RotationCenter:(const SCPoint*)rotaitonCenter;
-(void)keepPointOnTriangleLine:(LineUnit*)lineUnit PointGraph:(SCPointGraph*)pointGraph;
-(void)keepIntersectionOnTriangleLineWithConstraint:(Constraint*)constraint LineUnit:(LineUnit*)lineUnit Point:(SCPoint*)pointTemp;

//与识别有关的
-(Boolean)recognizeConstraintWithTriangleGraph:(SCTriangleGraph*)triangleGrpah PointList:(NSMutableArray*)pointList;
-(Boolean)recognizeConstraintWithRectangleGraph:(SCRectangleGraph*)rectangleGraph PointList:(NSMutableArray*)pointList;
-(void)recognizeTriangleType;
-(void)setTriangleType;
//与构造特殊三角形有关的
-(void)rebuildIsoTriangle;
-(void)rebuildRightTriangle;
-(void)rebuildRegularTriangle;
-(void)rebuildIsoRightTriangle;

//计算相关函数
//更新顶点，角度，内心，三角形的顶点坐标改变之后必须调用这个函数
-(void)updateRelatedValues;
-(float)getAngleWithVertexs:(NSMutableArray*)vertexList Index:(int)vertexIndex;
+(float)distanceBetweenPoint1:(SCPoint*)point1 Point2:(SCPoint*)point2;

//编辑操作相关函数
-(void)translationWithPoint:(SCPoint *)point;
-(void)rotationWithAngle:(const float)angle Center:(const SCPoint *)rotaitonCenter;
-(void)scaleWithFactor:(const float)scaleFactor;
-(Boolean)graphIsSelectedWithPoint:(SCPoint *)pointTemp;
-(void)setSelectedWithBool:(const _Bool)boolValue;
-(void)setOriginal;
-(SCPoint*)calculatePointAfterScaleWithMove:(SCPoint*)move Factor:(const float)scaleFactor Center:(const SCPoint*)scaleCenter;
-(void)changeTriangleLines;
-(SCPoint*)calculatePointAfterRotationWithMove:(SCPoint*)move Angle:(const float)angle Center:(SCPoint *)rotationCenter;

@end
