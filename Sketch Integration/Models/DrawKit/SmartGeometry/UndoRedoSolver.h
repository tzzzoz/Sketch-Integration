//
//  UndoRedoSolver.h
//  Sketch Integration
//
//  Created by kwan terry on 12-5-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gunit.h"
#import "SCGraph.h"
#import "SCPointGraph.h"
#import "SCTriangleGraph.h"
#import "SCCurveGraph.h"

@interface UndoRedoSolver : NSObject
{
    int pos;
    int times;
    NSMutableArray* backPos;
    NSMutableArray* saveNumbers;
}

-(void)updatePosWithGraphList:(NSMutableArray*)graphList;
-(void)undoWithGraphList:(NSMutableArray*)graphList;
-(void)redoWithGraphList:(NSMutableArray*)graphList;
-(void)clearObjectivesWithGrpahList:(NSMutableArray*)graphList PointList:(NSMutableArray*)pointList UnitList:(NSMutableArray*)unitList;

-(void)eraseGraphList:(NSMutableArray*)graphList UnitList:(NSMutableArray*)unitList;
-(void)erasePointGraph:(NSMutableArray*)pointList;

@end
