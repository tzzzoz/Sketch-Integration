//
//  PKGeometryPaster.m
//  Sketch
//
//  Created by 付 乙荷 on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKGeometryPaster.h"

@implementation PKGeometryPaster

@synthesize geoPasterImageView;
@synthesize geoPasterColor;
@synthesize geoPasterType;

-(id)initWithGeometryPasterTemplate:(PKGeometryPasterTemplate *)geometryPasterTemplate Color:(UIColor *)color Type:(GeometryType)type
{
    self = [super init];
    if (self && color) 
    {
        self.geoPasterImageView = [[PKGeometryImageView alloc]initWithImage:geometryPasterTemplate.geoTemplateImageView.image];
        self.geoPasterColor = color;
        self.geoPasterType  = type;
        return self;
    } 
    else 
    {
        //参数color为空，异常处理
        return nil;
    }
}

-(id)initWithGeometryImageView:(PKGeometryImageView *)imageView Color:(UIColor *)color Type:(GeometryType)type
{
    self = [super init];
    if(self && color && imageView)
    {
        self.geoPasterImageView = imageView;
        self.geoPasterColor = color;
        self.geoPasterType  = type;
        return self;
    }
    else
    {
        //参数color为空，异常处理
        return nil; 
    }
}


//使用NSCoder对几何贴纸进行归档
-(id)initWithCoder:(NSCoder *)aDecoder 
{
    if (self = [super init]) 
    {
        self.geoPasterImageView = [aDecoder decodeObjectForKey:@"geoPasterImageView"];
        self.geoPasterColor = [aDecoder decodeObjectForKey:@"geoPasterColor"];
        self.geoPasterType = [aDecoder decodeIntForKey:@"geoPasterType"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder 
{
    [aCoder encodeObject:geoPasterImageView forKey:@"geoPasterImageView"];
    [aCoder encodeObject:geoPasterColor forKey:@"geoPasterColor"];
    [aCoder encodeInt:geoPasterType forKey:@"geoPasterType"];
}
@end
