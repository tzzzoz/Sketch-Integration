//
//  UIImage+NSCoder.m
//  NSKeyedArchiver
//
//  Created by 付 乙荷 on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+NSCoder.h"

@implementation UIImage (NSCoder)
- (id)initWithCoder:(NSCoder *)decoder {
    NSData *pngData = [decoder decodeObjectForKey:@"PNGRepresentation"];
    [self autorelease];
    self = [[UIImage alloc] initWithData:pngData];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:UIImagePNGRepresentation(self) forKey:@"PNGRepresentation"];
}

@end
