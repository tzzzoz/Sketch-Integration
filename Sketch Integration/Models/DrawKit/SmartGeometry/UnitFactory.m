//
//  UnitFactory.m
//  Dudel
//
//  Created by tzzzoz on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UnitFactory.h"

@implementation UnitFactory

@synthesize strokeTotal;

int graph_id = 0;

- (id)init
{
    self = [super init];
    if (self) 
    {
        graph_id = 0;
        strokeTotal = [[Stroke alloc]init];
    }
    
    return self;
}

-(void)createWithPoint:(NSMutableArray *)pList Unit:(NSMutableArray *)unitList Graph:(NSMutableArray *)graphList PointGraph:(NSMutableArray *)pointGraphList NewGraph:(NSMutableArray *)newGraphList 
{
    PenInfo *penInfo= [[PenInfo alloc]initWithPoints:pList];
    NSMutableArray *newPointList = [penInfo newPenInfo];
    
    SCGraph *graph = NULL;
    //进行第一次拟合 返回拟合结果，可能是空指针（暨无法一次拟合成功的情况）
    Gunit* unit = [self first_units_recognize:newPointList];
    if(unit.type != 3 && unit != NULL)
    {
        graph = [self bind_unit_to_graphs:unit :unitList];
    }
    //进行第二次拟合
    if(graph==NULL) 
    {
        Stroke *stroke = [[Stroke alloc]initWithPoints:newPointList];
        [stroke findSpecialPoints];
        
        if([stroke.specialList count] > 2)
        {
            BOOL is_triangle = [stroke rebuild_triangle];
            if(is_triangle)//先进行三角形识别
            {
                graph = [self create_Triangle_Graph:stroke :unitList :pointGraphList];
            }
            else
            {
                bool is_retangle = [stroke rebuild_rectangle];  //判断能否生成四边形
                if(is_retangle) 
                {
                    graph = [self create_Rectangle_Graph:stroke :unitList :pointGraphList]; //生成四边形
                }
                else
                {
                    //第二次识别中，非四边形或三角形，切割成小的图元生成图形
                    BOOL is_hybridunit = [stroke rebuild_hybridunit];
                    
                    if(is_hybridunit)
                    {
                        for(int i=0; i<stroke.gList.count; i++)
                        {
                            Gunit* tempUnitFromList = [stroke.gList objectAtIndex:i];
                            SCGraph* tempGraph = [self bind_unit_to_graphs:tempUnitFromList :unitList];
                            if(![tempGraph isKindOfClass:[SCPointGraph class]])
                                [self push_back_new_graph:tempGraph :graphList :pointGraphList :newGraphList];
                        }
                    }
                    else
                    {
                        CurveUnit* tempCurveUnit = [[CurveUnit alloc]initWithPointArray:pList ID:1];
                        SCGraph* tempCurveGraph = [self bind_unit_to_graphs:tempCurveUnit :unitList];
                        [self push_back_new_graph:tempCurveGraph :graphList :pointGraphList :newGraphList];
                    }
                    return;
                }
            }
        }
        else
        {
            CurveUnit* tempCurveUnit = [[CurveUnit alloc]initWithPointArray:pList ID:1];
            SCGraph* tempCurveGraph = [self bind_unit_to_graphs:tempCurveUnit :unitList];
            [self push_back_new_graph:tempCurveGraph :graphList :pointGraphList :newGraphList];
        }
        
    }

    if(graph!=NULL)
        [self push_back_new_graph:graph :graphList :pointGraphList :newGraphList];
}

-(Gunit *)first_units_recognize:(NSMutableArray *)pList {
    Gunit* unit = NULL;
    int pointNum = [pList count];
    SCPoint *s;
    SCPoint *e;
    s = [pList objectAtIndex:0];
    e = [pList lastObject];
    //既当输入点少于10个，且收尾的距离小于12时为点图元
    if(0 < pointNum && pointNum <= point_pix_number
       &&  [Threshold Distance:s :e]<12)
    {
        unit=[[PointUnit alloc] initWithPoints:pList];
        return unit;
    }
    else
    {
        LineUnit* line = [[LineUnit alloc] initWithPoints:pList];
        if([line judge:pList])
        {
            unit=line;
            return unit;
        }
        else
        {
            CurveUnit* curve = [[CurveUnit alloc] initWithPointArray:pList];
            if([curve isSecondDegreeCurveWithPointArray:pList])
            {
                NSMutableArray* tempPointList = pList;
                Stroke* stroke = [[Stroke alloc]initWithPoints:tempPointList];
                [stroke findSpecialPoints];
                bool isTriangle = [stroke rebuild_triangle];
                bool isRectangle = [stroke rebuild_rectangle];
                if(!isTriangle && !isRectangle)
                {
                    [curve judgeCurveWithPointArray:pList];
                    return curve;
                }
                else
                {
                    unit = NULL;
                    return unit;
                }
            }
            else
            {
                unit = NULL;
                return unit;
            }
        }
    }
    
}

-(SCGraph *)bind_unit_to_graphs:(Gunit *)unit :(NSMutableArray *)unitList {
    if(unit==NULL)
        return NULL;
    [unitList addObject:unit];
    SCGraph* graph=NULL;
    switch(unit.type)
    {
        case 0:
            graph = [[SCPointGraph alloc]initWithUnit:(PointUnit*)unit andId:graph_id];
            break;
        case 1:
            graph = [[SCLineGraph alloc]initWithLine:(LineUnit*)unit andId:graph_id];
            break;
        case 2:
            //绑定二次曲线图形
            graph = [[SCCurveGraph alloc]initWithCurveUnit:(CurveUnit*)unit ID:graph_id];
            break;
        case 3:
            //绑定非二次曲线图形
            graph = [[SCCurveGraph alloc]initWithCurveUnit:(CurveUnit*)unit ID:graph_id];
            break;
            
    }
    if(NULL!=graph)
        graph_id++;
    return graph;
}


