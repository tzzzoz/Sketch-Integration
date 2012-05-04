//
//  UIFrameView.h
//  Sketch Integration
//
//  Created by kwan terry on 12-5-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKGeometryImageView.h"

@interface UIFrameView : UIView
{
    BOOL isFoul;
    PKGeometryImageView* currentPasterView;
}

@property (retain,nonatomic) PKGeometryImageView* currentPasterView;
@property (assign,nonatomic) BOOL isFoul;

@end
