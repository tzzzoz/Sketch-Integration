//
//  UIColor+DeepCopy.m
//  Sketch Integration
//
//  Created by    on 12-4-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+DeepCopy.h"

@implementation UIColor (DeepCopy)
-(id)deepCopy {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"colorDeepCopy"];
    [archiver finishEncoding];
    [archiver release];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    UIColor *color = [unarchiver decodeObjectForKey:@"colorDeepCopy"];
    [unarchiver release];
    [data release];
    
    return color;
}
@end
