//
//  PKGeometryPaster.h
//  Sketch
//
//  Created by 付 乙荷 on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "PKGeometryPasterTemplate.h"
#import "PKGeometryImageView.h"
#import "UIColor+DeepCopy.h"

//实现了NSCoding的协议，该类可以Archive到本地
@interface PKGeometryPaster : NSObject <NSCoding,NSCopying> 
{
    PKGeometryImageView *geoPasterImageView;     //这个view中保存了编辑等操作需要的数据
    UIColor *geoPasterColor;                     //几何贴纸的填充颜色
    GeometryType geoPasterType;                  //几何贴纸的类型
    BOOL isModified;
}

//几何贴纸的创建依赖其对应的几何贴纸模板，存在依赖关系
//使用相应的几何贴纸模板来初始化几何贴纸
//-(id)initWithGeometryPasterTemplate:(PKGeometryPasterTemplate*)geometryPasterTemplate Color:(UIColor*) color;
-(id)initWithGeometryImageView:(PKGeometryImageView *)imageView;
-(id)initWithGeometryPasterTemplate:(PKGeometryPasterTemplate*)geometryPasterTemplate;

@property (retain, nonatomic) PKGeometryImageView *geoPasterImageView;
@property (retain, nonatomic) UIColor *geoPasterColor;
@property (assign, nonatomic) GeometryType geoPasterType;
@property (readwrite) BOOL isModified;

@end
