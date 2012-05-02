//
//  DKPen.m
//  SketchWonderLand
//
//  Created by  on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKPen.h"

@implementation DKPen
@synthesize color, penState, colorPen; 

-(id)initWithColorNumber:(NSInteger) colorNumber{
    if (self == [super init]) {
        self.colorPen = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"colorButton%d", colorNumber]]];
        colorPen.frame = CGRectMake(122 + colorNumber  * 42, 684, 42, 130);
//        colorPen.frame = CGRectMake((colorNumber - 1) * 42, 20, 42, 130);
//        color = black;
//        选中
        penState = NO;
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
//

-(void)changeState{
    penState = !penState;
    NSLog(@"%d", penState);
//    penState = YES;
}

-(void)changePenStateWith:(BOOL)state{
    if (state) {
        colorPen.frame = CGRectMake(colorPen.frame.origin.x, 664, 42, 130);
    }
    else{
        colorPen.frame = CGRectMake(colorPen.frame.origin.x, 684, 42, 130);
    }
}

//-(void)changePenStateWith:(NSInteger) selectedPenNumber{
////    for (int i = 1; i <= 18; i++) {
////        self.colorPen.frame = CGRectMake(122 + (i - 1) * 42, 684, 42, 130);
////    }
//    self.colorPen.frame = CGRectMake(122 + (selectedPenNumber - 1) * 42, 664, 42, 130);
//}

-(UIColor *)changeColorWith:(NSInteger)colorButtonNumber{
    switch (colorButtonNumber) {
        case 0:
        {
            color = black;
            NSLog(@"It's black");
            return [UIColor colorWithRed:1/255.0f green:1/255.0f blue:1/255.0f alpha:255/255.0f];
            break;
        }
        case 1:
            color = red;
            NSLog(@"Red");
            return [UIColor colorWithRed:254/255.0f green:0 blue:0 alpha:255/255.0f];
            break;
        case 2:
            color = yellow;
            NSLog(@"YELLOW");
            return [UIColor colorWithRed:237/255.0f green:226/255.0f blue:37/255.0f alpha:255/255.0f];
            break;
        case 3:
            color = lightBlue;
            NSLog(@"lightBlue");
            return [UIColor colorWithRed:0 green:254/255.0f blue:254/255.0f alpha:255/255.0f];
            break;
        case 4:
            color = grassGreen;
            NSLog(@"grassGreen");
            return [UIColor colorWithRed:1/255.0f green:255/255.0f blue:2/255.0f alpha:255/255.0f];
            break;
        case 5:
            color = purple;
            NSLog(@"PURPLE");
            return [UIColor colorWithRed:127/255.0f green:0 blue:255/255.0f alpha:255/255.0f];
            break;
        case 6:
            color = brown;
            return [UIColor colorWithRed:138/255.0f green:69/255.0f blue:2/255.0f alpha:1.0f];
            break;
        case 7:
            color = lightOrange;
            return [UIColor colorWithRed:255/255.0f green:128/255.0f blue:63/255.0f alpha:1.0f];
            break;
        case 8:
            color = lightPurple;
            return [UIColor colorWithRed:255/255.0f green:1/255.0f blue:255/255.0f alpha:1.0f];
            break;
        case 9:
            color = roseRed;
            return [UIColor colorWithRed:255/255.0f green:0 blue:128/255.0f alpha:1.0f];
            break;
        case 10:
            color = lightGreen;
            return [UIColor colorWithRed:160/255.0f green:159/255.0f blue:79/255.0f alpha:1.0f];
            break;
        case 11:
            color = darkPurple;
            return [UIColor colorWithRed:108/255.0f green:8/255.0f blue:146/255.0f alpha:1.0f];
            break;
        case 12:
            color = grey;
            return [UIColor colorWithRed:192/255.0f green:192/255.0f blue:192/255.0f alpha:1.0f];
            break;
        case 13:
            color = green;
            return [UIColor colorWithRed:0 green:129/255.0f blue:0 alpha:1.0f];
            break;
        case 14:
            color = blue;
            return [UIColor colorWithRed:1/255.0f green:76/255.0f blue:255/255.0f alpha:1.0f];
            break;
        case 15:
            color = darkBlue;
            return [UIColor colorWithRed:0 green:36/255.0f blue:158/255.0f alpha:1.0f];
            break;
        case 16:
            color = darkGreen;
            return [UIColor colorWithRed:0 green:130/255.0f blue:130/255.0f alpha:1.0f];
            break;
        case 17:
            color = pink;
            return [UIColor colorWithRed:255/255.0f green:153/255.0f blue:204/255.0f alpha:1.0f];
            break;
            
        default:
            return [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            break;
    }
}

@end