//
//  PKGeometryPasterLibrary.h
//  Sketch
//
//  Created by 付 乙荷 on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKGeometryPasterTemplate.h"
#import "PKGeometryPaster.h"

@interface PKGeometryPasterLibrary : NSObject {
    NSMutableArray *geometryPasterTemplates;
    NSMutableArray *geometryPasters;
}

@property (retain, nonatomic) NSMutableArray *geometryPasterTemplates;
@property (retain, nonatomic) NSMutableArray *geometryPasters;

-(id)initWithDataOfPlist;
@end
