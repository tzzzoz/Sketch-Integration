//
//  PKGeometryImageView.h
//  Sketch
//
//  Created by 付 乙荷 on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumClass.h"
#import "UIImageView+DeepCopy.h"

//这个类提供了编辑贴纸相关操作所需要的数据

@interface PKGeometryImageView : UIImageView <NSCoding>
{
    //贴纸是否被选中
    BOOL isGeometrySelected;
    
    //关键操作点
    CGPoint leftTopPoint;
    CGPoint rightTopPoint; 
    CGPoint leftBottomPoint; 
    CGPoint rightBottomPoint;
    CGPoint rotationPoint;
    CGPoint centerPoint;
    
    CGAffineTransform geometryTransfrom;
    OperationType operationType;
    
    //关键操作点原来的点
    CGPoint leftTopPointOriginal;
    CGPoint rightTopPointOriginal;
    CGPoint leftBottomPointOriginal;
    CGPoint rigthBottomPointOriginal;
    CGPoint centerPointOriginal;
}

@property (readwrite) BOOL isGeometrySelected;
@property (readwrite) CGPoint leftTopPoint;
@property (readwrite) CGPoint rightTopPoint;
@property (readwrite) CGPoint leftBottomPoint;
@property (readwrite) CGPoint rightBottomPoint;
@property (readwrite) CGPoint rotationPoint;
@property (readwrite) CGPoint centerPoint;
@property (readwrite) CGPoint leftTopPointOriginal;
@property (readwrite) CGPoint rightTopPointOriginal;
@property (readwrite) CGPoint leftBottomPointOriginal;
@property (readwrite) CGPoint rigthBottomPointOriginal;
@property (readwrite) CGPoint centerPointOriginal;
@property (readwrite) CGAffineTransform geometryTransfrom;
@property (readwrite) OperationType operationType;

-(void)drawFrameWithContext:(CGContextRef)context;
-(void)calulateFourCorners;
-(void)initFourCorners;

@end
