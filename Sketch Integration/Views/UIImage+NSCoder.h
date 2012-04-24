//
//  UIImage+NSCoder.h
//  NSKeyedArchiver
//
//  Created by 付 乙荷 on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NSCoder)
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end
