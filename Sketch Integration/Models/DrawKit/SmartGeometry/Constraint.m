//
//  Constraint.m
//  SmartGeometry
//
//  Created by kwan terry on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Constraint.h"

@implementation Constraint

@synthesize related_graph_id;
@synthesize relatedGraph;
@synthesize constraintType;
@synthesize lastGraphSize;
@synthesize point_list;
@synthesize graph_list;
@synthesize delete_graph;
@synthesize selected_list;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithPointList:(NSMutableArray*)pointList GraphList:(NSMutableArray*)graphList SeletedList:(NSMutableArray*)selectedList
{
    self = [super init];
    
    point_list=pointList;
    graph_list=graphList;
    selected_list=selectedList;
    lastGraphSize=0;
    
    delete_graph = [[NSMutableArray alloc]init];
    
    return self;
}

-(void)recognizeConstraint
{
    for(int i=0; i<selected_list.count; i++)
    {
        SCGraph* tempGraph = [selected_list objectAtIndex:i];
        
        //首先处理直线与点列表的约束关系
        Boolean hasLine = NO;
        if([tempGraph isKindOfClass:[SCLineGraph class]])
        {
            hasLine = YES;
            SCLineGraph* tempLineGraph = (SCLineGraph*)tempGraph;
            if(point_list.count > 0)
            {
                //直线图形里面重载一个函数，专用来先与点列表进行约束识别
                /*!!!!!!!!recognizeConstraint实现了，还没有检查!!!!!!!!*/
                [tempLineGraph recognizeConstraint:point_list];
            }
        }
        
        //其次再处理曲线与点列表的约束关系
        Boolean hasCurve = NO;
        if([tempGraph isKindOfClass:[SCCurveGraph class]])
        {
            hasCurve = YES;
            SCCurveGraph* tempCurveGraph = (SCCurveGraph*)tempGraph;
            if(point_list.count > 0 && tempCurveGraph.curveUnit.newDrawPointList.count > 0 && !tempCurveGraph.curveUnit.isCompleteCurve)
            {
                [tempCurveGraph recognizeConstraintWithPointList:point_list];
            }
        }
        if(hasLine)
        {
            /*!!!!!!!!rebuildTraingleRectangle函数在本类没有实现!!!!!!!!*/
            [self rebuildTriangleRectangleWithGraph:tempGraph];
        }
        //然后进入一般的识别流程
        SCGraph* newGraph = [selected_list objectAtIndex:i];
        for (SCGraph* graph in graph_list) 
        {
            /*!!!!!!!!!isDraw流程没有做!!!!!!!!*/
            if(graph.isDraw && graph != newGraph)
                /*!!!!!!!!recognizeConstraint在各个图形类里面没有实现!!!!!!!!*/
                [graph recognizeConstraintWithGraph:newGraph PointList:point_list];
        }
        
        //如果是直线，构造直线的开始结束的约束点
        if([newGraph isKindOfClass:[SCLineGraph class]])
        {
            SCLineGraph* line = (SCLineGraph*)newGraph;
            /*!!!!!!!!!!!!!!hasStart!!!!!!!!!!!!!!*/
            if(!line.hasStart)
            {
                SCPointGraph* temp = [Threshold createNewPoint:line.lineUnit.start];
                temp.is_vertex = YES;
                line.hasStart  = YES;
                [point_list addObject:temp];
                [temp constructConstraintGraph1:(SCGraph*)temp Type1:Start_Vertex_Of_Line Graph2:newGraph Type2:Start_Vertex_Of_Line];
            }
            if(!line.hasEnd)
            {
                SCPointGraph* temp = [Threshold createNewPoint:line.lineUnit.end];
                temp.is_vertex = YES;
                line.hasEnd    = YES;
                [point_list addObject:temp];
                [temp constructConstraintGraph1:(SCGraph*)temp Type1:End_Vertex_Of_Line Graph2:newGraph Type2:End_Vertex_Of_Line];
            }
        }
        //如果是曲线，构造曲线的开始结束的约束点
        else if([newGraph isKindOfClass:[SCCurveGraph class]])
        {
            SCCurveGraph* curve = (SCCurveGraph*)newGraph;
            if(!curve.curveUnit.isCompleteCurve)
            {
                if(!curve.hasStart)
                {
                    SCPointGraph* temp = [Threshold createNewPoint:[curve.curveUnit.newDrawPointList objectAtIndex:0]];
                    temp.is_vertex = YES;
                    curve.hasStart = YES;
                    [point_list addObject:temp];
                    [temp constructConstraintGraph1:(SCGraph*)temp Type1:Start_Vertex_Of_Curve Graph2:newGraph Type2:Start_Vertex_Of_Curve];
                }
                if(!curve.hasEnd)
                {
                    SCPointGraph* temp = [Threshold createNewPoint:[curve.curveUnit.newDrawPointList lastObject]];
                    temp.is_vertex = YES;
                    curve.hasEnd   = YES;
                    [point_list addObject:temp];
                    [temp constructConstraintGraph1:(SCGraph*)temp Type1:End_Vertex_Of_Curve Graph2:newGraph Type2:End_Vertex_Of_Curve];
                }
            }
        }
        else if([newGraph isKindOfClass:[SCPointGraph class]])
        {
            SCPointGraph* point = (SCPointGraph*)newGraph;
            point.in_graph_list = YES;
        }
        /*!!!!!!!!!!!注意这里对graph_list进行初始化更新!!!!!!!!!!!!!!!!*/
        [graph_list addObject:newGraph];
    }
}

