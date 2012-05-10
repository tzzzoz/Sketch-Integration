//
//  Constraint.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCGraph.h"
#import "Gunit.h"
#import "SCPointGraph.h"
#import "SCLineGraph.h"

@class SCGraph;
@class SCPointGraph;
@class SCLineGraph;

@interface Constraint : NSObject
{
    int related_graph_id;
    int lastGraphSize;
    
    ConstraintType constraintType;
    SCGraph*       relatedGraph;
    
    NSMutableArray* point_list;
    NSMutableArray* graph_list;
    NSMutableArray* selected_list;
    NSMutableArray* delete_graph;
}

@property (readwrite) ConstraintType   constraintType;
@property (readwrite) int              related_graph_id;
@property (retain)    SCGraph*         relatedGraph;
@property (readwrite) int              lastGraphSize;

@property (retain) NSMutableArray* point_list;
@property (retain) NSMutableArray* graph_list;
@property (retain) NSMutableArray* selected_list;
@property (retain) NSMutableArray* delete_graph;

//constraint初始化
-(id)initWith:(NSMutableArray* (SCPointGraph*)) pointList;
-(id)initWithPointList:(NSMutableArray*)pointList GraphList:(NSMutableArray*)graphList SeletedList:(NSMutableArray*)selectedList;

//识别约束关系
-(void)recognizeConstraint;

//上个图形的大小
-(void)setLastGraphSize:(int)n;
//得到线的一个端点
-(void)getLineVertexWithGraph:(SCGraph*)graph StartPoint:(SCPointGraph **)start  EndPoint:(SCPointGraph **)end;
//得到线的另一个端点
-(void)getAnotherVertexWithGraph:(SCGraph*)graph Point:(SCPointGraph*) point ConnectLine:(NSMutableArray**)connectLine ConnectLinePoint:(NSMutableArray**)connectLinePoint;
//得到第三个端点
-(bool)findTheThirdPointWithThirdPoint:(SCPointGraph**) thirdPoint SecondLine:(SCLineGraph**) secondLine ThirdLine:(SCLineGraph**) thirdLine StartConnectLinePoint:(NSMutableArray*) startConnectLinePoint EndConnectLinePoint:(NSMutableArray*) endConnectLinePoint StartConnectLine:(NSMutableArray*)startConnectLine EndConnectLine:(NSMutableArray*)endConnectLine;
//是否可以构成一个三角形
-(bool)canBeRectangleWithThirdPoint:(SCPointGraph**)thirdPoint FourthPoint:(SCPointGraph**)fourthPoint SecondLine:(SCLineGraph**)secondLine ThirdLine:(SCLineGraph**)thirdLine FourthLine:(SCLineGraph**)fourthLine StartConnectLinePoint:(NSMutableArray*)startConnectLinePoint EndConnectLinePoint:(NSMutableArray*)endConnectLinePoint StartConnectLine:(NSMutableArray*)startConnectLine EndConnectLine:(NSMutableArray*)endConnectLine;
//重新创建三角形，四边形
-(BOOL)rebuildTriangleRectangleWithGraph:(SCGraph*)graph;
//建立三角形
-(void)buildTriangleWithFirstLine:(SCLineGraph*)firstLine SecondLine:(SCLineGraph*)secondLine ThirdLine:(SCLineGraph*)thirdLine Start:(SCPointGraph*)start End:(SCPointGraph*)end ThirdPoint:(SCPointGraph*)thirdPoint;
//建立四边形
-(void)buildRectangleWithPoint0:(SCPointGraph*)v0 Point1:(SCPointGraph*)v1 Point2:(SCPointGraph*)v2 Point3:(SCPointGraph*)v3 FirstLine:(SCLineGraph*)firstLine SecondLine:(SCLineGraph*)secondLine ThirdLine:(SCLineGraph*)thirdLine FourthLine:(SCLineGraph*)fourthLine;
//建立三角四边形
-(void)bindToTriangleRectangleWithPoint:(SCPointGraph*) point Graph:(SCGraph*) graph i:(int) i;
//把线弄成三角四边形的线
-(void)transformLineToTriangleRectangleWithLine:(SCLineGraph*) lineGraph Graph:(SCGraph*)graph;
//清除图形
-(void)eraseGraphFromGraphListWithGraph:(SCGraph*)graph GraphList:(NSMutableArray**)graphList;
//清楚约束
-(void)eraseConstraintWithLocal:(SCGraph*)local RelatedGraph:(SCGraph*)relatedGraph;

@end
