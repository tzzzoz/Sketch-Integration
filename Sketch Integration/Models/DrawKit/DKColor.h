//
//  DKColor.h
//  Sketch Integration
//
//  Created by kwan terry on 12-5-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumClass.h"

@interface DKColor : NSObject
{
    ColorType colorType;
    UIColor* color;
    UIImageView* colorImageView;
}

@property (retain,nonatomic) UIColor* color;
@property (retain,nonatomic) UIImageView* colorImageView;
@property (assign,nonatomic) ColorType colorType;

-(id)initWithColorType:(ColorType)type ImageView:(UIImageView*)imageView Color:(UIColor*)color;

@end
