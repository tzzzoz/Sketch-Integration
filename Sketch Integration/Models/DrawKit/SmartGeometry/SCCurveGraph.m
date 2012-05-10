//
//  SCCurveGraph.m
//  SmartGeometry
//
//  Created by kwan terry on 12-1-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCCurveGraph.h"

@implementation SCCurveGraph

@synthesize curveUnit;
@synthesize hasEnd,hasStart,twoPointOnCurveLineList,onePointOnCurveLineList;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        curveUnit = [[CurveUnit alloc]init];
        [self initWithId:-1];
        self.graphType = Curver_Graph;
    }
    
    return self;
}

-(id)initWithCurveUnit:(CurveUnit *)curveUnitLocal ID:(int)tempLocalGraphID
{
    //如果需要初始化派生类中的新增数据成员，请在此函数
    [self init];
    curveUnit = curveUnitLocal;
    graphType = Curver_Graph;
    self.hasStart = NO;
    self.hasEnd = NO;
    
    return self;
}

-(void)setOrigalMajorMinorAxis
{
    [curveUnit setOriginalMajorAndOriginalMinor];
}

-(void)getCurveUnitByUnit:(CurveUnit *)tempCurveUnit
{
    tempCurveUnit = curveUnit;
}

-(void)drawWithContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, strokeSize);
    CGContextSetStrokeColorWithColor(context, graphColor);
    [curveUnit drawWithContext:context];
}


