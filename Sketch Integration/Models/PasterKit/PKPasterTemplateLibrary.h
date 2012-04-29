//
//  PKPasterTemplateLibrary.h
//  Sketch
//
//  Created by 付 乙荷 on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKPasterTemplate.h"
#import "PKPasterWork.h"

@interface PKPasterTemplateLibrary : NSObject {
    NSMutableArray *pasterTemplates;
    NSMutableArray *pasterWorks;
    BOOL isModified;
}

-(id)initWithDataOfPlist;

@property (retain, nonatomic) NSMutableArray *pasterTemplates;
@property (retain, nonatomic) NSMutableArray *pasterWorks;
@property (assign, nonatomic) BOOL isModified;

-(BOOL)saveDataToDoc:(BOOL) isFirst;
-(void) readDataFromDoc;
@end
