//
//  UIImageView+DeepCopy.m
//  NSKeyedArchiver
//
//  Created by    on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+DeepCopy.h"
#import "UIImage+NSCoder.h"

@implementation UIImageView (DeepCopy)

-(id)deepCopy
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"imageViewDeepCopy"];
    [archiver finishEncoding];
    [archiver release];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    UIImageView *imgView = [unarchiver decodeObjectForKey:@"imageViewDeepCopy"];
    [unarchiver release];
    [data release];
    
    return imgView;
}

@end
