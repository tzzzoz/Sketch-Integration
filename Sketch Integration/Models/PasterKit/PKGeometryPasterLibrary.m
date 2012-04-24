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