-(void)push_back_new_graph:(SCGraph *)graph :(NSMutableArray *)graphList :(NSMutableArray *)pointGraphList :newGraphList
{
    if([graph isKindOfClass:[SCPointGraph class]])
    {
        [pointGraphList addObject:(SCPointGraph*)graph];
    }
    [newGraphList addObject:graph];
//    [graphList addObject:graph];
}


-(SCGraph *)create_Line_Graph:(Stroke *)stroke :(NSMutableArray *)unitList :(NSMutableArray *)pointGraphList {
    LineUnit *tempunit;
    tempunit = [unitList objectAtIndex:0];
    SCGraph* graph=[[SCLineGraph alloc] initWithLine:tempunit andId:graph_id];
    graph_id++;
    return graph;
}

-(SCGraph *)create_Triangle_Graph:(Stroke *)stroke :(NSMutableArray *)unitList :(NSMutableArray *)pointGraphList {
    Gunit *tempunit;
    for(int i=0;i<[stroke.specialList count]-1;i++)
    {
        tempunit = [stroke.gList objectAtIndex:i];
        [unitList addObject:tempunit];
    }
    LineUnit *lineUnit0;
    LineUnit *lineUnit1;
    LineUnit *lineUnit2;
    lineUnit0 = [stroke.gList objectAtIndex:0];
    lineUnit1 = [stroke.gList objectAtIndex:1];
    lineUnit2 = [stroke.gList objectAtIndex:2];
    
    SCPoint* vertex0 =  lineUnit0.start;
    SCPoint* vertex1 =  lineUnit1.start;
    SCPoint* vertex2 =  lineUnit2.start;
    
    SCGraph *graph = [[SCTriangleGraph alloc] initWithLine0:lineUnit0 Line1:lineUnit1 Line2:lineUnit2 Id:graph_id Vertex0:vertex0 Vertex1:vertex1 Vertex2:vertex2];
    graph_id++;
    
    for(int i=0; i<3; i++)
    {
        SCTriangleGraph* tempTriangle = (SCTriangleGraph*)graph;
        SCPointGraph* tempPoint = [Threshold createNewPoint:[tempTriangle.triangleVertexes objectAtIndex:i]];
        [pointGraphList addObject:tempPoint];
        tempPoint.belong_to_triangle = YES;
        
        if(i == 0)
            [tempPoint constructConstraintGraph1:(SCGraph*)tempPoint Type1:Vertex0_Of_Triangle Graph2:graph Type2:Vertex0_Of_Triangle];
        else if(i == 1)
            [tempPoint constructConstraintGraph1:(SCGraph*)tempPoint Type1:Vertex1_Of_Triangle Graph2:graph Type2:Vertex1_Of_Triangle];
        else if(i == 2)
            [tempPoint constructConstraintGraph1:(SCGraph*)tempPoint Type1:Vertex2_Of_Triangle Graph2:graph Type2:Vertex2_Of_Triangle];
        
        [tempPoint release];
    }
    
    return graph;
}

-(SCGraph*)create_Rectangle_Graph:(Stroke*)stroke :(NSMutableArray*)unitList :(NSMutableArray*)pointList
{
    SCGraph* graph;
    
    LineUnit* lineUnit0;
    LineUnit* lineUnit1;
    LineUnit* lineUnit2;
    LineUnit* lineUnit3;
    lineUnit0 = [stroke.gList objectAtIndex:0];
    lineUnit1 = [stroke.gList objectAtIndex:1];
    lineUnit2 = [stroke.gList objectAtIndex:2];
    lineUnit3 = [stroke.gList objectAtIndex:3];
    
    graph = [[SCRectangleGraph alloc]initWithLine0:lineUnit0 Line1:lineUnit1 Line2:lineUnit2 Line3:lineUnit3 Id:graph_id];
    graph_id++;
    
    for(int i=0; i<4; i++)
    {
        SCRectangleGraph* tempRect = (SCRectangleGraph*)graph;
        SCPointGraph* tempPoint = [Threshold createNewPoint:[tempRect.rec_vertexes objectAtIndex:i]];
        [pointList addObject:tempPoint];
        tempPoint.belong_to_rectangle = YES;
        
        switch(i)
        {
            case 1:
                [tempPoint constructConstraintGraph1:(SCGraph*)tempPoint Type1:Vertex0_Of_Rectangle Graph2:graph Type2:Vertex0_Of_Rectangle];
                break;
            case 2:
                [tempPoint constructConstraintGraph1:(SCGraph*)tempPoint Type1:Vertex1_Of_Rectangle Graph2:graph Type2:Vertex1_Of_Rectangle];
                break;
            case 3:
                [tempPoint constructConstraintGraph1:(SCGraph*)tempPoint Type1:Vertex2_Of_Rectangle Graph2:graph Type2:Vertex2_Of_Rectangle];
                break;
            case 4:
                [tempPoint constructConstraintGraph1:(SCGraph*)tempPoint Type1:Vertex3_Of_Rectangle Graph2:graph Type2:Vertex3_Of_Rectangle];
                break;
        }
        
        [tempPoint release];
    }
    
    return graph;
}


@end
