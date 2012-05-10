//
//  DKColorPalette.h
//  Sketch Integration
//
//  Created by kwan terry on 12-5-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKColor.h"

@interface DKColorPalette : NSObject
{
    NSMutableArray* colorArray;
    int selectedColorIndex;
}

@property (retain,nonatomic) NSMutableArray* colorArray;
@property (assign,nonatomic) int selectedColorIndex;

-(void)initColorArray;
+(UIColor*)changeColorWith:(int)number;

@end