-(void)recognizeConstraintWithPointList:(NSMutableArray *)pointList
{
    //判断存在的点集合是否和曲线的开始点和终止点是同一个点
    for(int i=0; i<pointList.count; i++)
    {
        SCPointGraph* pointTemp = [pointList objectAtIndex:i];
        if([Threshold Distance:pointTemp.pointUnit.start :[curveUnit.newDrawPointList objectAtIndex:0]] <= is_point_connection && !hasStart)
        {
            SCPoint* centerPoint = [curveUnit.newDrawPointList lastObject];
            SCPoint* aimPoint = pointTemp.pointUnit.start;
            SCPoint* originPoint = [curveUnit.newDrawPointList objectAtIndex:0];
            SCPoint* aimVector =  [[SCPoint alloc]initWithX:aimPoint.x-centerPoint.x andY:aimPoint.y-centerPoint.y];
            SCPoint* originVector = [[SCPoint alloc]initWithX:originPoint.x-centerPoint.x andY:originPoint.y-centerPoint.y];
            LineUnit* aimLine = [[LineUnit alloc]initWithStartPoint:centerPoint endPoint:aimPoint];
            float aimLength = sqrtf(aimVector.x*aimVector.x + aimVector.y*aimVector.y);
            float originLength = sqrtf(originVector.x*originVector.x + originVector.y*originVector.y);
            float theta = acosf((aimVector.x*originVector.x+aimVector.y*originVector.y) / (aimLength*originLength));
            if(centerPoint.x > aimPoint.x)
            {
                if(originPoint.y < (aimLine.k*originPoint.x + aimLine.b))
                {
                    theta = -theta;
                }
            }
            else if(centerPoint.x < aimPoint.x)
            {
                if(originPoint.y > (aimLine.k*originPoint.x + aimLine.b))
                {
                    theta = -theta;
                }
            }
            for(int i=0; i<[curveUnit.newDrawPointList count]; i++)
            {
                SCPoint* point = [curveUnit.newDrawPointList objectAtIndex:i];
                if(i == 0)
                {
                    [curveUnit rotationWithPoint:point Theta:theta BasePoint:centerPoint];
                    float k = aimLine.k*point.x + aimLine.b;
                    if(k == point.y)
                    {
                        
                    }
                }
                else
                {
                    [curveUnit rotationWithPoint:point Theta:theta BasePoint:centerPoint];
                }
            }
            
            NSMutableArray* pList = [[NSMutableArray alloc]init];
            centerPoint = [curveUnit.newDrawPointList lastObject];
            aimPoint = pointTemp.pointUnit.start;
            originPoint = [curveUnit.newDrawPointList objectAtIndex:0];
            aimVector =  [[SCPoint alloc]initWithX:aimPoint.x-centerPoint.x andY:aimPoint.y-centerPoint.y];
            originVector = [[SCPoint alloc]initWithX:originPoint.x-centerPoint.x andY:originPoint.y-centerPoint.y];
            aimLength = sqrtf(aimVector.x*aimVector.x + aimVector.y*aimVector.y);
            originLength = sqrtf(originVector.x*originVector.x + originVector.y*originVector.y);
            SCPoint* scaleFactor = [[SCPoint alloc]initWithX:fabs(aimVector.x/originVector.x) andY:fabs(aimVector.y/originVector.y)];
            SCPoint* scaleFactor1 = [[SCPoint alloc]initWithX:aimLength/originLength andY:aimLength/originLength];
            SCPoint* vector = [[SCPoint alloc]initWithX:aimPoint.x-originPoint.x andY:aimPoint.y-originPoint.y];
            for(int i=0; i<[curveUnit.newDrawPointList count]; i++)
            {
                SCPoint* point = [curveUnit.newDrawPointList objectAtIndex:i];
                if(i == 0)
                {
                    point = [curveUnit scaleWithPoint:point ScaleFactor:scaleFactor BasePoint:centerPoint];
//                    point = [curveUnit translateWithPoint:point Vector:vector];
                    [pList addObject:point];
                }
                else
                {
                    point = [curveUnit scaleWithPoint:point ScaleFactor:scaleFactor1 BasePoint:centerPoint];
//                    point = [curveUnit translateWithPoint:point Vector:vector];
                    [pList addObject:point];
                }
            }
            centerPoint = [curveUnit.newDrawPointList lastObject];
            [curveUnit.newDrawPointList removeAllObjects];
            curveUnit.newDrawPointList = pList;
            
            self.hasStart = YES;
            pointTemp.is_vertex = YES;
            [self constructConstraintGraph1:(SCGraph*)self Type1:Start_Vertex_Of_Curve Graph2:(SCGraph*)pointTemp Type2:Start_Vertex_Of_Curve];
        }
        else if([Threshold Distance:pointTemp.pointUnit.start :[curveUnit.newDrawPointList lastObject]] <= is_point_connection && !hasEnd)
        {
            SCPoint* centerPoint = [curveUnit.newDrawPointList objectAtIndex:0];
            SCPoint* aimPoint = pointTemp.pointUnit.start;
            SCPoint* originPoint = [curveUnit.newDrawPointList lastObject];
            SCPoint* aimVector =  [[SCPoint alloc]initWithX:aimPoint.x-centerPoint.x andY:aimPoint.y-centerPoint.y];
            SCPoint* originVector = [[SCPoint alloc]initWithX:originPoint.x-centerPoint.x andY:originPoint.y-centerPoint.y];
            LineUnit* aimLine = [[LineUnit alloc]initWithStartPoint:centerPoint endPoint:aimPoint];
            float aimLength = sqrtf(aimVector.x*aimVector.x + aimVector.y*aimVector.y);
            float originLength = sqrtf(originVector.x*originVector.x + originVector.y*originVector.y);
            float theta = acosf((aimVector.x*originVector.x+aimVector.y*originVector.y) / (aimLength*originLength));
            if(centerPoint.x > aimPoint.x)
            {
                if(originPoint.y < (aimLine.k*originPoint.x + aimLine.b))
                {
                    theta = -theta;
                }
            }
            else if(centerPoint.x < aimPoint.x)
            {
                if(originPoint.y > (aimLine.k*originPoint.x + aimLine.b))
                {
                    theta = -theta;
                }
            }
            for(int i=0; i<[curveUnit.newDrawPointList count]; i++)
            {
                SCPoint* point = [curveUnit.newDrawPointList objectAtIndex:i];
                if(i == 0)
                {
                    point = [curveUnit rotationWithPoint:point Theta:theta BasePoint:centerPoint];
                    float k = aimLine.k*point.x + aimLine.b;
                    if(k == point.y)
                    {
                        
                    }
                }
                else
                {
                    point = [curveUnit rotationWithPoint:point Theta:theta BasePoint:centerPoint];
                }
            }
            
            
            NSMutableArray* pList = [[NSMutableArray alloc]init];
            centerPoint = [curveUnit.newDrawPointList objectAtIndex:0];
            aimPoint = pointTemp.pointUnit.start;
            originPoint = [curveUnit.newDrawPointList lastObject];
            aimVector =  [[SCPoint alloc]initWithX:aimPoint.x-centerPoint.x andY:aimPoint.y-centerPoint.y];
            originVector = [[SCPoint alloc]initWithX:originPoint.x-centerPoint.x andY:originPoint.y-centerPoint.y];
            aimLength = sqrtf(aimVector.x*aimVector.x + aimVector.y*aimVector.y);
            originLength = sqrtf(originVector.x*originVector.x + originVector.y*originVector.y);
            SCPoint* scaleFactor = [[SCPoint alloc]initWithX:fabs(aimVector.x/originVector.x) andY:fabs(aimVector.y/originVector.y)];
            SCPoint* scaleFactor1 = [[SCPoint alloc]initWithX:aimLength/originLength andY:aimLength/originLength];
            SCPoint* vector = [[SCPoint alloc]initWithX:aimPoint.x-originPoint.x andY:aimPoint.y-originPoint.y];
            for(int i=0; i<[curveUnit.newDrawPointList count]; i++)
            {
                SCPoint* point = [curveUnit.newDrawPointList objectAtIndex:i];
                if(i == curveUnit.newDrawPointList.count-1)
                {
                    point = [curveUnit scaleWithPoint:point ScaleFactor:scaleFactor BasePoint:centerPoint];
//                    point = [curveUnit translateWithPoint:point Vector:vector];
                    [pList addObject:point];
                }
                else
                {
                    point = [curveUnit scaleWithPoint:point ScaleFactor:scaleFactor1 BasePoint:centerPoint];
//                    point = [curveUnit translateWithPoint:point Vector:vector];
                    [pList addObject:point];
                }
            }
            centerPoint = [curveUnit.newDrawPointList lastObject];
            [curveUnit.newDrawPointList removeAllObjects];
            curveUnit.newDrawPointList = pList;
            
            self.hasEnd = YES;
            pointTemp.is_vertex = YES;
            [self constructConstraintGraph1:(SCGraph*)self Type1:End_Vertex_Of_Curve Graph2:(SCGraph*)pointTemp Type2:End_Vertex_Of_Curve];
        }
    }
}

