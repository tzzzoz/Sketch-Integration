//
//  PKPasterTemplateLibrary.m
//  Sketch
//
//  Created by    on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKPasterTemplateLibrary.h"

@implementation PKPasterTemplateLibrary

@synthesize pasterTemplates;
@synthesize pasterWorks;
@synthesize isModified;

-(id)initWithDataOfPlist {
    self = [super init];    
    //
    if (self) {
        self.isModified = NO;
        
        //尝试使用NSKeyedUnarchiver解档出几何贴纸模板和几何贴纸对象
        [self readDataFromDoc];
        //判断是否第一次使用，如果是，将使用plist进行初始化配置
        if (self.pasterTemplates == nil) {
            //读取Plist
            //get the plist file from bundle
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DataOfPasterTemplates" ofType:@"plist"];   
            // build the array from the plist  
            NSDictionary *dataOfPlist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            NSArray *dataOfPasterTemplates = [dataOfPlist objectForKey:@"DataOfPasterTemplates"];
            
            //读取出贴纸模板的数量，根据数量初始化贴纸模板数组和贴纸作品数组
            NSUInteger sizeOfPasterTemplates = [dataOfPasterTemplates count];
            self.pasterTemplates = [[[NSMutableArray alloc] initWithCapacity:sizeOfPasterTemplates] autorelease];
            self.pasterWorks = [[[NSMutableArray alloc] initWithCapacity:sizeOfPasterTemplates] autorelease];
            
            //遍历dataOfPasterTemplates贴纸模板数组
            for (int i = 0; i < sizeOfPasterTemplates; i++) {
                
                NSDictionary *dataOfPasterTemplate = [dataOfPasterTemplates objectAtIndex:i];
                
                NSString *fileNameOfPasterTemplate = [dataOfPasterTemplate objectForKey:@"FileName"];
                NSNumber *countOfGeoTemplates = [dataOfPasterTemplate valueForKey:@"CountOfGeoTemplates"];
                NSArray *dataOfGeoPasterTemplates = [dataOfPasterTemplate objectForKey:@"GeoPasterTemplates"];
                
                
                //遍历geoPasterTemplates几何贴纸模板数组
                NSUInteger sizeOfGeoPasterTemplates = [countOfGeoTemplates intValue];
                //创建一个临时的数组，用于贴纸模板的初始化
                NSMutableArray *geoPasterTemplates = [[[NSMutableArray alloc] initWithCapacity:sizeOfPasterTemplates] autorelease];
                for (int j = 0; j < sizeOfGeoPasterTemplates; j++) {
                    NSDictionary *dataOfGeoPasterTemplate = [dataOfGeoPasterTemplates objectAtIndex:j];
                    //读取颜色数据，并构造一个颜色UIColor
                    NSNumber *red = [dataOfGeoPasterTemplate objectForKey:@"Red"];
                    NSNumber *blue = [dataOfGeoPasterTemplate objectForKey:@"Blue"];
                    NSNumber *green = [dataOfGeoPasterTemplate objectForKey:@"Green"];
                    NSNumber *alpha = [dataOfGeoPasterTemplate objectForKey:@"Alpha"];
                    UIColor *geoTemplateColor = [[UIColor alloc] initWithRed:[red floatValue] green:[green floatValue] blue:[blue floatValue] alpha:[alpha floatValue]];
                    
                    //读取几何贴纸的View的frame信息，并构造一个CGRect
                    NSNumber *x = [dataOfGeoPasterTemplate objectForKey:@"X"];
                    NSNumber *y = [dataOfGeoPasterTemplate objectForKey:@"Y"];
                    NSNumber *width = [dataOfGeoPasterTemplate objectForKey:@"Width"];
                    NSNumber *height = [dataOfGeoPasterTemplate objectForKey:@"Height"];
                    CGRect rect = CGRectMake([x intValue], [y intValue], [width intValue], [height intValue]);
                    
                    //读取几何贴纸模板的类型
                    NSNumber *type = [dataOfGeoPasterTemplate objectForKey:@"Type"];
                    
                    NSString *fileNameOfGeoPasterTemplate = [dataOfGeoPasterTemplate objectForKey:@"FileName"];
                    
                    //根据前面创建的UIColor和CGRect等信息，去创建几何贴纸模板对象
                    PKGeometryPasterTemplate *geoPasterTemplate = [[PKGeometryPasterTemplate alloc] initWithFileName:fileNameOfGeoPasterTemplate Color:geoTemplateColor Type:[type intValue] Rect:rect];
                    
                    //设置几何贴纸模板的View的frame
                    geoPasterTemplate.geoTemplateImageView.frame = rect;
                    
                    
                    //把几何贴纸模板对象，添加到临时的geoPasterTemplates数组中
                    [geoPasterTemplates insertObject:geoPasterTemplate atIndex:j];
                    
                    
                    [geoTemplateColor release];
                    [geoPasterTemplate release];
                }
                
                //利用plist中的数据初始化贴纸模板，并添加到数组中
                PKPasterTemplate *pasterTemplate = [[PKPasterTemplate alloc] initWithFileName:fileNameOfPasterTemplate GeoPasterTemplates:geoPasterTemplates];
                
                [self.pasterTemplates insertObject:pasterTemplate atIndex:i];
                
                //利用已有的贴纸模板初始化贴纸作品，也添加到数组中
                PKPasterWork *pasterWork = [[PKPasterWork alloc] initWithPasterTemplate:pasterTemplate];
                
                [pasterTemplate release];
                
                [self.pasterWorks insertObject:pasterWork atIndex:i];
                [pasterWork release];
            }
            [dataOfPlist release];
            [self saveDataToDoc:YES];
        }
    }
    return self;
}

-(BOOL)saveDataToDoc:(BOOL) isFirst {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName;
    //是否是第一次保存，第一次需要保存模板的信息，之后不再需要
    if (isFirst) {
        fileName = [path stringByAppendingPathComponent:@"PasterLibrary_PasterTemplates"];
        [NSKeyedArchiver archiveRootObject:self.pasterTemplates toFile:fileName];
        
        fileName = [path stringByAppendingPathComponent:@"PasterLibrary_Pasters"];
        [NSKeyedArchiver archiveRootObject:self.pasterWorks toFile:fileName];
    } else {
        //如果不是第一次保存，只保存贴纸对象不再保存模板对象
        if (isModified) {
            fileName = [path stringByAppendingPathComponent:@"PasterLibrary_Pasters"];
            [NSKeyedArchiver archiveRootObject:self.pasterWorks toFile:fileName];
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
    filename = [path stringByAppendingPathComponent:@"PasterLibrary_PasterTemplates"];
    self.pasterTemplates = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
    filename = [path stringByAppendingPathComponent:@"PasterLibrary_Pasters"];
    self.pasterWorks = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
}

@end
