//
//  PKPasterTemplate.m
//  Sketch
//
//  Created by 付 乙荷 on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKPasterTemplate.h"

@implementation PKPasterTemplate

@synthesize geoPasterTemplates;
@synthesize pasterView;
@synthesize isModified;

-(id)initWithFileName:(NSString *)fileName GeoPasterTemplates:(NSMutableArray *)array {
    if (self = [super init]) {
        self.geoPasterTemplates = [[NSMutableArray alloc] init];
        self.pasterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName]];
        self.isModified = FALSE;
        
        geoPasterTemplates = array;
        //把几何贴纸模板的geoTemplateImageView添加到贴纸模板的父视图pasterView中
        for (PKGeometryPasterTemplate *geoPasterTemplate in array) {
            [self.pasterView addSubview:geoPasterTemplate.geoTemplateImageView];
        }
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.geoPasterTemplates = [aDecoder decodeObjectForKey:@"geoPasterTemplates"];
        self.pasterView = [aDecoder decodeObjectForKey:@"pasterView"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:geoPasterTemplates forKey:@"geoPasterTemplates"];
    [aCoder encodeObject:pasterView forKey:@"pasterView"];
}
@end
