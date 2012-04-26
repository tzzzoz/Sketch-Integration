//
//  DKPen.h
//  SketchWonderLand
//
//  Created by  on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumClass.h"

//@protocol changePenState <NSObject>
//
//@required
//-(void) change: (BOOL) state;
//
//@end

@interface DKPen : NSObject{
//    id <changePenState> delegate;
    NSInteger color;
    //for define pen's state, YES for draw and NO for filling 
    BOOL state;
}

//@property (retain) id delegate;
@property (nonatomic) NSInteger color;
//@property (nonatomic) NSInteger size;
@property (nonatomic) BOOL state;
//@property (nonatomic) NSInteger style;

//-(void)changeState;
-(void)changeColorWith:(NSInteger)colorButtonNumber;

@end
