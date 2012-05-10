//
//  UndoRedoSolver.m
//  Sketch Integration
//
//  Created by kwan terry on 12-5-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UndoRedoSolver.h"

@implementation UndoRedoSolver

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        pos = -1;
        times = 0;
        backPos = [[NSMutableArray alloc]init];
        saveNumbers = [[NSMutableArray alloc]init];
    }
    
    return self;
}

-(void)updatePosWithGraphList:(NSMutableArray *)graphList
{
    pos = -1;
    [saveNumbers removeAllObjects];
    for(int i=0; i!=graphList.count; i++)
    {
        SCGraph* graph = [graphList objectAtIndex:i];
        if(graph.isDraw)
        {
            pos++;
            NSNumber* num = [[NSNumber alloc]initWithInt:i];
            [saveNumbers addObject:num];
        }
    }
}

-(void)undoWithGraphList:(NSMutableArray *)graphList
{
    [self updatePosWithGraphList:graphList];
    
    if(pos == -1)return;
    if([[graphList objectAtIndex:0]isDraw])
        times--;
    
    NSNumber* num = [saveNumbers lastObject];
    int backIndex = [num intValue];
    [backPos addObject:[[NSNumber alloc]initWithInt:backIndex]];
    
    //把pos指向的graph和其相关的point_graph的isDraw属性设为false
    SCGraph* graphTemp = [graphList objectAtIndex:backIndex];
    graphTemp.isDraw = NO;
    for(int i=0; i!=graphTemp.constraintList.count; i++)
    {
        SCGraph* relatedGraph = [[graphTemp.constraintList objectAtIndex:i]relatedGraph];
        if([relatedGraph isKindOfClass:[SCPointGraph class]])
        {
            SCPointGraph* pointTemp = (SCPointGraph*)relatedGraph;
            if([pointTemp isUndo])
            {
                pointTemp.isDraw = NO;
            }
//            pointTemp = NULL;
        }
    }
}

-(void)redoWithGraphList:(NSMutableArray *)graphList
{
    if(!backPos.count)return;
    if([[graphList lastObject]isDraw] == NO)
    {
        times++;
    }
    NSNumber* num = [backPos lastObject];
    int backIndex = [num intValue];
    [backPos removeLastObject];
    
    //把backPos指向的graph和其相关的point_graph的isDraw属性设为true
    SCGraph* graphTemp = [graphList objectAtIndex:backIndex];
    graphTemp.isDraw = YES;
    for(int i=0; i!=graphTemp.constraintList.count; i++)
    {
        SCGraph* relatedGraph = [[graphTemp.constraintList objectAtIndex:i]relatedGraph];
        if([relatedGraph isKindOfClass:[SCPointGraph class]])
        {
            SCPointGraph* pointTemp = (SCPointGraph*)relatedGraph;
            if([pointTemp isRedo])
            {
                pointTemp.isDraw = YES;
            }
//            pointTemp = NULL;
        }
    }
    
}

-(void)clearObjectivesWithGrpahList:(NSMutableArray *)graphList PointList:(NSMutableArray *)pointList UnitList:(NSMutableArray *)unitList
{
    [backPos removeAllObjects];
    [saveNumbers removeAllObjects];
    [self erasePointGraph:pointList];
    [self eraseGraphList:graphList UnitList:unitList];
}

-(void)erasePointGraph:(NSMutableArray *)pointList
{
    for(int i=0; i<pointList.count; i++)
    {
        SCPointGraph* pointTemp = [pointList objectAtIndex:i];
        if(!pointTemp.isDraw)
        {
            for(int j=0; j<pointTemp.constraintList.count; j++)
            {
                SCGraph* relatedGraphTemp = [[pointTemp.constraintList objectAtIndex:j]relatedGraph];
                for(int k=0; k<relatedGraphTemp.constraintList.count; k++)
                {
                    SCGraph* relatedGraph = [[relatedGraphTemp.constraintList objectAtIndex:k]relatedGraph];
                    if(relatedGraph == pointTemp)
                    {
                        [relatedGraphTemp.constraintList removeObject:k];
                        k--;
                    }
                }
                [pointTemp.constraintList removeObject:j];
            }
            [pointList removeObject:pointTemp];
            i--;
        }
    }
}

-(void)eraseGraphList:(NSMutableArray *)graphList UnitList:(NSMutableArray *)unitList
{
    for(int i=0; i<graphList.count; i++)
    {
        SCGraph* graphTemp = [graphList objectAtIndex:i];
        if(!graphTemp.isDraw)
        {
            
        }
    }
}

@end