-(BOOL)rebuildTriangleRectangleWithGraph:(SCGraph *)graph
{
    SCGraph* newGraph = graph;
    SCPointGraph* start = NULL;
    SCPointGraph* end   = NULL;
    SCPointGraph* thirdPoint = NULL;
    SCPointGraph* fourthPoint = NULL;
    SCLineGraph*  firstLine = NULL;
    SCLineGraph*  secondLine = NULL;
    SCLineGraph*  thirdLine = NULL;
    SCLineGraph*  fourthLine = NULL;
    NSMutableArray* start_connect_lines = [[NSMutableArray alloc]init];
    NSMutableArray* end_connect_lines = [[NSMutableArray alloc]init];
    NSMutableArray* start_connect_line_points = [[NSMutableArray alloc]init];
    NSMutableArray* end_connect_line_points = [[NSMutableArray alloc]init];
    
    if([newGraph isKindOfClass:[SCLineGraph class]])
    {
        SCLineGraph* newLineGraph = (SCLineGraph*)newGraph;
        if(newLineGraph.hasStart && newLineGraph.hasEnd)
        {
            firstLine = newLineGraph;
            //先获得这条直线的两个端点相连的point_graph
            [self getLineVertexWithGraph:firstLine StartPoint:&(start) EndPoint:&(end)];
            NSLog(@"开始点！！！！%f",start.pointUnit.start.x);
            //再通过这两个point_graph获取和这条直线相连的所有直线
            for(int i=0; i<graph_list.count; i++)
            {
                SCGraph* tempGraph = [graph_list objectAtIndex:i];
                if([tempGraph isKindOfClass:[SCLineGraph class]] && tempGraph!=newGraph)
                {
                    SCLineGraph* tempLineGraph = (SCLineGraph*)tempGraph;
                    if(!tempLineGraph.isSpecial && !tempLineGraph.isTangent)
                    {
                        //获取和直线first_line相连的所有直线的其余的端点
                        [self getAnotherVertexWithGraph:tempLineGraph Point:end ConnectLine:&(end_connect_lines) ConnectLinePoint:&(end_connect_line_points)];
                        [self getAnotherVertexWithGraph:tempLineGraph Point:start ConnectLine:&(start_connect_lines) ConnectLinePoint:&(start_connect_line_points)];
                    }
                }
            }
        }
        /*!!!!!!!!判断函数还没实现!!!!!!!*/
        //在两组端点里面查找到相同的点，则这个点就是三角形的第三个点，可以构成三角形
        if([self findTheThirdPointWithThirdPoint:&thirdPoint SecondLine:&secondLine ThirdLine:&thirdLine StartConnectLinePoint:start_connect_line_points EndConnectLinePoint:end_connect_line_points StartConnectLine:start_connect_lines EndConnectLine:end_connect_lines])
        {
            [self buildTriangleWithFirstLine:firstLine SecondLine:secondLine ThirdLine:thirdLine Start:start End:end ThirdPoint:thirdPoint];
            return YES;
        }
        else if([self canBeRectangleWithThirdPoint:&thirdPoint FourthPoint:&fourthPoint SecondLine:&secondLine ThirdLine:&thirdLine FourthLine:&fourthLine StartConnectLinePoint:start_connect_line_points EndConnectLinePoint:end_connect_line_points StartConnectLine:start_connect_lines EndConnectLine:end_connect_lines] && start!=thirdPoint && start!=fourthPoint)
        {
            [self buildRectangleWithPoint0:start Point1:end Point2:thirdPoint Point3:fourthPoint FirstLine:firstLine SecondLine:secondLine ThirdLine:thirdLine FourthLine:fourthLine];
            return YES;
        }
    }
    return NO;
}

