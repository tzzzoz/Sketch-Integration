//
//  SCPointGraph.m
//  SmartGeometry
//
//  Created by kwan terry on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCPointGraph.h"

@implementation SCPointGraph

@synthesize freedomType,curve_start_end;
@synthesize pointUnit;
@synthesize is_vertex;
@synthesize is_on_line,is_on_circle;
@synthesize belong_to_triangle,belong_to_rectangle;
@synthesize in_graph_list;
@synthesize vertexOfCurveCenter,vertexOfSpecialLine,cut_point_of_circles;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        self.graphType = Point_Graph;
        pointUnit = [[PointUnit alloc]init];
        vertexOfCurveCenter = NO;
        vertexOfSpecialLine = NO;
        cut_point_of_circles = NO;
    }
    
    return self;
}

-(id)initWithUnit:(PointUnit*)pointUnit andId:(int)temp_local_graph_id
{
    [self init];
    
    self.pointUnit = pointUnit;
    freedomType    = 0;
    belong_to_triangle  = NO;
    belong_to_rectangle = NO;
    is_vertex = NO;
    is_on_line = NO;
    is_on_circle = NO;
    in_graph_list = NO;

    return self;
}

-(void)setPoint:(SCPoint *)point
{
    pointUnit.start.x = pointUnit.end.x = point.x;
    pointUnit.start.y = pointUnit.end.y = point.y;
}

-(Boolean)isUndo
{
    int online = 0, vertex = 0, oncircle = 0;
    if(belong_to_triangle || belong_to_rectangle)
    {
        for(int i=0; i<constraintList.count; i++)
        {
            Constraint* constraintTemp = [constraintList objectAtIndex:i];
            if((constraintTemp.constraintType == Vertex0_Of_Triangle)
               || (constraintTemp.constraintType == Vertex1_Of_Triangle)
               || (constraintTemp.constraintType == Vertex2_Of_Triangle)
               || (constraintTemp.constraintType == Vertex0_Of_Rectangle)
               || (constraintTemp.constraintType == Vertex1_Of_Rectangle)
               || (constraintTemp.constraintType == Vertex2_Of_Rectangle)
               || (constraintTemp.constraintType == Vertex3_Of_Rectangle))
                return !(constraintTemp.relatedGraph.isDraw);
        }
    }
    for(int i=0; i<constraintList.count; i++)
    {
        Constraint* constraintTemp = [constraintList objectAtIndex:i];
        if(((constraintTemp.constraintType == Point_On_Line)
           || (constraintTemp.constraintType == Point_On_Triangle_Line0)
           || (constraintTemp.constraintType == Point_On_Triangle_Line1)
           || (constraintTemp.constraintType == Point_On_Triangle_Line2)
           || (constraintTemp.constraintType == Point_On_Rectangle_Line0)
           || (constraintTemp.constraintType == Point_On_Rectangle_Line1)
           || (constraintTemp.constraintType == Point_On_Rectangle_Line2)
           || (constraintTemp.constraintType == Point_On_Rectangle_Line3))
           && constraintTemp.relatedGraph.isDraw)
            online++;
        if(constraintTemp.constraintType == Point_On_Circle && constraintTemp.relatedGraph.isDraw)
            oncircle++;
        if((constraintTemp.constraintType == Start_Vertex_Of_Line && constraintTemp.relatedGraph.isDraw)
           ||(constraintTemp.constraintType == End_Vertex_Of_Line && constraintTemp.relatedGraph.isDraw))
            vertex++;
    }
    if((online+vertex >= 2)||(online+oncircle >= 2)||(vertex+oncircle >= 2))
        return NO;
    if(vertex == 1)
        return NO;
    else
        return YES;
}

