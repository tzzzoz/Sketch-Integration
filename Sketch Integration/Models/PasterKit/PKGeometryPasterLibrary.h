//
//  PKGeometryPasterLibrary.h
//  Sketch
//
//  Created by    on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKGeometryPasterTemplate.h"
#import "PKGeometryPaster.h"

@interface PKGeometryPasterLibrary : NSObject {
    NSMutableArray *geometryPasterTemplates;
    NSMutableArray *geometryPasters;
    BOOL isModified;
}

-(id)initWithDataOfPlist;

@property (retain, nonatomic) NSMutableArray *geometryPasterTemplates;
@property (retain, nonatomic) NSMutableArray *geometryPasters;
@property (assign, nonatomic) BOOL isModified;

-(id)initWithDataOfPlist;
-(BOOL)saveDataToDoc:(BOOL) isFirst;
-(void) readDataFromDoc;
@end
