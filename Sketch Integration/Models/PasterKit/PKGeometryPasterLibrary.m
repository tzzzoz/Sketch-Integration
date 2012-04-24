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

// -(id)initWithDataOfPlist
// {
//     [super init];
//     
//     //read the plist
//     //get the plist file from bundle
//     NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"DataOfGeoTemplates" ofType:@"plist"];
//     //build the array from the plist
//     NSDictionary *dataOfPlist = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
//     NSArray *dataOfGeoTemplates = [dataOfPlist objectForKey:@"DataOfGeoTemplates"];
//     
//     int sizeOfGeoTemplates = [dataOfGeoTemplates count];
//     geometryPasterTemplates = [[NSMutableArray alloc]initWithCapacity:sizeOfGeoTemplates];
//     geometryPasters = [[NSMutableArray alloc]initWithCapacity:sizeOfGeoTemplates];
//     
//     for(int i=0; i<sizeOfGeoTemplates; i++)
//     {
//         NSDictionary* dataOfGeoTemplate = [dataOfGeoTemplates objectAtIndex:i];
//         
//         NSString* fileNameOfGeoTemplate = [dataOfGeoTemplate objectForKey:@"FileName"];
//         NSNumber* typeOfGeoTemplate = [dataOfGeoTemplate objectForKey:@"Type"];
//         NSNumber* red = [dataOfGeoTemplate objectForKey:@"Red"];
//         NSNumber* blue = [dataOfGeoTemplate objectForKey:@"Blue"];
//         NSNumber* green = [dataOfGeoTemplate objectForKey:@"Green"];
//         NSNumber* alpha = [dataOfGeoTemplate objectForKey:@"Alpha"];
//         
//         UIColor* geoTemplateColor = [[UIColor alloc]initWithRed:[red floatValue] green:[green floatValue] blue:[blue floatValue] alpha:[alpha floatValue]];
//         PKGeometryPasterTemplate* geoTemplate = [[PKGeometryPasterTemplate alloc]initWithFileName:fileNameOfGeoTemplate Color:geoTemplateColor Type:[typeOfGeoTemplate intValue] Rect:CGRectMake(0, 0, 0, 0)];
//         [geometryPasterTemplates insertObject:geoTemplate atIndex:i];
//         [geoTemplateColor release];
//         [geoTemplate release];
//     }
//     
//     return self;
// }

-(id)initWithDataOfPlist {
    self = [super init];
    if (self) {
        //读取Plist
        //get the plist file from bundle
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DataOfGeoPasterTemplates" ofType:@"plist"];
        // build the array from the plist  
        NSDictionary *dataOfPlist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        NSArray *dataOfPasterTemplates = [dataOfPlist objectForKey:@"DataOfGeoPasterTemplates"];
        
        
        NSUInteger sizeOfGeoPasterTemplates = [dataOfPasterTemplates count];
        geometryPasterTemplates = [[NSMutableArray alloc] initWithCapacity:sizeOfGeoPasterTemplates];
        geometryPasters = [[NSMutableArray alloc] initWithCapacity:sizeOfGeoPasterTemplates];

        for (int index = 0; index < sizeOfGeoPasterTemplates; index++) {
            NSDictionary *dataOfGeoPasterTemplate = [dataOfPasterTemplates objectAtIndex:index];
            NSString *fileName = [dataOfGeoPasterTemplate objectForKey:@"FileName"];
            NSNumber *type = [dataOfGeoPasterTemplate objectForKey:@"Type"];
            NSNumber *x = [dataOfGeoPasterTemplate objectForKey:@"X"];
            NSNumber *y = [dataOfGeoPasterTemplate objectForKey:@"Y"];

            CGRect rect = CGRectMake([x intValue], [y intValue], sizeOfGeoPasterTemplate, sizeOfGeoPasterTemplate);
            PKGeometryPasterTemplate *geoPasterTemplate = [[PKGeometryPasterTemplate alloc] initWithFileName:fileName Type:[type intValue] Rect:rect];
            
            PKGeometryPaster *geoPaster = [[PKGeometryPaster alloc] initWithGeometryPasterTemplate:geoPasterTemplate];
            [geometryPasterTemplates addObject:geoPasterTemplate];
            [geometryPasters addObject:geoPaster];
            [geoPasterTemplate release];
            [geoPaster release];
        }
        [dataOfPlist release];
    }
    return  self;
}

@end
