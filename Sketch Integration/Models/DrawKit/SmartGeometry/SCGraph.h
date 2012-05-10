//
//  SCGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gunit.h"

@class Constraint;
@class ConstraintGraph;

@interface SCGraph : NSObject
{
    int local_graph_id;

    //用于存储时标识出图形的类型
    //0 PointGraph 1 LineGraph 2 CurveGraph 3 TriangleGraph 4 RectangleGraph 5 OtherGraph
    GraphType graphType;
    
    NSMutableArray* constraintList;
    
    float strokeSize;
    CGColorRef graphColor;
    
    bool isSelected;
    bool isDraw;
}

@property (retain)    NSMutableArray*   constraintList;
@property (readwrite) int               local_graph_id;
@property (readwrite) GraphType         graphType;
@property (readwrite) bool              isDraw;
@property (readwrite) bool              isSelected;
@property (assign,nonatomic) CGColorRef graphColor;
@property (assign,nonatomic) float      strokeSize;

-(id)initWithId:(int)temp_local_graph_id;
-(id)initWithId:(int)temp_local_graph_id andType:(GraphType)graphType1;

-(void)setGraphColorWithColorRef:(CGColorRef)colorRef;
-(void)drawWithContext:(CGContextRef)context;

-(void)constructConstraintGraph1:(SCGraph*)graph1 Type1:(ConstraintType)type1 Graph2:(SCGraph*)graph2 Type2:(ConstraintType)type2;
-(Boolean)recognizeConstraintWithGraph:(SCGraph*)graphTemp PointList:(NSMutableArray*)pointList;
-(void)clearConstraint;

//基本编辑操作
-(void)translationWithPoint:(SCPoint*)point;
-(void)rotationWithAngle:(const float)angle Center:(const SCPoint*)rotaitonCenter;
-(void)scaleWithFactor:(const float)scaleFactor;
-(Boolean)graphIsSelectedWithPoint:(SCPoint*)pointTemp;
-(void)setSelectedWithBool:(const bool)boolValue;
-(void)setOriginal;

@end