-(bool)canBeRectangleWithThirdPoint:(SCPointGraph **)thirdPoint FourthPoint:(SCPointGraph **)fourthPoint SecondLine:(SCLineGraph **)secondLine ThirdLine:(SCLineGraph **)thirdLine FourthLine:(SCLineGraph **)fourthLine StartConnectLinePoint:(NSMutableArray *)startConnectLinePoint EndConnectLinePoint:(NSMutableArray *)endConnectLinePoint StartConnectLine:(NSMutableArray *)startConnectLine EndConnectLine:(NSMutableArray *)endConnectLine
{
    NSMutableArray* lineList;
    lineList=[[NSMutableArray alloc] init];
    for (int i=graph_list.count-1; i>=0; i--) 
    {
        if ([[graph_list objectAtIndex:i] isKindOfClass:[SCLineGraph class]])
        {
            SCLineGraph* line=(SCLineGraph*)[graph_list objectAtIndex:i];
            [lineList addObject:line];
        }
    }
    for (int i=startConnectLinePoint.count-1; i>=0; i--)
    {
        for (int j=0; j<lineList.count; j++) 
        {
            if ([[[startConnectLinePoint objectAtIndex:i] pointUnit] start] == [[[lineList objectAtIndex:j] lineUnit] start]) 
            {
                for (int k=endConnectLinePoint.count-1; k>=0; k--) 
                {
                    if ([[[endConnectLinePoint objectAtIndex:k] pointUnit] start]==[[[lineList objectAtIndex:j] lineUnit] start]) 
                    {
                        *secondLine  = (SCLineGraph*)[startConnectLine objectAtIndex:i];
                        *thirdPoint  = [startConnectLinePoint objectAtIndex:i];
                        *thirdLine   = (SCLineGraph*)[endConnectLine objectAtIndex:k];
                        *fourthPoint = [endConnectLinePoint objectAtIndex:k];
                        *fourthLine  = [lineList objectAtIndex:j];
                        if (*thirdLine != *fourthLine && *thirdLine != *secondLine && *fourthLine != *secondLine) 
                        {
                            return true;
                        }
                    }
                    else if([[[endConnectLinePoint objectAtIndex:k] pointUnit] start]==[[[lineList objectAtIndex:j] lineUnit] end])
                    {
                        *secondLine  =(SCLineGraph*)[startConnectLine objectAtIndex:i];
                        *thirdPoint  =[startConnectLinePoint objectAtIndex:i];
                        *thirdLine   =(SCLineGraph*)[endConnectLine objectAtIndex:k];
                        *fourthPoint =[endConnectLinePoint objectAtIndex:k];
                        *fourthLine  =[lineList objectAtIndex:j];
                        if (*thirdLine != *fourthLine && *thirdLine != *secondLine && *fourthLine != *secondLine) 
                        {
                            return true;
                        }
                    }
                }
            }
            else if([[[startConnectLinePoint objectAtIndex:i] pointUnit] start]==[[[lineList objectAtIndex:j] lineUnit] end])
            {
                for (int k=endConnectLinePoint.count-1; k>=0; k--) 
                {
                    if ([[[endConnectLinePoint objectAtIndex:k] pointUnit] start]==[[[lineList objectAtIndex:j] lineUnit] start]) 
                    {
                        *secondLine  =(SCLineGraph*)[startConnectLine objectAtIndex:i];
                        *thirdPoint  =[startConnectLinePoint objectAtIndex:i];
                        *thirdLine   =(SCLineGraph*)[endConnectLine objectAtIndex:k];
                        *fourthPoint =[endConnectLinePoint objectAtIndex:k];
                        *fourthLine  =[lineList objectAtIndex:j];
                        if (*thirdLine != *fourthLine && *thirdLine != *secondLine && *fourthLine != *secondLine) 
                        {
                            return true;
                        }
                    }
                    else if([[[endConnectLinePoint objectAtIndex:k] pointUnit] start]==[[[lineList objectAtIndex:j] lineUnit] end])
                    {
                        *secondLine  =(SCLineGraph*)[startConnectLine objectAtIndex:i];
                        *thirdPoint  =[startConnectLinePoint objectAtIndex:i];
                        *thirdLine   =(SCLineGraph*)[endConnectLine objectAtIndex:k];
                        *fourthPoint =[endConnectLinePoint objectAtIndex:k];
                        *fourthLine  =[lineList objectAtIndex:j];
                        if (*thirdLine != *fourthLine && *thirdLine != *secondLine && *fourthLine != *secondLine)
                        {
                            return true;
                        }
                    }
                }
            }
        }
    }
    return false;
}

