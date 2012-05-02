//
//  PKGeometryPasterLibrary.m
//  Sketch
//
//  Created by    on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKGeometryPasterLibrary.h"

@implementation PKGeometryPasterLibrary

@synthesize geometryPasterTemplates;
@synthesize geometryPasters;
@synthesize isModified;

-(id)initWithDataOfPlist {
    self = [super init];
    if (self) {
        self.isModified = NO;
        
        //尝试使用NSKeyedUnarchiver解档出几何贴纸模板和几何贴纸对象
        //判断是否第一次使用，如果是，将使用plist进行初始化配置
        [self readDataFromDoc];
        if ( self.geometryPasterTemplates == nil) {
            //读取Plist
            //get the plist file from bundle
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DataOfGeoPasterTemplates" ofType:@"plist"];
            // build the array from the plist  
            NSDictionary *dataOfPlist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            NSArray *dataOfPasterTemplates = [dataOfPlist objectForKey:@"DataOfGeoPasterTemplates"];
            
            
            NSUInteger sizeOfGeoPasterTemplates = [dataOfPasterTemplates count];
            self.geometryPasterTemplates = [[[NSMutableArray alloc] initWithCapacity:sizeOfGeoPasterTemplates] autorelease];
            self.geometryPasters = [[[NSMutableArray alloc] initWithCapacity:sizeOfGeoPasterTemplates] autorelease];
            
            for (int index = 0; index < sizeOfGeoPasterTemplates; index++) {
                NSDictionary *dataOfGeoPasterTemplate = [dataOfPasterTemplates objectAtIndex:index];
                NSString *fileName = [dataOfGeoPasterTemplate objectForKey:@"FileName"];
                NSNumber *type = [dataOfGeoPasterTemplate objectForKey:@"Type"];
                NSNumber *x = [dataOfGeoPasterTemplate objectForKey:@"X"];
                NSNumber *y = [dataOfGeoPasterTemplate objectForKey:@"Y"];
                
                CGRect rect = CGRectMake([x intValue], [y intValue], sizeOfGeoPasterTemplate, sizeOfGeoPasterTemplate);
                PKGeometryPasterTemplate *geoPasterTemplate = [[PKGeometryPasterTemplate alloc] initWithFileName:fileName Type:[type intValue] Rect:rect];
                
                PKGeometryPaster *geoPaster = [[PKGeometryPaster alloc] initWithGeometryPasterTemplate:geoPasterTemplate];
                [self.geometryPasterTemplates addObject:geoPasterTemplate];
                [self.geometryPasters addObject:geoPaster];
                [geoPasterTemplate release];
                [geoPaster release];
            }
            [dataOfPlist release];
            [self saveDataToDoc:YES];
        }
    }
    return  self;
}


-(BOOL)saveDataToDoc:(BOOL) isFirst {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName;
    //是否是第一次保存，第一次需要保存模板的信息，之后不再需要
    if (isFirst) {
        fileName = [path stringByAppendingPathComponent:@"GeoPasterLibrary_GeoPasterTemplates"];
        [NSKeyedArchiver archiveRootObject:self.geometryPasterTemplates toFile:fileName];
        
        fileName = [path stringByAppendingPathComponent:@"GeoPasterLibrary_GeoPasters"];
        [NSKeyedArchiver archiveRootObject:self.geometryPasters toFile:fileName];
    } else {
        //如果不是第一次保存，只保存几何贴纸对象不再保存模板对象;如果被几何贴纸修改过才会更新，写回本地
        if (isModified) {
            fileName = [path stringByAppendingPathComponent:@"GeoPasterLibrary_GeoPasters"];
            [NSKeyedArchiver archiveRootObject:self.geometryPasters toFile:fileName];
        } else
            return YES;
    }
    //判断是否成功存储到Documents
    NSMutableArray *testArray = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    if (testArray) {
        return NO;
    } else {
        return YES;
    }
}

-(void) readDataFromDoc {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename;
    filename = [path stringByAppendingPathComponent:@"GeoPasterLibrary_GeoPasterTemplates"];
    self.geometryPasterTemplates = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
    filename = [path stringByAppendingPathComponent:@"GeoPasterLibrary_GeoPasters"];
    self.geometryPasters = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
}

@end
