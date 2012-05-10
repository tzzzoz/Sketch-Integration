//
//  SCPointGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "SCPoint.h"
#import "PointUnit.h"
#import "LineUnit.h"
#import "Threshold.h"
#import "SCLineGraph.h"

@class LineUnit;
@class CurveUnit;
@interface SCPointGraph : SCGraph
{
    PointUnit* pointUnit;
    
    int freedomType;
    int curve_start_end;//1为起点，2为终点
    
    bool is_vertex;
    bool is_on_line;
    bool is_on_circle;
    bool belong_to_triangle;
    bool belong_to_rectangle;
    bool in_graph_list;
    bool cut_point_of_circles; //标识是否为两个圆的切点
    
    bool vertexOfCurveCenter; //只为半径标识
    bool vertexOfSpecialLine; //标识它是否为三角形特殊线的落在三角形边上的断点，在KEEP的时候有用
    
}

@property (retain)      PointUnit*      pointUnit;
@property (readwrite)   int             freedomType;
@property (readwrite)   int             curve_start_end;
@property (readwrite)   bool            is_vertex;
@property (readwrite)   bool            is_on_line;
@property (readwrite)   bool            is_on_circle;
@property (readwrite)   bool            belong_to_triangle;
@property (readwrite)   bool            belong_to_rectangle;
@property (readwrite)   bool            in_graph_list;
@property (readwrite)   bool            cut_point_of_circles;
@property (readwrite)   bool            vertexOfCurveCenter;
@property (readwrite)   bool            vertexOfSpecialLine;

-(id)initWithUnit:(PointUnit*)pointUnit andId:(int)temp_local_graph_id;

//总领函数，用于直接拖动点的时候用，传进一个点的坐标，然后根据点所在的直线的性质不同，传不同的参数给keepOnLine和keepOnCircle
-(void)keepConstraintWithPoint:(SCPoint*)pointTemp;
-(void)keepOnLine:(LineUnit*)LineTemp WithPoint:(SCPoint*)pointTemp;
//当某一个顶点动了的时候，可以调用这个函数来调整那些以它作为端点的直线，而不是调用总的keepConstraint
-(void)keepVertexOfLine:(SCGraph*)graphTemp;
-(void)keepTriangleAndRectangle:(SCGraph*)graphTemp;
-(SCPoint*)keepOnCircle:(CurveUnit*)unit WithPoint:(SCPoint*)point;

-(void)setPoint:(SCPoint*)point;
-(Boolean)isUndo;
-(Boolean)isRedo;
-(void)resetAttribute;

-(void)drawWithContext:(CGContextRef)context;
-(void)draw_extension_line:(CGContextRef)context;
-(void)draw_dot_lineFromStart:(SCPoint*)startPoint ToEnd:(SCPoint*)endPoint WithContext:(CGContextRef)context;
-(void)draw_line_dot_extension_line:(LineUnit*)lineUnit WithContext:(CGContextRef)context;

//编辑操作的相关函数
-(void)translationWithPoint:(SCPoint *)point;
-(void)rotationWithAngle:(const float)angle Center:(const SCPoint *)rotaitonCenter;
-(void)scaleWithFactor:(const float)scaleFactor;
-(Boolean)graphIsSelectedWithPoint:(SCPoint *)pointTemp;
-(void)setSelectedWithBool:(const _Bool)boolValue;
-(void)setOriginal;

@end