-(bool)findTheThirdPointWithThirdPoint:(SCPointGraph**) thirdPoint SecondLine:(SCLineGraph**) secondLine ThirdLine:(SCLineGraph**) thirdLine StartConnectLinePoint:(NSMutableArray*) startConnectLinePoint EndConnectLinePoint:(NSMutableArray*) endConnectLinePoint StartConnectLine:(NSMutableArray*)startConnectLine EndConnectLine:(NSMutableArray*)endConnectLine
{
    int i=0;
    int j=0;
    bool found = false;
    if(startConnectLinePoint.count<endConnectLinePoint.count)
    {
        for (i=0; i<startConnectLinePoint.count; i++) 
        {
            for (j=0; j<endConnectLinePoint.count; j++) 
            {
                if ([startConnectLinePoint objectAtIndex:i]==[endConnectLinePoint objectAtIndex:j])
                {
                    found = true;
                    break;
                }
            }
            if (found) 
            {
                break;
            }
        }
        if (found) 
        {
            *secondLine = (SCLineGraph*)[startConnectLine objectAtIndex:i];
            *thirdLine  = (SCLineGraph*)[endConnectLine objectAtIndex:j];
            *thirdPoint = [startConnectLinePoint objectAtIndex:i];
        }
    }
    else
    {
        for (i=0; i<endConnectLinePoint.count; i++) 
        {
            for (j=0; j<startConnectLinePoint.count; j++) 
            {
                if ([endConnectLinePoint objectAtIndex:i]==[startConnectLinePoint objectAtIndex:j]) 
                {
                    found =true;
                    break;
                }
            }
            if (found) 
            {
                break;
            }
        }
        if (found) 
        {
            *secondLine =(SCLineGraph*)[endConnectLine objectAtIndex:i];
            *thirdLine  =(SCLineGraph*)[startConnectLine objectAtIndex:j];
            *thirdPoint =[startConnectLinePoint objectAtIndex:j];
        }
    }
    if (!(*thirdPoint==nil) && !(*secondLine==nil) && *secondLine != *thirdLine) 
    {
        return true;
    }
    return false;
}

