//
//  Edit.m
//  SmartGeometry
//
//  Created by kwan terry on 12-2-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Edit.h"

@implementation Edit

@synthesize whichLineRectangle,inWhichFrame;
@synthesize position,position1,position2,position3,positionTemp,positionTemp1,positionTemp2,positionTemp3;
@synthesize editParameters,stretchGraphList,recordOperationVector1,recordOperationVector2,recordOperationVector3,recordOperationVectorTemp;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        bool editMode[7];
        editParameters = editMode;
        position1 = 0;
        position2 = 0;
        position3 = 0;
        positionTemp1 = 0;
        positionTemp2 = 0;
        positionTemp3 = 0;
        inWhichFrame = 1;
        whichLineRectangle = -1;
        [self clearEditParametersWithPosition:0 Size:7];
    }
    
    return self;
}

-(void)dealloc
{
    positionTemp1 = -1;
    inWhichFrame = 1;
    [self eraseOpertaion2];
    positionTemp2 = -1;
    inWhichFrame = 2;
    [self eraseOpertaion2];
    positionTemp3 = 1;
    inWhichFrame = 3;
    [self eraseOpertaion2];
    [recordOperationVector1 removeAllObjects];
    [recordOperationVector2 removeAllObjects];
    [recordOperationVector3 removeAllObjects];
}

-(void)clearEditParametersWithPosition:(int)positionLocal Size:(int)size
{
    for(int i=positionLocal; i<=size; i++)
    {
        editParameters[i] = NO;
    }
}

-(void)scanSelectedList:(NSMutableArray *)selectedList
{
    if([selectedList count] == 0)
        return;
    editParameters[0] = YES;
    editParameters[6] = YES;
    SCGraph* graphTemp = [selectedList objectAtIndex:0];
    [graphTemp setIsSelected:YES];
    
    [self searchConstraintWithGraph:graphTemp SelectedList:selectedList];
}

-(void)searchConstraintWithGraph:(SCGraph *)graph SelectedList:(NSMutableArray *)selectedList
{
    for(int i=0; i<[graph.constraintList count]; i++)
    {
        Constraint* constraint = [graph.constraintList objectAtIndex:i];
        if(!constraint.relatedGraph.isSelected)
        {
            [constraint.relatedGraph setIsSelected:YES];
            [selectedList addObject:constraint.relatedGraph];
            [self searchConstraintWithGraph:constraint.relatedGraph SelectedList:selectedList];
        }
    }
}

