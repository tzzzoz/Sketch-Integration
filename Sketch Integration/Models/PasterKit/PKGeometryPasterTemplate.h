//
//  PKGeometryPasterTemplate.h
//  Sketch
//
//  Created by 付 乙荷 on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKGeometryImageView.h"
#import "EnumClass.h"

////实现了NSCoding的协议，该类可以Archive到本地
@interface PKGeometryPasterTemplate : NSObject <NSCoding> 
{
    UIImageView *geoTemplateImageView;          //保存几何贴纸的素材
    UIColor *geoTemplateColor;                  //几何贴纸模版的颜色
    GeometryType geoTemplateType;               //几何贴纸模版类型
    BOOL    isModified;
}

//使用图片路径对几何贴纸模板进行初始化
-(id)initWithFileName:(NSString *)fileName Color:(UIColor *)color Type:(GeometryType)type Rect:(CGRect) rect;
-(id)initWithFileName:(NSString *)fileName Type:(GeometryType)type Rect:(CGRect) rect;

@property (retain, nonatomic) UIImageView *geoTemplateImageView;
@property (retain) UIColor *geoTemplateColor;
@property (readwrite) GeometryType geoTemplateType;
@property (readwrite) BOOL isModified;
@end
