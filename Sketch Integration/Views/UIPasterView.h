//
//  UIPasterView.h
//  Sketch Integration
//
//  Created by kwan terry on 12-4-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PKGeometryImageView.h"

@interface UIPasterView : UIView
{
    CGPoint beginPoint;
    CGAffineTransform rotationTransform;
    CGAffineTransform translationTransform;
    CGAffineTransform scaleTransform;
    
    UIImageView* pasterTemplateImageView;
    PKGeometryImageView* selectedGeoImageView;
}

@property (retain, nonatomic) UIImageView* pasterTemplateImageView;
@property (retain, nonatomic) PKGeometryImageView* selectedGeoImageView;
@property (assign, nonatomic) CGPoint beginPoint;
@property (assign, nonatomic) CGAffineTransform rotationTransform;
@property (assign, nonatomic) CGAffineTransform translationTransform;
@property (assign, nonatomic) CGAffineTransform scaleTransform;
@end