//在touchbegin调用
//三条直线交于一点时限制(只是例子)
-(void)isMoveOrStretchWithPoint1:(SCPoint *)point1 SelectedList:(NSMutableArray *)selectedList;
{
    SCPoint* p = [[SCPoint alloc]initWithX:point1.x andY:point1.y];
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graphTemp = [selectedList objectAtIndex:i];
        if([graphTemp isKindOfClass:[SCCurveGraph class]])
        {
            SCCurveGraph* curveGraphTemp = (SCCurveGraph*)graphTemp;
            [curveGraphTemp.curveUnit antiTranslateWith:p Theta:curveGraphTemp.curveUnit.alpha Point:curveGraphTemp.curveUnit.move];
            if([Threshold Distance:p :curveGraphTemp.curveUnit.end] < IS_SELECT_POINT)
            {
                [stretchGraphList addObject:curveGraphTemp];
                editParameters[2] = YES;
                return;
            }
        }
    }
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graphTemp = [selectedList objectAtIndex:i];
        if([graphTemp isKindOfClass:[SCPointGraph class]])
        {
            SCPointGraph* pointGraphTemp = (SCPointGraph*)graphTemp;
            if(pointGraphTemp.freedomType > 2)
            {
                editParameters[1] = true;
                return;
            }
        }
    }
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graphTemp = [selectedList objectAtIndex:i];
        if([graphTemp isKindOfClass:[SCPointGraph class]])
        {
            SCPointGraph* pointGraphTemp = (SCPointGraph*)graphTemp;
            bool isStretchCutLine = NO;
            for(int i=0; i<[pointGraphTemp.constraintList count]; i++)
            {
                Constraint* constraint = [pointGraphTemp.constraintList objectAtIndex:i];
                if([constraint.relatedGraph isKindOfClass:[SCLineGraph class]])
                {
                    SCLineGraph* lineGraphTemp = (SCLineGraph*)constraint.relatedGraph;
                    if(lineGraphTemp.lineUnit.isCutLine)
                    {
                        isStretchCutLine = YES;
                    }
                }
            }
            if(isStretchCutLine)
                continue;
            if(pointGraphTemp.freedomType < 2)
            {
                float distance = [Threshold Distance:pointGraphTemp.pointUnit.start :[[SCPoint alloc]initWithX:p.x andY:p.y]];
                if(distance < IS_SELECT_POINT)
                {
                    editParameters[2] = true;
                    [stretchGraphList addObject:pointGraphTemp];
                    return;
                }
            }
        }
    }
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graphTemp = [selectedList objectAtIndex:i];
        if([graphTemp isKindOfClass:[SCRectangleGraph class]])
        {
            SCRectangleGraph* rectangleGraph = (SCRectangleGraph*)graphTemp;
            float distanceTemp = 0.0;
            for(int i=0; i<4; i++)
            {
                LineUnit* line = [rectangleGraph.rec_lines objectAtIndex:i];
                distanceTemp += [Threshold Distance:line.start :line.end]*[Threshold pointToLIne:[[SCPoint alloc]initWithX:p.x andY:p.y] :line];
            }
            SCPoint* vertex0 = [rectangleGraph.rec_vertexes objectAtIndex:0];
            SCPoint* vertex1 = [rectangleGraph.rec_vertexes objectAtIndex:1];
            SCPoint* vertex2 = [rectangleGraph.rec_vertexes objectAtIndex:2];
            SCPoint* vertex3 = [rectangleGraph.rec_vertexes objectAtIndex:3];
            LineUnit* line = [[LineUnit alloc]initWithStartPoint:vertex0 endPoint:vertex2];
            float s = [Threshold Distance:vertex0 :vertex2]*[Threshold pointToLIne:vertex1 :line]
                    + [Threshold Distance:vertex0 :vertex2]*[Threshold pointToLIne:vertex3 :line];
            [line release];
            line = NULL;
            if(distanceTemp/s < 1.2)
            {
                for(int i=0; i<4; i++)
                {
                    LineUnit* line = [rectangleGraph.rec_lines objectAtIndex:i];
                    if([Threshold pointToLIne:[[SCPoint alloc]initWithX:p.x andY:p.y] :line] < IS_SELECT_LINE)
                    {
                        [stretchGraphList addObject:rectangleGraph];
                        whichLineRectangle = i;
                        editParameters[2] = YES;
                        return;
                    }
                }
            }
            
        }
    }
    if(!editParameters[2])
    {
        editParameters[1] = YES;
    }
}

