//
//  PKGeometryPasterLibrary.m
//  Sketch
//
//  Created by 付 乙荷 on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKGeometryPasterLibrary.h"

@implementation PKGeometryPasterLibrary
@synthesize geometryPasterTemplates;
@synthesize geometryPasters;

-(id)initWithDataOfPlist
{
    [super init];
    
    //read the plist
    //get the plist file from bundle
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"DataOfGeoTemplates" ofType:@"plist"];
    //build the array from the plist
    NSDictionary *dataOfPlist = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSArray *dataOfGeoTemplates = [dataOfPlist objectForKey:@"DataOfGeoTemplates"];
    
    int sizeOfGeoTemplates = [dataOfGeoTemplates count];
    geometryPasterTemplates = [[NSMutableArray alloc]initWithCapacity:sizeOfGeoTemplates];
    geometryPasters = [[NSMutableArray alloc]initWithCapacity:sizeOfGeoTemplates];
    
    for(int i=0; i<sizeOfGeoTemplates; i++)
    {
        NSDictionary* dataOfGeoTemplate = [dataOfGeoTemplates objectAtIndex:i];
        
        NSString* fileNameOfGeoTemplate = [dataOfGeoTemplate objectForKey:@"FileName"];
        NSNumber* typeOfGeoTemplate = [dataOfGeoTemplate objectForKey:@"Type"];
        NSNumber* red = [dataOfGeoTemplate objectForKey:@"Red"];
        NSNumber* blue = [dataOfGeoTemplate objectForKey:@"Blue"];
        NSNumber* green = [dataOfGeoTemplate objectForKey:@"Green"];
        NSNumber* alpha = [dataOfGeoTemplate objectForKey:@"Alpha"];
        
        UIColor* geoTemplateColor = [[UIColor alloc]initWithRed:[red floatValue] green:[green floatValue] blue:[blue floatValue] alpha:[alpha floatValue]];
        PKGeometryPasterTemplate* geoTemplate = [[PKGeometryPasterTemplate alloc]initWithFileName:fileNameOfGeoTemplate Color:geoTemplateColor Type:[typeOfGeoTemplate intValue] Rect:CGRectMake(0, 0, 0, 0)];
        [geometryPasterTemplates insertObject:geoTemplate atIndex:i];
        [geoTemplateColor release];
        [geoTemplate release];
    }
    
    return self;
}

@end