-(void)buildTriangleWithFirstLine:(SCLineGraph *)firstLine SecondLine:(SCLineGraph *)secondLine ThirdLine:(SCLineGraph *)thirdLine Start:(SCPointGraph*)start End:(SCPointGraph *)end ThirdPoint:(SCPointGraph *)thirdPoint
{
    if(start.vertexOfSpecialLine==NO || end.vertexOfSpecialLine==NO || thirdPoint.vertexOfSpecialLine==NO)
    {
        LineUnit* line1 = firstLine.lineUnit;
        LineUnit* line2 = secondLine.lineUnit;
        LineUnit* line3 = thirdLine.lineUnit;
        
        for(int i=0; i<graph_list.count; i++)
        {
            SCGraph* tempGraph = [graph_list objectAtIndex:i];
            if(tempGraph == secondLine)
                [delete_graph addObject:(SCGraph*)secondLine];
            else if(tempGraph == thirdLine)
                [delete_graph addObject:(SCGraph*)thirdLine];
        }
        
        SCTriangleGraph* triangle = [[SCTriangleGraph alloc]initWithLine0:line1 Line1:line2 Line2:line3 Id:graphID Vertex0:start.pointUnit.start Vertex1:end.pointUnit.start Vertex2:thirdPoint.pointUnit.start];
        [selected_list addObject:(SCGraph*)triangle];
        graphID++;
        
        //清除之前的约束
        [self eraseConstraintWithLocal:(SCGraph*)start RelatedGraph:(SCGraph*)firstLine];
        [self eraseConstraintWithLocal:(SCGraph*)start RelatedGraph:(SCGraph*)thirdLine];
        [self eraseConstraintWithLocal:(SCGraph*)end RelatedGraph:(SCGraph*)firstLine];
        [self eraseConstraintWithLocal:(SCGraph*)end RelatedGraph:(SCGraph*)secondLine];
        [self eraseConstraintWithLocal:(SCGraph*)thirdPoint RelatedGraph:(SCGraph*)secondLine];
        [self eraseConstraintWithLocal:(SCGraph*)thirdPoint RelatedGraph:(SCGraph*)thirdLine];
        
        for(int i=0; i<3; i++)
        {
            [self bindToTriangleRectangleWithPoint:start Graph:triangle i:i];
            [self bindToTriangleRectangleWithPoint:end Graph:triangle i:i];
            [self bindToTriangleRectangleWithPoint:thirdPoint Graph:triangle i:i];
        }
        [self transformLineToTriangleRectangleWithLine:firstLine Graph:triangle];
        [self transformLineToTriangleRectangleWithLine:secondLine Graph:triangle];
        [self transformLineToTriangleRectangleWithLine:thirdLine Graph:triangle];
        /*!!!!!!!!!!!!!!!!!!!!!!!!why selected_list!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
        [self.selected_list removeObject:firstLine];
        [self.graph_list removeObject:secondLine];
        [self.graph_list removeObject:thirdLine];
//        [self eraseGraphFromGraphListWithGraph:(SCGraph*)firstLine GraphList:&selected_list];
//        [self eraseGraphFromGraphListWithGraph:(SCGraph*)secondLine GraphList:&graph_list];
//        [self eraseGraphFromGraphListWithGraph:(SCGraph*)thirdLine GraphList:&graph_list];

//        [firstLine dealloc];
//        [secondLine dealloc];
//        [thirdLine dealloc];
        
        /*!!!!!!!!!!!!!!识别三角形类型还没实现!!!!!!!!!!*/
//        if([triangle willRecognizeType])
//        {
//            [triangle recognizeTriangleType];
//        }
    }
}

