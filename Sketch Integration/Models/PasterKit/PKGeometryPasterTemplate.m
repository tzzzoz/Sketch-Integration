//
//  PKGeometryPasterTemplate.m
//  Sketch
//
//  Created by 付 乙荷 on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKGeometryPasterTemplate.h"

@implementation PKGeometryPasterTemplate

@synthesize geoTemplateImageView;
@synthesize geoTemplateColor;
@synthesize geoTemplateType;
@synthesize isModified;

-(id)initWithFileName:(NSString *)fileName Color:(UIColor *)color Type:(GeometryType)type Rect:(CGRect)rect
{
    //判断父类初始化成功 且 文件路径有效
    if (self = [super init]) 
    {
        self.geoTemplateImageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:fileName]] autorelease];
        self.geoTemplateColor = color;
        self.geoTemplateType  = type;
    }
    return self;
}

-(id)initWithFileName:(NSString *)fileName Type:(GeometryType)type Rect:(CGRect)rect
{
    //判断父类初始化成功 且 文件路径有效
    if (self = [super init]) 
    {
        self.geoTemplateImageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:fileName]] autorelease];
        self.geoTemplateType  = type;
        self.geoTemplateImageView.frame = rect;
    }
    return self;
}

//使用NSCoder对几何贴纸模板进行归档
-(id)initWithCoder:(NSCoder *)aDecoder 
{
    if (self = [super init]) 
    {
        self.geoTemplateImageView = [aDecoder decodeObjectForKey:@"geoTemplateImageView"];
        self.geoTemplateColor = [aDecoder decodeObjectForKey:@"geoTemplateColor"];
        self.geoTemplateType  = [aDecoder decodeIntForKey:@"geoTemplateType"];
        self.isModified = [aDecoder decodeBoolForKey:@"isModified"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder 
{
    [aCoder encodeObject:geoTemplateImageView forKey:@"geoTemplateImageView"];
    [aCoder encodeObject:geoTemplateColor forKey:@"geoTemplateColor"];
    [aCoder encodeInt:geoTemplateType forKey:@"geoTemplateType"];
    [aCoder encodeBool:isModified forKey:@"isModified"];
}

@end