//在touchmove调用
-(void)selectedMoveOrStretchWithPrePoint:(SCPoint *)prePoint LastPoint:(SCPoint *)lastPoint SelectedList:(NSMutableArray *)selectedList
{
    if(editParameters[1])
    {
        [self selectedGraphListMove:[[SCPoint alloc]initWithX:lastPoint.x-prePoint.x andY:lastPoint.y-prePoint.y] SelectedList:selectedList];
    }
    else if(editParameters[2])
    {
        for(int i=0; i<[stretchGraphList count]; i++)
        {
            SCGraph* graphTemp = [stretchGraphList objectAtIndex:i];
            if([graphTemp isKindOfClass:[SCPointGraph class]])
            {
                SCPointGraph* pointGraph = (SCPointGraph*)graphTemp;
                if(pointGraph.vertexOfSpecialLine == NO && pointGraph.vertexOfCurveCenter == NO)
                {
                    SCPoint* pointTemp = [[SCPoint alloc]initWithX:prePoint.x andY:prePoint.y];
                    [pointGraph setPoint:pointTemp];
                    [pointGraph keepConstraintWithPoint:pointTemp]; 
                }
            }
            else if([graphTemp isKindOfClass:[SCTriangleGraph class]])
            {
                SCTriangleGraph* triangleGraph = (SCTriangleGraph*)graphTemp;
                [triangleGraph followPointGraph];
                [triangleGraph keepConstraintWithGraph:NULL];
                [triangleGraph updateRelatedValues];
                triangleGraph.triangleType = OridinaryTriangle;
                break;
            }
            else if([graphTemp isKindOfClass:[SCRectangleGraph class]])
            {
                SCRectangleGraph* rectangleGraph = (SCRectangleGraph*)graphTemp;
                if(whichLineRectangle == -1)
                    [rectangleGraph keepConstraint];
                else
                    [rectangleGraph stretchWithLineIndex:whichLineRectangle Point:[[SCPoint alloc]initWithX:lastPoint.x-prePoint.x andY:lastPoint.y-prePoint.y]];
                break;
            }
            else if([graphTemp isKindOfClass:[SCCurveGraph class]])
            {
                SCCurveGraph* curveGraph = (SCCurveGraph*)graphTemp;
                [curveGraph stretchWithPoint:lastPoint];
                break;
            }
            
        }
    }
}

-(void)setSelectedStateWithSelectedList:(NSMutableArray *)selectedList
{
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graph = [selectedList objectAtIndex:i];
        [graph setSelectedWithBool:NO];
    }
}

-(void)selectedGraphListMove:(SCPoint *)move SelectedList:(NSMutableArray *)selectedList
{
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graph = [selectedList objectAtIndex:i];
        [graph translationWithPoint:move];
    }
}

-(SCPoint*)returnRotationCenterWithGraph:(SCGraph *)graph
{
    if([graph isKindOfClass:[SCLineGraph class]])
    {
        SCLineGraph* lineGraphTemp = (SCLineGraph*)graph;
        return [[SCPoint alloc]initWithX:(lineGraphTemp.lineUnit.start.originalX + lineGraphTemp.lineUnit.end.originalX)/2 andY:(lineGraphTemp.lineUnit.start.originalY + lineGraphTemp.lineUnit.end.originalY)/2];  
    }
    else if([graph isKindOfClass:[SCCurveGraph class]])
    {
        SCCurveGraph* curveGraphTemp = (SCCurveGraph*)graph;
        return [[SCPoint alloc]initWithX:curveGraphTemp.curveUnit.center.originalX andY:curveGraphTemp.curveUnit.center.originalY];
    }
    else if([graph isKindOfClass:[SCTriangleGraph class]])
    {
        SCTriangleGraph* triangleGraphTemp = (SCTriangleGraph*)graph;
        SCPoint* temp = [[SCPoint alloc]initWithX:0 andY:0];
        for(int i=0; i<[triangleGraphTemp.triangleVertexes count]; i++)
        {
            SCPoint* vertexTemp = [triangleGraphTemp.triangleVertexes objectAtIndex:i]; 
            temp.x += (vertexTemp.x/3);
            temp.y += (vertexTemp.y/3);
        }
        return temp;
    }
    else if([graph isKindOfClass:[SCRectangleGraph class]])
    {
        SCRectangleGraph* rectangleGraphTemp = (SCRectangleGraph*)graph;
        return [rectangleGraphTemp calculateDiagonalIntersectionPoint];
    }
    else
    {
        return NULL;
    }
}

