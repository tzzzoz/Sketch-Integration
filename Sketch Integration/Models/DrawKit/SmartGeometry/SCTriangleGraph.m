//
//  SCTriangleGraph.m
//  SmartGeometry
//
//  Created by kwan terry on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCTriangleGraph.h"

@implementation SCTriangleGraph

@synthesize triangleLines,triangleAngles,triangleVertexes,triangleLineDistance;
@synthesize triangleType,typeVertexIndex;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        triangleAngles       = [[NSMutableArray alloc]init];
        triangleLines        = [[NSMutableArray alloc]init];
        triangleVertexes     = [[NSMutableArray alloc]init];
        triangleLineDistance = [[NSMutableArray alloc]init];
        self.graphType = Triangle_Graph;
    }
    
    return self;
}

-(id)initWithLine0:(LineUnit *)line0 Line1:(LineUnit *)line1 Line2:(LineUnit *)line2 Id:(int)temp_local_id
{
    self = [super initWithId:temp_local_id];
    [self initValuesWithLine0:line0 Line1:line1 Line2:line2];
    return self;
}

-(id)initWithLine0:(LineUnit *)line0 Line1:(LineUnit *)line1 Line2:(LineUnit *)line2 Id:(int)temp_local_graph_id Vertex0:(SCPoint *)vertex0 Vertex1:(SCPoint *)vertex1 Vertex2:(SCPoint *)vertex2
{
    self = [super init];
    
    [self init];
    
    [super initWithId:temp_local_graph_id];
    
    //[self initValuesWithLine0:line0 Line1:line1 Line2:line2];
    
    [self.triangleVertexes addObject:vertex0];
    [self.triangleVertexes addObject:vertex1];
    [self.triangleVertexes addObject:vertex2];
    
    LineUnit* l1 = [[LineUnit alloc]initWithStartPoint:vertex0 endPoint:vertex1];
    LineUnit* l2 = [[LineUnit alloc]initWithStartPoint:vertex1 endPoint:vertex2];
    LineUnit* l3 = [[LineUnit alloc]initWithStartPoint:vertex2 endPoint:vertex0];
    
    [self initValuesWithLine0:l1 Line1:l2 Line2:l3];
     
     return self;    
}

-(void)initValuesWithLine0:(LineUnit *)line0 Line1:(LineUnit *)line1 Line2:(LineUnit *)line2
{
    [triangleLines addObject:line0];
    [triangleLines addObject:line1];
    [triangleLines addObject:line2];
    
    //[self setVertex];
}

-(void)setVertex
{
    SCPoint* v0 = [[SCPoint alloc]initWithX:0.0f andY:0.0f];
    SCPoint* v1 = [[SCPoint alloc]initWithX:0.0f andY:0.0f];
    SCPoint* v2 = [[SCPoint alloc]initWithX:0.0f andY:0.0f];
    
    [triangleVertexes removeAllObjects];
    [triangleVertexes addObject:v0];
    [triangleVertexes addObject:v1];
    [triangleVertexes addObject:v2];
    
    LineUnit* tl0 = [triangleLines objectAtIndex:0];
    LineUnit* tl1 = [triangleLines objectAtIndex:1];
    LineUnit* tl2 = [triangleLines objectAtIndex:2];
    
    v0 = [triangleVertexes objectAtIndex:0];
    v1 = [triangleVertexes objectAtIndex:1];
    v2 = [triangleVertexes objectAtIndex:2];
    
    if((tl1.start.x==tl2.start.x&&tl1.start.y==tl2.start.y)
       ||(tl1.start.x==tl2.end.x&&tl1.start.y==tl2.end.y))
    {
        v0.x=tl1.start.x;
        v0.y=tl1.start.y;
    }
    if((tl1.end.x==tl2.start.x&&tl1.end.y==tl2.start.y)
       ||(tl1.end.x==tl2.end.x&&tl1.end.y==tl2.end.y))
    {
        v0.x=tl1.end.x;
        v0.y=tl1.end.y;
    }
    if((tl0.start.x==tl2.start.x&&tl0.start.y==tl2.start.y)
       ||(tl0.start.x==tl2.end.x&&tl0.start.y==tl2.end.y))
    {
        v1.x=tl0.start.x;
        v1.y=tl0.start.y;
    }
    if((tl0.end.x==tl2.start.x&&tl0.end.y==tl2.start.y)
       ||(tl0.end.x==tl2.end.x&&tl0.end.y==tl2.end.y))
    {
        v1.x=tl0.end.x;
        v1.y=tl0.end.y;
    }
    if((tl0.start.x==tl1.start.x&&tl0.start.y==tl1.start.y)
       ||(tl0.start.x==tl1.end.x&&tl0.start.y==tl1.end.y))
    {
       v2.x=tl0.start.x;
       v2.y=tl0.start.y;
    }
    if((tl0.end.x==tl1.start.x&&tl0.end.y==tl1.start.y)
       ||(tl0.end.x==tl1.end.x&&tl0.end.y==tl1.end.y))
    {
       v2.x=tl0.end.x;
       v2.y=tl0.end.y;
    }
    
    [tl0 setstart:v1];
    [tl0 setend:v2];
    [tl1 setstart:v2];
    [tl1 setend:v0];
    [tl2 setstart:v0];
    [tl2 setend:v1];
}

-(void)drawWithContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.strokeSize);
    CGContextSetStrokeColorWithColor(context, self.graphColor);
    
    //画三条边
    for(int i=0; i<3; i++)
    {
        LineUnit* line = [triangleLines objectAtIndex:i]; 
        [line drawWithContext:context];
    }

    //画三个顶点
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
//    for(int j=0; j<3; j++)
//    {
//        NSMutableArray* vl = triangleVertexes;
//        SCPoint* vertex = [triangleVertexes objectAtIndex:j];
//        CGContextFillEllipseInRect(context, CGRectMake(vertex.x-5.0f, vertex.y-5.0f, 10, 10));
//    }
}

@end
