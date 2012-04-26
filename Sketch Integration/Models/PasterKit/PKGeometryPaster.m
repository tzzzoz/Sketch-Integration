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

//-(id)initWithGeometryPasterTemplate:(PKGeometryPasterTemplate *)geometryPasterTemplate Color:(UIColor *)color {
//    self = [super init];
//    if (self && color) 
//    {
//        geoPasterImageView = [[PKGeometryImageView alloc]initWithImage:geometryPasterTemplate.geoTemplateImageView.image];
//        self.geoPasterColor = color;
//        self.geoPasterType  = geometryPasterTemplate.geoTemplateType;
//    } 
//    return self;
//}
//
//-(id)initWithGeometryImageView:(PKGeometryImageView *)imageView Color:(UIColor *)color {
//    self = [super init];
//    if(self && color && imageView)
//    {
//        self.geoPasterImageView = imageView;
//        self.geoPasterColor = color;
//    }
//    return self;
//}

-(id)initWithGeometryPasterTemplate:(PKGeometryPasterTemplate *)geometryPasterTemplate {
    self = [super init];
    if (self) {
        self.geoPasterImageView = [[PKGeometryImageView alloc] initWithImage:[geometryPasterTemplate.geoTemplateImageView image]];
        self.geoPasterImageView.frame = geometryPasterTemplate.geoTemplateImageView.frame;
        self.geoPasterType = geometryPasterTemplate.geoTemplateType;
        self.geoPasterColor = geometryPasterTemplate.geoTemplateColor;
    }
    return self;
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
