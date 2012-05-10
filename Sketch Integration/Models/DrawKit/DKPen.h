//
//  DKPen.h
//  SketchWonderLand
//
//  Created by  on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKColor.h"
#import "EnumClass.h"

@interface DKPen : NSObject
{
    //for define pen's state, YES for draw and NO for filling 
    BOOL penDrawState;
    BOOL penSelectedState;
    
    DKColor* color;
}

@property (retain,nonatomic) DKColor* color;
@property (assign) BOOL penDrawState;
@property (assign) BOOL penSelectedState;

-(void)setColorWithColor:(UIColor *)colorForUI;

@end
