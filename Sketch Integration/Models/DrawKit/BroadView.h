//
//  BroadView.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "UnitFactory.h"
//#import "Constraint.h"
//#import "ConstraintGraph.h"
//#import "Threshold.h"

@interface BroadView : UIView
{
    //笔画数组和删除笔画数组
    NSMutableArray* arrayStrokes;
    NSMutableArray* arrayAbandonedStrokes;
    
//    画笔颜色与尺寸
    UIColor* currentColor;
    float    currentSize;
    
//    图形列表尺寸
    int graphListSize;
//    
//    UIButton* undoButton;
//    UIButton* redoButton;
//    UIButton* deletButton;
    
//    图元列表，图形列表，新图形列表，点图形列表，保存图形列表
    NSMutableArray* unitList;
    NSMutableArray* graphList;
    NSMutableArray* newGraphList;
    NSMutableArray* pointGraphList;
    NSMutableArray* saveGraphList;

    CGContextRef context;
//    UnitFactory* factory;
    
//    已经画的，图形图
    Boolean hasDrawed;
    UIImageView* graphImageView;
    
//    前面的点1,前面的点2,当前点
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGPoint currentPoint;
    
//    当前图，最后图
    UIImage* currentImage;
    UIImage* lastImage;
    
//    拥有者
    id owner;
}

@property (retain)      NSMutableArray* arrayStrokes;
@property (retain)      NSMutableArray* arrayAbandonedStrokes;

@property (retain)      UIColor*        currentColor;
@property (readwrite)   float           currentSize;

@property (retain)      UIImage*        currentImage;
@property (retain)      UIImage*        lastImage;

@property (readwrite)   int             graphListSize;

//@property (retain)      UIButton*       undoButton;
//@property (retain)      UIButton*       redoButton;
//@property (retain)      UIButton*       deleteButton;

@property (retain)      NSMutableArray*     unitList;
@property (retain)      NSMutableArray*     graphList;
@property (retain)      NSMutableArray*     newGraphList;
@property (retain)      NSMutableArray*     pointGraphList;
@property (retain)      NSMutableArray*     saveGraphList;

@property (readwrite)   CGContextRef        context;
//@property (retain)      UnitFactory*        factory;
@property (assign)      id                  owner;
@property (readwrite)   Boolean             hasDrawed;
@property (retain)      UIImageView*        graphImageView;

-(void) viewJustLoaded;
-(void) undoFunc;
-(void) redoFunc;
-(void) deleteFunc;
//-(void) deleteFunc:(id)sender;
@end
