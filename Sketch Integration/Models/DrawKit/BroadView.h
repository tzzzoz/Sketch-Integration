//
//  BroadView.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UnitFactory.h"
//#import "Constraint.h"
//#import "ConstraintGraph.h"
//#import "Threshold.h"

@interface BroadView : UIView
{
    NSMutableArray* arrayStrokes;
    NSMutableArray* arrayAbandonedStrokes;
    
    UIColor* currentColor;
    float    currentSize;
    
    int graphListSize;
    
    UIButton* undoButton;
    UIButton* redoButton;
    UIButton* deletButton;
    
    NSMutableArray* unitList;
    NSMutableArray* graphList;
    NSMutableArray* newGraphList;
    NSMutableArray* pointGraphList;
    NSMutableArray* saveGraphList;
    
    CGContextRef context;
//    UnitFactory* factory;
    Boolean hasDrawed;
    UIImageView* graphImageView;
    
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGPoint currentPoint;
    
    UIImage* currentImage;
    UIImage* lastImage;
    
    id owner;
}

@property (retain)      NSMutableArray* arrayStrokes;
@property (retain)      NSMutableArray* arrayAbandonedStrokes;

@property (retain)      UIColor*        currentColor;
@property (readwrite)   float           currentSize;

@property (retain)      UIImage*        currentImage;
@property (retain)      UIImage*        lastImage;

@property (readwrite)   int             graphListSize;

@property (retain)      UIButton*       undoButton;
@property (retain)      UIButton*       redoButton;
@property (retain)      UIButton*       deleteButton;

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
-(void) undoFunc:(id)sender;
-(void) redoFunc:(id)sender;
-(void) deleteFunc:(id)sender;
@end