-(Boolean)isRedo
{
    if(freedomType == 0)
    {
        for(int i=0; i<constraintList.count; i++)
        {
            Constraint* constraintTemp = [constraintList objectAtIndex:i];
            if(constraintTemp.relatedGraph.isDraw)
                return YES;
        }
    }
    else if(freedomType == 1)
    {
        for(int i=0; i<constraintList.count; i++)
        {
            Constraint* constraintTemp = [constraintList objectAtIndex:i];
            if((constraintTemp.relatedGraph.isDraw)&&((constraintTemp.constraintType == Start_Vertex_Of_Line)||(constraintTemp.constraintType == End_Vertex_Of_Line)))
                return YES;
        }
    }
    else if(freedomType > 1)
    {
        int amount = 0;
        for(int i=0; i<constraintList.count; i++)
        {
            Constraint* constraintTemp = [constraintList objectAtIndex:i];
            if(constraintTemp.relatedGraph.isDraw)
                amount++;
            if(amount>1)
                return YES;
        }
    }
    return false;
}

-(void)resetAttribute
{
    freedomType = 0;
    belong_to_triangle=belong_to_rectangle=is_vertex=is_on_line=is_on_circle=NO;
    for(int i=0; i<constraintList.count; i++)
    {
        Constraint* constraintTemp = [constraintList objectAtIndex:i];
        if((constraintTemp.constraintType == Point_On_Line)
            || (constraintTemp.constraintType == Point_On_Triangle_Line0)
            || (constraintTemp.constraintType == Point_On_Triangle_Line1)
            || (constraintTemp.constraintType == Point_On_Triangle_Line2)
            || (constraintTemp.constraintType == Point_On_Rectangle_Line0)
            || (constraintTemp.constraintType == Point_On_Rectangle_Line1)
            || (constraintTemp.constraintType == Point_On_Rectangle_Line2)
            || (constraintTemp.constraintType == Point_On_Rectangle_Line3))
        {
            freedomType++;
            is_on_line = YES;
        }
        if((constraintTemp.constraintType == Vertex0_Of_Triangle)
           ||(constraintTemp.constraintType == Vertex1_Of_Triangle)
           ||(constraintTemp.constraintType == Vertex2_Of_Triangle))
        {
            belong_to_triangle = YES;
        }
        if((constraintTemp.constraintType == Vertex0_Of_Rectangle)
           ||(constraintTemp.constraintType == Vertex1_Of_Rectangle)
           ||(constraintTemp.constraintType == Vertex2_Of_Rectangle)
           ||(constraintTemp.constraintType == Vertex3_Of_Rectangle))
        {
            belong_to_rectangle = YES;
        }
        if(constraintTemp.constraintType == Point_On_Circle)
        {
            freedomType++;
            is_on_circle = YES;
        }
        if((constraintTemp.constraintType == Start_Vertex_Of_Line)||(constraintTemp.constraintType == End_Vertex_Of_Line))
        {
            is_vertex = YES;
        }
    }
}

-(void)drawWithContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.strokeSize);
    CGContextSetStrokeColorWithColor(context, self.graphColor);
    [pointUnit drawWithContext:context];
}

-(void)draw_extension_line:(CGContextRef)context
{
    for(int i=0; i<constraintList.count; i++)
    {
        LineUnit* lineUnit = [[LineUnit alloc]init];
        Constraint* constraintTemp = [constraintList objectAtIndex:i];
        if(constraintTemp.constraintType == Start_Vertex_Of_Line)
        {
            //if(!(self.pointUnit.start == (SCLineGraph*)constraintTemp.relatedGraph.line.start))
        }
    }
}

-(void)draw_dot_lineFromStart:(SCPoint *)startPoint ToEnd:(SCPoint *)endPoint WithContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 5.0f);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
}

-(void)draw_line_dot_extension_line:(LineUnit *)lineUnit WithContext:(CGContextRef)context
{
    float d1 = [Threshold Distance:lineUnit.start :lineUnit.end];
    float d2 = [Threshold Distance:pointUnit.start :lineUnit.start];
    float d3 = [Threshold Distance:pointUnit.start :lineUnit.end];
    if(d2 > d1 || d3 > d1)
    {
        SCPoint* pointTemp;
        pointTemp = d2<d3? lineUnit.start: lineUnit.end;
        [self draw_dot_lineFromStart:pointUnit.start ToEnd:pointTemp WithContext:context];
    }
    
}

@end
