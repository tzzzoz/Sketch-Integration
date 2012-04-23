//
//  DKPen.h
//  SketchWonderLand
//
//  Created by  on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKPen : NSObject{
    //CGColorRef *color;
 //   NSInteger size;
    NSInteger color;
    //for define pen's state, YES for draw and NO for filling 
    BOOL state;
//    NSInteger style;
    enum {black, red, yellow, lightBlue, grassGreen, purple, brown, lightOrange, lightPurple, roseRed, lightGreen, darkPurple, grey, green, blue, darkBlue, darkGreen, pink};
}

@property (nonatomic) NSInteger color;
//@property (nonatomic) NSInteger size;
//@property (nonatomic) BOOL state;
//@property (nonatomic) NSInteger style;

-(void)changeColorWith:(NSInteger)colorButtonNumber;

@end