-(void)selectedGraphListRotationWithAngle:(float)angle SelectedList:(NSMutableArray *)selectedList
{
    int i = 0;
    SCGraph* graphTemp = [selectedList objectAtIndex:i];
    while ([graphTemp isKindOfClass:[SCPointGraph class]]) 
    {
        i++;
        graphTemp = [selectedList objectAtIndex:i];
    }
    bool whole = NO;
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graphTemp = [selectedList objectAtIndex:i];
        if([graphTemp isKindOfClass:[SCPointGraph class]])
        {
            SCPointGraph* pointGraphTemp = (SCPointGraph*)graphTemp;
            if(pointGraphTemp.freedomType > 2)
            {
                whole = YES;
            }
            for(int j=0; j<[pointGraphTemp.constraintList count]; j++)
            {
                Constraint* constraint = [pointGraphTemp.constraintList objectAtIndex:i];
                if([constraint.relatedGraph isKindOfClass:[SCLineGraph class]])
                {
                    SCLineGraph* lineGraphTemp = (SCLineGraph*)constraint.relatedGraph;
                    if(lineGraphTemp.lineUnit.isCutLine && (constraint.constraintType == Start_Vertex_Of_Line || constraint.constraintType == End_Vertex_Of_Line))
                    {
                        whole = YES;
                    }
                }
            }
        }
    }
    graphTemp = [selectedList objectAtIndex:i]; 
    SCPoint* rotationCenter = [self returnRotationCenterWithGraph:graphTemp];
    if(whole || ([graphTemp isKindOfClass:[SCLineGraph class]]))
    {
        for (SCGraph* graph in selectedList) 
        {
            [graph rotationWithAngle:angle Center:rotationCenter];
        }
    }
    else
    {
        if([graphTemp isKindOfClass:[SCCurveGraph class]])
        {
            SCCurveGraph* curveGraph = (SCCurveGraph*)graphTemp;
            curveGraph.curveUnit.alpha = curveGraph.curveUnit.originalAlpha - angle;
        }
        else if([graphTemp isKindOfClass:[SCTriangleGraph class]])
        {
            SCTriangleGraph* triangleGraph = (SCTriangleGraph*)graphTemp;
            SCPoint* pointTemp = [[SCPoint alloc]init];
            for(int i=0; i<[triangleGraph.triangleVertexes count]; i++)
            {
                SCPoint* vertexTemp = [triangleGraph.triangleVertexes objectAtIndex:i];
                [pointTemp setX:vertexTemp.originalX];
                [pointTemp setY:vertexTemp.originalY];
                vertexTemp = [triangleGraph calculatePointAfterRotationWithMove:rotationCenter Angle:angle Center:pointTemp];
                LineUnit* lineTemp = [triangleGraph.triangleLines objectAtIndex:i];
                if(lineTemp.isCutLine)
                {
                    [pointTemp setX:lineTemp.cutPoint.originalX];
                    [pointTemp setY:lineTemp.cutPoint.originalY];
                    lineTemp.cutPoint = [triangleGraph calculatePointAfterRotationWithMove:rotationCenter Angle:angle Center:pointTemp];
                }
            }
            
            [triangleGraph changeTriangleLines];
            [triangleGraph adjustPointGraph];
            [triangleGraph updateRelatedValues];
            [triangleGraph keepConstraintWithGraph:graphTemp Angle:angle RotationCenter:rotationCenter];
            for(Constraint* constraint in triangleGraph.constraintList)
            {
                if(constraint.constraintType == Vertex0_Of_Triangle || constraint.constraintType == Vertex2_Of_Triangle ||
                   constraint.constraintType == Vertex1_Of_Triangle)
                {
                    SCPointGraph* pointGraph = (SCPointGraph*)constraint.relatedGraph;
                    for(Constraint* constraint in pointGraph.constraintList)
                    {
                        if(constraint.constraintType == Point_On_Line)
                        {
                            SCLineGraph* lineGraph = (SCLineGraph*)constraint.relatedGraph;
                            [lineGraph rotationWithAngle:angle Center:rotationCenter];
                            [lineGraph adjustPointGraph];
                            [lineGraph keepConstraint];
                        }
                        if(constraint.constraintType == Point_On_Circle)
                        {
//                            SCCurveGraph* curveGraph
                        }
                    }
                }
            }
        }
    }

}

@end
