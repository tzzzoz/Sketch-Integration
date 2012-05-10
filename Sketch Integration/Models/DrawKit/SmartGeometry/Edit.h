//
//  Edit.h
//  SmartGeometry
//
//  Created by kwan terry on 12-2-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCGraph.h"
#import "SCPointGraph.h"
#import "SCLineGraph.h"
#import "SCCurveGraph.h"
#import "SCTriangleGraph.h"
#import "SCRectangleGraph.h"
#import "Gunit.h"
#import "Constraint.h"
#import "Threshold.h"

typedef enum
{
    EditMode = 1,
    StretchMode = 2,
    RotationMode = 3,
    ScaleMode = 4,
    BeginEditMode = 5,
    CancleEditMode = 6
}EditParameter;

struct GraphStruct
{
    SCGraph* graph;
    
    //若是点只用0,线用(start)0,(end)1,三角形用012,四边形用0123
    //圆(center)0,(move)1
    NSMutableArray* pointList;
    
    float originalMajor,originalMinor;
    float originalAlpha;
    float startAngle,endAngle;
    bool isCompleteCurve;
};

struct GraphVectorStruct 
{
    NSMutableArray* recordGraphVector;
    NSMutableArray* selectedList;
    
    bool isInEdit;
    bool isInEditTemp;
    bool isSelected;
    bool promitBackOrForward;
};

@interface Edit : NSObject
{
    bool* editParameters;
    //0是进人编辑态;1是移动move;2是改变形状stretch;3是旋转rotation;4是缩放scale;
    //5是进入真正编辑的开始那瞬间;6是取消编辑态后不画出点（但要画出其他图形）;
    
    NSMutableArray* stretchGraphList;
    
    int whichLineRectangle;
    
    //三帧
    NSMutableArray* recordOperationVector1;
    NSMutableArray* recordOperationVector2;
    NSMutableArray* recordOperationVector3;
    NSMutableArray* recordOperationVectorTemp;
    
    int position;
    int positionTemp;
    int position1;
    int positionTemp1;
    int position2;
    int positionTemp2;
    int position3;
    int positionTemp3;
    int inWhichFrame;
    
}

@property (readwrite) int whichLineRectangle;
@property (readwrite) int inWhichFrame;
@property (readwrite) int position;
@property (readwrite) int positionTemp;
@property (readwrite) int position1;
@property (readwrite) int positionTemp1;
@property (readwrite) int position2;
@property (readwrite) int positionTemp2;
@property (readwrite) int position3;
@property (readwrite) int positionTemp3;
@property (readwrite) bool* editParameters;

@property (retain) NSMutableArray* stretchGraphList;
@property (retain) NSMutableArray* recordOperationVector1;
@property (retain) NSMutableArray* recordOperationVector2;
@property (retain) NSMutableArray* recordOperationVector3;
@property (retain) NSMutableArray* recordOperationVectorTemp;

//scanscanGraphs把所有有约束的图形一起亚进去
-(void)scanSelectedList:(NSMutableArray *)selectedList;
//willEdit是scanGraphs完事后再搓下一点判断时候编辑
-(Boolean)willEditWithPoint:(SCPoint*)point GraphList:(NSMutableArray*)graphList;
//判断是要进入编辑或者推出编辑
-(void)willOrOutOfEditWithPoint:(SCPoint*)point selectedGraphList:(NSMutableArray*)selectedGraphList  tempGraphList:(NSMutableArray*)tempGraphList;
//清除所有编辑态
-(void)clearEditParametersWithPosition:(int)position Size:(int)size;
//在撤销或者还原后清除编辑态
-(void)clearAllAfterUndoOrRedoWithSelectedGraphList:(NSMutableArray*)selectedGraphList;
//搜索约束关系
-(void)searchConstraintWithGraph:(SCGraph*)graph SelectedList:(NSMutableArray*)selectedList;

//判断是moveMode或者stretchMode的编辑态
-(void)isMoveOrStretchWithPoint1:(SCPoint *)point1 SelectedList:(NSMutableArray *)selectedList;
-(void)selectedMoveOrStretchWithPrePoint:(SCPoint *)prePoint LastPoint:(SCPoint *)lastPoint SelectedList:(NSMutableArray *)selectedList;
//把状态设置为selected
-(void)setSelectedStateWithSelectedList:(NSMutableArray*)selectedList;
//移动所有选中的图形
-(void)selectedGraphListMove:(SCPoint *)move SelectedList:(NSMutableArray *)selectedList;
//返回旋转的中心点
-(SCPoint*)returnRotationCenterWithGraph:(SCGraph*)graph;
//旋转所有选中的图形
-(void)selectedGraphListRotationWithAngle:(float)angle SelectedList:(NSMutableArray*)selectedList;
//缩放所有选中的图形
-(void)selectedGraphListScaleWithScaleFactor:(float)scaleFactor GraphList:(NSMutableArray*)graphList;

-(void)setGraphOriginalWithGraphList:(NSMutableArray*)graphList;

//记录编辑操作
-(void)recordEditOperation1WithSelectedList:(NSMutableArray*)selectedList IsSelected:(Boolean)isSelected;
-(void)recordEditOperation2WithSelectedList:(NSMutableArray *)selectedList IsSelected:(Boolean)isSelected;
-(void)backOperationWithGraphList:(NSMutableArray*)graphList;
-(void)forwardOperationWithGraphList:(NSMutableArray*)graphList;
-(void)eraseOpertaion1;
-(void)eraseOpertaion2;
-(void)assignRecordOperationVectorAndPositionTemp;
-(void)assignPosition123;
-(void)clearErase;
-(void)clear;

@end