//-(void)recognizeConstraintWithPointList:(NSMutableArray *)pointList
//{
//    //判断存在的点集合是否和曲线的开始点和终止点是同一个点
//    for(int i=0; i<pointList.count; i++)
//    {
//        SCPointGraph* pointTemp = [pointList objectAtIndex:i];
//        if(curveUnit.curveType == 1 && curveUnit.type == 2 && !curveUnit.isCompleteCurve)
//        {
//            if([Threshold Distance:pointTemp.pointUnit.start :[curveUnit.newDrawSecCurveTrack objectAtIndex:0]] <= is_point_connection)
//            {
//                NSMutableArray* pList = [[NSMutableArray alloc]init];
//                pList = [curveUnit findCalculatePoints:curveUnit.newDrawSecCurveTrack];
//                [pList insertObject:pointTemp.pointUnit.start atIndex:0];
//                [pList addObject:[curveUnit.newDrawSecCurveTrack lastObject]];
//                [curveUnit recalculateSecCurveTrackWithPointList:pList];
//                self.hasStart = YES;
//                pointTemp.is_vertex = YES;
//                [self constructConstraintGraph1:(SCGraph*)self Type1:Start_Vertex_Of_Curve Graph2:(SCGraph*)pointTemp Type2:Start_Vertex_Of_Curve];
//            }
//            else if([Threshold Distance:pointTemp.pointUnit.start :[curveUnit.newDrawSecCurveTrack lastObject]] <= is_point_connection)
//            {
//                NSMutableArray* pList = [[NSMutableArray alloc]init];
//                pList = [curveUnit findCalculatePoints:curveUnit.newDrawSecCurveTrack];
//                [pList insertObject:[curveUnit.newDrawSecCurveTrack objectAtIndex:0] atIndex:0];
//                [pList addObject:pointTemp.pointUnit.start];
//                [curveUnit recalculateSecCurveTrackWithPointList:pList];
//                self.hasEnd = YES;
//                pointTemp.is_vertex = YES;
//                [self constructConstraintGraph1:(SCGraph*)self Type1:End_Vertex_Of_Curve Graph2:(SCGraph*)pointTemp Type2:End_Vertex_Of_Curve];
//            }
//        }
//    }
//    
//    //如果开始点和结束点都有约束则返回，如果有一个没有约束，看看是否存在约束点在曲线上
//    if(self.hasStart && self.hasEnd)
//        return;
//    else
//    {
//        return;
//    }
//}


@end
