//
//  DKColorPalette.m
//  Sketch Integration
//
//  Created by kwan terry on 12-5-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKColorPalette.h"

@implementation DKColorPalette

@synthesize colorArray,selectedColorIndex;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        [self initColorArray];
    }
    
    return self;
}

-(void)initColorArray
{
    colorArray = [[NSMutableArray alloc]init];
    for(int i=0; i<18; i++)
    {
        UIImageView* colorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"colorButton%d", i]]];
        colorImageView.frame = CGRectMake(122 + i  * 42, 684, 42, 130);
        ColorType colorType;
        UIColor* colorTemp = nil;
        switch (i) 
        {
            case 0:
            {
                colorType = black;
                NSLog(@"It's black");
                colorTemp = [UIColor colorWithRed:1/255.0f green:1/255.0f blue:1/255.0f alpha:255/255.0f];
                break;
            }
            case 1:
                colorType = red;
                NSLog(@"Red");
                colorTemp = [UIColor colorWithRed:254/255.0f green:0 blue:0 alpha:255/255.0f];
                break;
            case 2:
                colorType = yellow;
                NSLog(@"YELLOW");
                colorTemp = [UIColor colorWithRed:237/255.0f green:226/255.0f blue:37/255.0f alpha:255/255.0f];
                break;
            case 3:
                colorType = lightBlue;
                NSLog(@"lightBlue");
                colorTemp = [UIColor colorWithRed:0 green:254/255.0f blue:254/255.0f alpha:255/255.0f];
                break;
            case 4:
                colorType = grassGreen;
                NSLog(@"grassGreen");
                colorTemp = [UIColor colorWithRed:1/255.0f green:255/255.0f blue:2/255.0f alpha:255/255.0f];
                break;
            case 5:
                colorType = purple;
                NSLog(@"PURPLE");
                colorTemp = [UIColor colorWithRed:127/255.0f green:0 blue:255/255.0f alpha:255/255.0f];
                break;
            case 6:
                colorType = brown;
                colorTemp = [UIColor colorWithRed:138/255.0f green:69/255.0f blue:2/255.0f alpha:1.0f];
                break;
            case 7:
                colorType = lightOrange;
                colorTemp = [UIColor colorWithRed:255/255.0f green:128/255.0f blue:63/255.0f alpha:1.0f];
                break;
            case 8:
                colorType = lightPurple;
                colorTemp = [UIColor colorWithRed:255/255.0f green:1/255.0f blue:255/255.0f alpha:1.0f];
                break;
            case 9:
                colorType = roseRed;
                colorTemp = [UIColor colorWithRed:255/255.0f green:0 blue:128/255.0f alpha:1.0f];
                break;
            case 10:
                colorType = lightGreen;
                colorTemp = [UIColor colorWithRed:160/255.0f green:159/255.0f blue:79/255.0f alpha:1.0f];
                break;
            case 11:
                colorType = darkPurple;
                colorTemp = [UIColor colorWithRed:108/255.0f green:8/255.0f blue:146/255.0f alpha:1.0f];
                break;
            case 12:
                colorType = grey;
                colorTemp = [UIColor colorWithRed:192/255.0f green:192/255.0f blue:192/255.0f alpha:1.0f];
                break;
            case 13:
                colorType = green;
                colorTemp = [UIColor colorWithRed:0 green:129/255.0f blue:0 alpha:1.0f];
                break;
            case 14:
                colorType = blue;
                colorTemp = [UIColor colorWithRed:1/255.0f green:76/255.0f blue:255/255.0f alpha:1.0f];
                break;
            case 15:
                colorType = darkBlue;
                colorTemp = [UIColor colorWithRed:0 green:36/255.0f blue:158/255.0f alpha:1.0f];
                break;
            case 16:
                colorType = darkGreen;
                colorTemp = [UIColor colorWithRed:0 green:130/255.0f blue:130/255.0f alpha:1.0f];
                break;
            case 17:
                colorType = pink;
                colorTemp = [UIColor colorWithRed:255/255.0f green:153/255.0f blue:204/255.0f alpha:1.0f];
                break;
            default:
                colorTemp = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                break;
        }
        DKColor* newColor = [[DKColor alloc]initWithColorType:colorType ImageView:colorImageView Color:colorTemp];
        [colorArray addObject:newColor];
        [newColor release];
    }
}

+(UIColor*)changeColorWith:(int)number
{
    switch (number) 
    {
        case 0:
        {
            NSLog(@"It's black");
            return [UIColor colorWithRed:1/255.0f green:1/255.0f blue:1/255.0f alpha:255/255.0f];
            break;
        }
        case 1:
            NSLog(@"Red");
            return [UIColor colorWithRed:254/255.0f green:0 blue:0 alpha:255/255.0f];
            break;
        case 2:
            NSLog(@"YELLOW");
            return [UIColor colorWithRed:237/255.0f green:226/255.0f blue:37/255.0f alpha:255/255.0f];
            break;
        case 3:
            NSLog(@"lightBlue");
            return [UIColor colorWithRed:0 green:254/255.0f blue:254/255.0f alpha:255/255.0f];
            break;
        case 4:
            NSLog(@"grassGreen");
            return [UIColor colorWithRed:1/255.0f green:255/255.0f blue:2/255.0f alpha:255/255.0f];
            break;
        case 5:
            NSLog(@"PURPLE");
            return [UIColor colorWithRed:127/255.0f green:0 blue:255/255.0f alpha:255/255.0f];
            break;
        case 6:
            return [UIColor colorWithRed:138/255.0f green:69/255.0f blue:2/255.0f alpha:1.0f];
            break;
        case 7:
            return [UIColor colorWithRed:255/255.0f green:128/255.0f blue:63/255.0f alpha:1.0f];
            break;
        case 8:
            return [UIColor colorWithRed:255/255.0f green:1/255.0f blue:255/255.0f alpha:1.0f];
            break;
        case 9:
            return [UIColor colorWithRed:255/255.0f green:0 blue:128/255.0f alpha:1.0f];
            break;
        case 10:
            return [UIColor colorWithRed:160/255.0f green:159/255.0f blue:79/255.0f alpha:1.0f];
            break;
        case 11:
            return [UIColor colorWithRed:108/255.0f green:8/255.0f blue:146/255.0f alpha:1.0f];
            break;
        case 12:
            return [UIColor colorWithRed:192/255.0f green:192/255.0f blue:192/255.0f alpha:1.0f];
            break;
        case 13:
            return [UIColor colorWithRed:0 green:129/255.0f blue:0 alpha:1.0f];
            break;
        case 14:
            return [UIColor colorWithRed:1/255.0f green:76/255.0f blue:255/255.0f alpha:1.0f];
            break;
        case 15:
            return [UIColor colorWithRed:0 green:36/255.0f blue:158/255.0f alpha:1.0f];
            break;
        case 16:
            return [UIColor colorWithRed:0 green:130/255.0f blue:130/255.0f alpha:1.0f];
            break;
        case 17:
            return [UIColor colorWithRed:255/255.0f green:153/255.0f blue:204/255.0f alpha:1.0f];
            break;
            
        default:
            return [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            break;
    }
}

-(void)dealloc
{
    [colorArray release];
    [super dealloc];
}

@end
