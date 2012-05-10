//
//  UnitFactory.h
//  Dudel
//
//  Created by tzzzoz on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Threshold.h"
#import "PenInfo.h"
#import "Stroke.h"

#import "SCPoint.h"

#import "Gunit.h"
#import "PointUnit.h"
#import "LineUnit.h"
#import "CurveUnit.h"

#import "SCGraph.h"
#import "SCPointGraph.h"
#import "SCLineGraph.h"
#import "SCTriangleGraph.h"
#import "SCRectangleGraph.h"
#import "SCCurveGraph.h"

@interface UnitFactory : NSObject 
{
    Stroke* strokeTotal;
}

@property (retain) Stroke* strokeTotal;

-(void)createWithPoint:(NSMutableArray *)pList Unit:(NSMutableArray *)unitList Graph:(NSMutableArray *)graphList PointGraph:(NSMutableArray *)pointGraphList NewGraph:(NSMutableArray *)newGraphList;
-(Gunit *) first_units_recognize:(NSMutableArray *) pList;
-(SCGraph *) bind_unit_to_graphs:(Gunit *) unit :(NSMutableArray *)unitList;
-(SCGraph *) create_Line_Graph:(Stroke *) stroke :(NSMutableArray *)unitList :(NSMutableArray*) pointGraphList;
-(SCGraph *) create_Triangle_Graph:(Stroke *)stroke :(NSMutableArray *)unitList :(NSMutableArray *)pointGraphList;
-(SCGraph*) create_Rectangle_Graph:(Stroke*)stroke :(NSMutableArray*)unitList :(NSMutableArray*)pointList;
-(void) push_back_new_graph:(SCGraph*) graph :(NSMutableArray *) graphList :(NSMutableArray *) pointGraphList :newGraphList;

@end
