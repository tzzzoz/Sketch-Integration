//
//  DKPen.h
//  SketchWonderLand
//
//  Created by  on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumClass.h"

@interface DKPen : NSObject{
//    id <changePenState> delegate;
    NSInteger color;
    //for define pen's state, YES for draw and NO for filling 
    BOOL penState;
    UIImageView *colorPen;
//    NSInteger colorState;
}

@property (readwrite) NSInteger color;
@property (readwrite) BOOL penState;
@property (retain, nonatomic) UIImageView *colorPen;
//@property (readwrite) NSInteger colorState;

-(id)initWithColorNumber:(NSInteger) colorNumber;
-(UIColor *)changeColorWith:(NSInteger)colorButtonNumber;
-(void)changePenStateWith:(BOOL)penState;
-(void)changeState;
@end
