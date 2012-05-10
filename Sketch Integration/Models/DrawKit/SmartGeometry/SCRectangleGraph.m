//
//  SCRectangleGraph.m
//  SmartGeometry
//
//  Created by kwan terry on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCRectangleGraph.h"

@implementation SCRectangleGraph

@synthesize rec_lines,rec_vertexes;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        rec_lines = [[NSMutableArray alloc]init];
        rec_vertexes = [[NSMutableArray alloc]init];
        self.graphType = Rectangle_Graph;
    }
    
    return self;
}

-(id)initWithLine0:(LineUnit*)line0 Line1:(LineUnit*)line1 Line2:(LineUnit*)line2 Line3:(LineUnit*)line3 Id:(int)temp_local_id
{
    self = [super init];
    
    [super initWithId:temp_local_id];
    
    rectangleType = OrdinaryRectangleForGraph;
    rec_lines = [[NSMutableArray alloc]init];
    rec_vertexes = [[NSMutableArray alloc]init];
    
//    [rec_vertexes addObject:line0.start];
//    [rec_vertexes addObject:line1.start];
//    [rec_vertexes addObject:line2.start];
//    [rec_vertexes addObject:line3.start];
//    
//    LineUnit* l1 = [[LineUnit alloc]initWithStartPoint:line0.start endPoint:line1.start];
//    LineUnit* l2 = [[LineUnit alloc]initWithStartPoint:line1.start endPoint:line2.start];
//    LineUnit* l3 = [[LineUnit alloc]initWithStartPoint:line2.start endPoint:line3.start];
//    LineUnit* l4 = [[LineUnit alloc]initWithStartPoint:line3.start endPoint:line0.start];
    
//    [rec_lines addObject:l1];
//    [rec_lines addObject:l2];
//    [rec_lines addObject:l3];
//    [rec_lines addObject:l4];
    
    [self setLinePointsLine0:line0 Line1:line1 Line2:line2 Line3:line3];
    
    return self;
    
}

-(Boolean)is_not_connect:(LineUnit*)line1 :(LineUnit*)line2
{
    if(line1.start != line2.start && line1.start != line2.end && line1.end != line2.start && line1.end != line2.end)
        return YES;
    return NO;
}

-(Boolean)is_anticloclkwise:(SCPoint*)v0 :(SCPoint*)v1 :(SCPoint*)v2
{
    SCPoint* vec1 = [[SCPoint alloc]initWithX:(v0.x-v1.x) andY:(v0.y-v1.y)];
    SCPoint* vec2 = [[SCPoint alloc]initWithX:(v2.x-v1.x) andY:(v2.y-v1.y)];
    
    if((vec2.x*vec1.y - vec2.y*vec1.x)>=0)
        return YES;
    return NO;
}

-(void)setLinePointsLine0:(LineUnit*)line1 Line1:(LineUnit*)line2 Line2:(LineUnit*)line3 Line3:(LineUnit*)line4
{
    SCPoint* v0 = [[SCPoint alloc]initWithX:line1.start.x andY:line1.start.y];
    SCPoint* v1 = [[SCPoint alloc]initWithX:line1.end.x andY:line1.end.y];
    SCPoint* v2 = [[SCPoint alloc]initWithX:0.0f andY:0.0f];
    SCPoint* v3 = [[SCPoint alloc]initWithX:0.0f andY:0.0f];
    
    if([self is_not_connect:line1 :line2])
    {
        float k=(line2.start.y-v0.y)/(line2.start.x-v0.x);
        if((k/line3.k>k_equal_minimal&&k/line3.k<k_equal_max)||
           (k/line4.k>k_equal_minimal&&k/line4.k<k_equal_max))
        {
            v2=line2.end;
            v3=line3.start;
        }
        else
        {
            v2=line3.start;
            v3=line3.end;
        }
    }
    else if([self is_not_connect:line1 :line3])
    {
        float k=(line3.start.y-v0.y)/(line3.start.x-v0.x);
        if((k/line2.k>k_equal_minimal&&k/line2.k<k_equal_max)||
           (k/line4.k>k_equal_minimal&&k/line4.k<k_equal_max))
        {
            v2=line3.end;
            v3=line3.start;
        }
        else
        {
            v2=line3.start;
            v3=line3.end;
        }
    }
    else
    {
        float k=(line4.start.y-v0.y)/(line4.start.x-v0.x);
        if((k/line2.k>k_equal_minimal&&k/line2.k<k_equal_max)||
           (k/line3.k>k_equal_minimal&&k/line3.k<k_equal_max))
        {
            v2=line4.end;
            v3=line4.start;
        }
        else
        {
            v2=line4.start;
            v3=line4.end;
        }
    }
    if([self is_anticloclkwise:v0 :v1 :v2])
    {
        [rec_vertexes addObject:v3];
        [rec_vertexes addObject:v2];
        [rec_vertexes addObject:v1];
        [rec_vertexes addObject:v0];
    }
    else
    {
        [rec_vertexes addObject:v0];
        [rec_vertexes addObject:v1];
        [rec_vertexes addObject:v2];
        [rec_vertexes addObject:v3];
    }
    
    [line1 setstart:v0];
    [line1 setend:v1];
    [line2 setstart:v1];
    [line2 setend:v2];
    [line3 setstart:v2];
    [line3 setend:v3];
    [line4 setstart:v3];
    [line4 setend:v0];
    [rec_lines addObject:line1];
    [rec_lines addObject:line2];
    [rec_lines addObject:line3];
    [rec_lines addObject:line4];
}

-(void)drawWithContext:(CGContextRef)context
{
    //画四条边
    CGContextSetLineWidth(context, self.strokeSize);
    CGContextSetStrokeColorWithColor(context, self.graphColor);
    for(int i=0; i<4; i++)
    {
        LineUnit* line = [rec_lines objectAtIndex:i]; 
        [line drawWithContext:context];
    }

    //画四个顶点
//    for(int j=0; j<4; j++)
//    {
//        SCPoint* vertex = [rec_vertexes objectAtIndex:j];
//        CGContextFillEllipseInRect(context, CGRectMake(vertex.x-5.0f, vertex.y-5.0f, 10, 10));
//    }    
}

@end
