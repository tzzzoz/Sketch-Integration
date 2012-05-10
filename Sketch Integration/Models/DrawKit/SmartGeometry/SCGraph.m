//
//  SCGraph.m
//  SmartGeometry
//
//  Created by kwan terry on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "Constraint.h"
#import "ConstraintGraph.h"

@implementation SCGraph

@synthesize constraintList;
@synthesize local_graph_id;
@synthesize graphType;
@synthesize isDraw;
@synthesize isSelected;
@synthesize graphColor,strokeSize;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        isDraw = YES;
        isSelected = NO;
        constraintList = [[NSMutableArray alloc]init];
    }
    
    return self;
}

-(id)initWithId:(int)temp_local_graph_id
{
    [super init];
    
    local_graph_id = temp_local_graph_id;
    isDraw = YES;
    isSelected = NO;
    
    strokeSize = 5.0f;
    graphColor = [[UIColor blackColor]CGColor];
    
    return self;
}

-(id)initWithId:(int)temp_local_graph_id andType:(GraphType)graphType1
{
    [super init];
    
    self.local_graph_id = temp_local_graph_id;
    self.graphType      = graphType1;
    isDraw              = YES;
    isSelected          = NO;
    constraintList      = [[NSMutableArray alloc]init];
    
    strokeSize = 5.0f;
    graphColor = [[UIColor blackColor]CGColor];
    
    return self;
}

-(void)clearConstraint
{
    [constraintList removeAllObjects];
}

-(void)constructConstraintGraph1:(SCGraph *)graph1 Type1:(ConstraintType)type1 Graph2:(SCGraph *)graph2 Type2:(ConstraintType)type2
{
    Constraint* constraint1      = [[Constraint alloc]init];
    constraint1.constraintType   = type1;
    constraint1.related_graph_id = graph2.local_graph_id;
    constraint1.relatedGraph     = graph2;
    
    Constraint* constraint2 = [[Constraint alloc]init];
    constraint2.constraintType   = type2;
    constraint2.related_graph_id = graph1.local_graph_id;
    constraint2.relatedGraph     = graph1;
    
    [graph1.constraintList addObject:constraint1];
    [graph2.constraintList addObject:constraint2];
    
}

-(Boolean)recognizeConstraintWithGraph:(SCGraph *)graphTemp PointList:(NSMutableArray *)pointList
{
    return YES;
}

-(void)setGraphColorWithColorRef:(CGColorRef)colorRef
{
    graphColor = colorRef;
}

@end
