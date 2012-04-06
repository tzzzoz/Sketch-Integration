//
//  PKPasterTemplate.h
//  Sketch
//
//  Created by 付 乙荷 on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKGeometryPasterTemplate.h"

@interface PKPasterTemplate : NSObject <NSCoding>{
    NSMutableArray *geoPasterTemplates;
    UIImageView *pasterView;
    BOOL isModified;
}

-(id)initWithFileName:(NSString *)fileName GeoPasterTemplates:(NSMutableArray *)array;

@property (retain, nonatomic) NSMutableArray *geoPasterTemplates;
@property (retain, nonatomic) UIImageView *pasterView;
@property (readwrite) BOOL isModified;

@end