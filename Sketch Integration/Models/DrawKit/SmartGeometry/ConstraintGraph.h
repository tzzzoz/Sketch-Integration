//
//  ConstraintGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCGraph.h"
#import "Gunit.h"

@class SCGraph;
@interface ConstraintGraph : NSObject
{
    SCGraph* graph1;
    SCGraph* graph2;
    ConstraintType constraintType;
}

@property (readwrite) ConstraintType   constraintType;
@property (retain)    SCGraph*         graph1;
@property (retain)    SCGraph*         graph2;

@end
