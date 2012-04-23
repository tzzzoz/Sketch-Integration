//
//  DKPen.m
//  SketchWonderLand
//
//  Created by  on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKPen.h"

@implementation DKPen
@synthesize color;// size, state, style;

- (id)init
{
    self = [super init];
    if (self) {
     // Initialization code here.
      //  color = [UIColor blackColor];
        color = black;
        state = YES;
    }
    
    return self;
}

//- (id)initWithStyle:(NSInteger) style{
//    switch (style) {
//        case 0:
//            NSLog(@"This is waterColorPen");
//            break;
//            
//        default:
//            break;
//    }
//    return self;
//}

-(void)changeColorWith:(NSInteger)colorButtonNumber{
    switch (colorButtonNumber) {
        case 1:
        {
            color = black;
            NSLog(@"It's black");
            break;
        }
        case 2:
            color = red;
            NSLog(@"Red");
            break;
        case 3:
            color = yellow;
            break;
        case 4:
            color = lightBlue;
            break;
        case 5:
            color = grassGreen;
            break;
        case 6:
            color = purple;
            break;
        case 7:
            color = brown;
            break;
        case 8:
            color = lightOrange;
            break;
        case 9:
            color = lightPurple;
            break;
        case 10:
            color = roseRed;
            break;
        case 11:
            color = lightGreen;
            break;
        case 12:
            color = darkPurple;
            break;
        case 13:
            color = grey;
            break;
        case 14:
            color = green;
            break;
        case 15:
            color = blue;
            break;
        case 16:
            color = darkBlue;
            break;
        case 17:
            color = darkGreen;
            break;
        case 18:
            color = pink;
            break;
            
        default:
            break;
    }
}

@end