//
//  DKColor.m
//  Sketch Integration
//
//  Created by kwan terry on 12-5-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKColor.h"

@implementation DKColor

@synthesize color,colorImageView,colorType;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.colorType = -1;
        self.colorImageView = [[UIImageView alloc]init];
        self.color = [[UIColor alloc]init];
    }
    
    return self;
}

-(id)initWithColorType:(ColorType)type ImageView:(UIImageView*)imageView Color:(UIColor*)colorTemp
{
    self = [super init];
    
    if(self)
    {
        self.colorType = type;
        self.colorImageView = imageView;
        self.color = colorTemp;
    }
    
    return self;
}

-(void)dealloc
{
    [colorImageView release];
    [color release];
    [super dealloc];
}

@end