-(void)buildRectangleWithPoint0:(SCPointGraph *)v0 Point1:(SCPointGraph *)v1 Point2:(SCPointGraph *)v2 Point3:(SCPointGraph *)v3 FirstLine:(SCLineGraph *)firstLine SecondLine:(SCLineGraph *)secondLine ThirdLine:(SCLineGraph *)thirdLine FourthLine:(SCLineGraph *)fourthLine
{
    LineUnit* l1=firstLine.lineUnit;
    LineUnit* l2=secondLine.lineUnit;
    LineUnit* l3=thirdLine.lineUnit;
    LineUnit* l4=fourthLine.lineUnit;
    
    for (int i=0; i<graph_list.count; i++) 
    {
        if ([graph_list objectAtIndex:i]==(SCGraph*)secondLine) 
        {
            [delete_graph addObject:(SCGraph*)secondLine];
        }
        else if([graph_list objectAtIndex:i]==(SCGraph*)thirdLine)
        {
            [delete_graph addObject:(SCGraph*)thirdLine];
        }
        else if([graph_list objectAtIndex:i]==(SCGraph*)fourthLine)
        {
            [delete_graph addObject:(SCGraph*)fourthLine];
        }
    }
    SCRectangleGraph* rectangle = [[SCRectangleGraph alloc]initWithLine0:l1 Line1:l2 Line2:l3 Line3:l4 Id:related_graph_id];
    related_graph_id++;
    [selected_list addObject:(SCGraph*)rectangle];
    v0.belong_to_rectangle=true;
    v1.belong_to_rectangle=true;
    v2.belong_to_rectangle=true;
    v3.belong_to_rectangle=true;
    [self eraseConstraintWithLocal:(SCGraph*)v0 RelatedGraph:(SCGraph*)firstLine];
    [self eraseConstraintWithLocal:(SCGraph*)v0 RelatedGraph:(SCGraph*)secondLine];
    [self eraseConstraintWithLocal:(SCGraph*)v1 RelatedGraph:(SCGraph*)firstLine];
    [self eraseConstraintWithLocal:(SCGraph*)v1 RelatedGraph:(SCGraph*)thirdLine];
    [self eraseConstraintWithLocal:(SCGraph*)v2 RelatedGraph:(SCGraph*)secondLine];
    [self eraseConstraintWithLocal:(SCGraph*)v2 RelatedGraph:(SCGraph*)fourthLine];
    [self eraseConstraintWithLocal:(SCGraph*)v3 RelatedGraph:(SCGraph*)thirdLine];
    [self eraseConstraintWithLocal:(SCGraph*)v3 RelatedGraph:(SCGraph*)fourthLine];
    
    for (int i=0; i<4; i++) 
    {
        [self bindToTriangleRectangleWithPoint:v0 Graph:(SCGraph*)rectangle i:i];
        [self bindToTriangleRectangleWithPoint:v1 Graph:(SCGraph*)rectangle i:i];
        [self bindToTriangleRectangleWithPoint:v2 Graph:(SCGraph*)rectangle i:i];
        [self bindToTriangleRectangleWithPoint:v3 Graph:(SCGraph*)rectangle i:i];
    }
    [self transformLineToTriangleRectangleWithLine:firstLine Graph:relatedGraph];
    [self transformLineToTriangleRectangleWithLine:secondLine Graph:relatedGraph];
    [self transformLineToTriangleRectangleWithLine:thirdLine Graph:relatedGraph];
    [self transformLineToTriangleRectangleWithLine:fourthLine Graph:relatedGraph];
    ///////////////////////////
    [self.selected_list removeObject:firstLine];
    [self.graph_list removeObject:secondLine];
    [self.graph_list removeObject:thirdLine];
    [self.graph_list removeObject:fourthLine];
//    [self eraseGraphFromGraphListWithGraph:(SCGraph*)firstLine GraphList:&selected_list];
//    [self eraseGraphFromGraphListWithGraph:secondLine GraphList:&graph_list];
//    [self eraseGraphFromGraphListWithGraph:thirdLine GraphList:&graph_list];
    
//    [firstLine dealloc];
//    [secondLine dealloc];
//    [thirdLine dealloc];
    
    //特殊四边形识别
}

-(void)transformLineToTriangleRectangleWithLine:(SCLineGraph *)lineGraph Graph:(SCGraph *)graph
{
    if ([graph isKindOfClass:[SCTriangleGraph class]]) 
    {
        SCTriangleGraph* triangleGraph=(SCTriangleGraph*)graph;
        for (int i=lineGraph.constraintList.count-1; i>=0; i--) 
        {
            if ([[lineGraph.constraintList objectAtIndex:i] constraintType]==Point_On_Line) 
            {
                SCGraph* point=[[lineGraph.constraintList objectAtIndex:i] relatedGraph];
                if ([Threshold pointToLIne:[[(SCPointGraph*)point pointUnit] start] :[triangleGraph.triangleLines objectAtIndex:0]]<=3)
                {
                    [triangleGraph constructConstraintGraph1:(SCGraph*)triangleGraph Type1:Point_On_Triangle_Line0 Graph2:[[lineGraph.constraintList objectAtIndex:i] relatedGraph] Type2:Point_On_Triangle_Line0];
                } 
                else if([Threshold pointToLIne:[[(SCPointGraph*)point pointUnit] start] :[triangleGraph.triangleLines objectAtIndex:1]]<=3)
                {
                    [triangleGraph constructConstraintGraph1:(SCGraph*)triangleGraph Type1:Point_On_Triangle_Line1 Graph2:[[lineGraph.constraintList objectAtIndex:i] relatedGraph] Type2:Point_On_Triangle_Line1];
                }
                else if([Threshold pointToLIne:[[(SCPointGraph*)point pointUnit] start] :[triangleGraph.triangleLines objectAtIndex:2]]<=3)
                {
                    [triangleGraph constructConstraintGraph1:(SCGraph*)triangleGraph Type1:Point_On_Triangle_Line2 Graph2:[[lineGraph.constraintList objectAtIndex:i] relatedGraph] Type2:Point_On_Triangle_Line2];
                }
                [self eraseConstraintWithLocal:(SCGraph*)lineGraph RelatedGraph:[[lineGraph.constraintList objectAtIndex:i] relatedGraph]];
            }
        }
    } 
    else if([graph isKindOfClass:[SCRectangleGraph class]])
    {
        SCRectangleGraph* rectangleGraph=(SCRectangleGraph*)graph;
        for (int i=lineGraph.constraintList.count-1; i>=0; i--) 
        {
            if([[lineGraph.constraintList objectAtIndex:i] constraintType]==Point_On_Line)
            {
                SCGraph* point=[[lineGraph.constraintList objectAtIndex:i] relatedGraph];
                if ([Threshold pointToLIne:[[(SCPointGraph*)point pointUnit] start] :[rectangleGraph.rec_lines objectAtIndex:0]]<=3)
                {
                    [rectangleGraph constructConstraintGraph1:(SCGraph*)rectangleGraph Type1:Point_On_Rectangle_Line0 Graph2:point Type2:Point_On_Rectangle_Line0];
                }
                else if([Threshold pointToLIne:[[(SCPointGraph*)point pointUnit] start] :[rectangleGraph.rec_lines objectAtIndex:1]]<=3)
                {
                    [rectangleGraph constructConstraintGraph1:(SCGraph*)rectangleGraph Type1:Point_On_Rectangle_Line1 Graph2:point Type2:Point_On_Rectangle_Line1];
                }
                else if([Threshold pointToLIne:[[(SCPointGraph*)point pointUnit] start] :[rectangleGraph.rec_lines objectAtIndex:2]]<=3)
                {
                    [rectangleGraph constructConstraintGraph1:(SCGraph*)rectangleGraph Type1:Point_On_Rectangle_Line2 Graph2:point Type2:Point_On_Rectangle_Line2];
                }
                else if([Threshold pointToLIne:[[(SCPointGraph*)point pointUnit] start] :[rectangleGraph.rec_lines objectAtIndex:3]]<=3)
                {
                    [rectangleGraph constructConstraintGraph1:(SCGraph*)rectangleGraph Type1:Point_On_Rectangle_Line3 Graph2:point Type2:Point_On_Rectangle_Line3];
                }
                [self eraseConstraintWithLocal:(SCGraph*)lineGraph RelatedGraph:[[lineGraph.constraintList objectAtIndex:i] relatedGraph]];
            }
        }
    }
}

