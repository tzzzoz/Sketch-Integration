//
//  Gunit.h
//  Dudel
//
//  Created by tzzzoz on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPoint.h"

@protocol GunitInterface <NSObject>
    
@end

typedef enum
{
    Vertex_Of_Line = 0,     //点在直线上（点为直线的段点）
    Point_On_Line,          //点在直线上（非端点的约束）
    Point_On_Circle,        //点在圆弧上
    Belong_To_Triangle,     //一条直线属于某个三角形
    
    MidPoint,//点是线的中点
    Angular_Bisector,//角平分线
    Tangency,//线与圆相切
    Intercoss,//线与圆相割
    Vertical_Line,//垂线
    MidLine,//中线
    Median_Of_Triangle,//中位线
    Diagonal_Line,//对角线
    Internally_Tangent,//内切
    Externally_Tangent,//外切
    Inscribe,//内切
    Diameter,//直径
    Radius,//半径
    Chords,//弦
    Joined,
    
    Vertex0_Of_Triangle,
    Vertex1_Of_Triangle,
    Vertex2_Of_Triangle,
    
    Vertex0_Of_Rectangle,
    Vertex1_Of_Rectangle,
    Vertex2_Of_Rectangle,
    Vertex3_Of_Rectangle,
    
    Point_On_Triangle_Line0,
    Point_On_Triangle_Line1,
    Point_On_Triangle_Line2,
    
    Point_On_Rectangle_Line0,
    Point_On_Rectangle_Line1,
    Point_On_Rectangle_Line2,
    Point_On_Rectangle_Line3,
    
    Start_Vertex_Of_Line,
    End_Vertex_Of_Line,
    Start_Vertex_Of_Curve,
    End_Vertex_Of_Curve
    
}ConstraintType;

typedef enum
{
    Point_Graph = 0,
    Line_Graph,
    Curver_Graph,
    Triangle_Graph,
    Rectangle_Graph,
    Other_Graph
}GraphType;

@interface Gunit : NSObject {

    SCPoint *start,*end;        // 每 个 图 元 都 具 有 一 个 起 点 和 一 个 终 点
    int type;               // 表 示 是 什 么 类 型 的 图 元
    int id;
    bool isSelected;
    bool already_D;
}

@property (retain,nonatomic) SCPoint *start;
@property (retain,nonatomic) SCPoint *end;
@property (readwrite)        int     type;
@property (readwrite)        bool    isSelected;

-(id) initWithStartPoint:(SCPoint*) s endPoint:(SCPoint*) e;
-(id) initWithPoints:(NSMutableArray*) points;
-(void) drawWithContext:(CGContextRef)context;
@end