-(void)bindToTriangleRectangleWithPoint:(SCPointGraph *)point Graph:(SCGraph *)graph i:(int)i
{
    if ([graph isKindOfClass:[SCTriangleGraph class]]) 
    {
        SCTriangleGraph* triangle=(SCTriangleGraph*)graph;
        if (point.pointUnit.start == [triangle.triangleVertexes objectAtIndex:i]) 
        {
            if (i==0) 
            {
                [point constructConstraintGraph1:point Type1:Vertex0_Of_Triangle Graph2:graph Type2:Vertex0_Of_Triangle];
            }
            else if(i==1)
            {
                [point constructConstraintGraph1:point Type1:Vertex1_Of_Triangle Graph2:graph Type2:Vertex1_Of_Triangle];
            }
            else if(i==2)
            {
                [point constructConstraintGraph1:point Type1:Vertex2_Of_Triangle Graph2:graph Type2:Vertex2_Of_Triangle];
            }
        }
        point.belong_to_triangle=true;
    }
    else if([graph isKindOfClass:[SCRectangleGraph class]])
    {
        SCRectangleGraph* rectangle=(SCRectangleGraph*)graph;
        if(point.pointUnit.start==[rectangle.rec_vertexes objectAtIndex:i])
        {
            switch (i) 
            {
                case 0:
                    [point constructConstraintGraph1:point Type1:Vertex0_Of_Rectangle Graph2:graph Type2:Vertex0_Of_Rectangle];
                    break;
                case 1:
                    [point constructConstraintGraph1:point Type1:Vertex1_Of_Rectangle Graph2:graph Type2:Vertex1_Of_Rectangle];
                    break;
                case 2:
                    [point constructConstraintGraph1:point Type1:Vertex2_Of_Rectangle Graph2:graph Type2:Vertex2_Of_Rectangle];
                    break;
                case 3:
                    [point constructConstraintGraph1:point Type1:Vertex3_Of_Rectangle Graph2:graph Type2:Vertex3_Of_Rectangle];
                    break;
                default:
                    break;
            }
        }
        point.belong_to_rectangle=true;
    }
}

-(void)eraseGraphFromGraphListWithGraph:(SCGraph *)graph GraphList:(NSMutableArray **)graphList
{
    for (int i =0 ; i<[*graphList count]; i++) 
    {
        SCGraph* graphTemp = [*graphList objectAtIndex:i];
        /*!!!!!!!!!!!!!!!!not correct yet!!!!!!!!!!!!!!!!*/
//        if (graphTemp.local_graph_id == graph.local_graph_id) 
        if(graphTemp == graph)
        {
            [*graphList removeObject:graphTemp];
            return;
        }
    }
}

-(void)eraseConstraintWithLocal:(SCGraph *)local RelatedGraph:(SCGraph *)related_Graph
{
    for (int i =0 ; i<local.constraintList.count; i++) 
    {
        Constraint* constraintTemp = [local.constraintList objectAtIndex:i];
        if (constraintTemp.relatedGraph == related_Graph) 
        {
            [local.constraintList removeObject:constraintTemp];
            break;
        }
    }
    SCGraph* otherGraph=nil;
    SCGraph* deletGraph=nil;
    for (int i =0 ; i<related_Graph.constraintList.count; i++) 
    {
        Constraint* constraintTemp = [related_Graph.constraintList objectAtIndex:i];
        if (constraintTemp.relatedGraph == local) 
        {
            [related_Graph.constraintList removeObject:constraintTemp];
        }
        else if(constraintTemp.constraintType==Radius || constraintTemp.constraintType==Diameter)
        {
            otherGraph=constraintTemp.relatedGraph;
            deletGraph=related_Graph;
            [related_Graph.constraintList removeObject:constraintTemp];
        }
    }
    if (otherGraph!=nil) 
    {
        for (int i =0 ; i<otherGraph.constraintList.count; i++)
        {
            Constraint* constraintTemp = [otherGraph.constraintList objectAtIndex:i];
            if ((constraintTemp.constraintType == Radius||constraintTemp.constraintType == Diameter) && constraintTemp.relatedGraph==deletGraph) 
            {
                [otherGraph.constraintList removeObject:constraintTemp];
            }
        }
    }
}

-(void)getAnotherVertexWithGraph:(SCGraph *)graph Point:(SCPointGraph *)point ConnectLine:(NSMutableArray **)connectLine ConnectLinePoint:(NSMutableArray **)connectLinePoint
{
    SCPointGraph* otherPoint = nil;
    ConstraintType otherPointType;
    ConstraintType type;
    bool foundTheConnectPoint = false;
    
    for (int i =0 ; i<graph.constraintList.count; i++) 
    {
        Constraint* constraintTemp = [graph.constraintList objectAtIndex:i];
        if (constraintTemp.relatedGraph == point) 
        {
            foundTheConnectPoint = true;
            type = constraintTemp.constraintType;
            if (type == Start_Vertex_Of_Line) 
                otherPointType = End_Vertex_Of_Line;
            else if(type == End_Vertex_Of_Line)
                otherPointType = Start_Vertex_Of_Line;
            else 
                foundTheConnectPoint=false;
            break;
        }
    }
    if (!foundTheConnectPoint) 
        return;
    for (int j=0; j<graph.constraintList.count; j++) 
    {
        Constraint* constraintTemp = [graph.constraintList objectAtIndex:j];
        if (constraintTemp.constraintType==otherPointType && constraintTemp.relatedGraph!=point) 
        {
            otherPoint = (SCPointGraph*)constraintTemp.relatedGraph;
            break;
        }
    }
    if (foundTheConnectPoint) 
    {
        [*connectLine addObject:graph];
        if(otherPoint != NULL)
            [*connectLinePoint addObject:otherPoint];
    }
}

-(void)getLineVertexWithGraph:(SCGraph *)graph StartPoint:(SCPointGraph **)start EndPoint:(SCPointGraph **)end
{
    for (int i=0;i<graph.constraintList.count; i++) 
    {
        Constraint* constraintTemp = [graph.constraintList objectAtIndex:i];
        if(constraintTemp.constraintType == Start_Vertex_Of_Line)
            *start = (SCPointGraph*) (constraintTemp.relatedGraph);
        else if(constraintTemp.constraintType == End_Vertex_Of_Line)
            *end = (SCPointGraph*) (constraintTemp.relatedGraph);
    }
    
}

-(void)setLastGraphSize:(int)n
{
    lastGraphSize=n;
}

@end
