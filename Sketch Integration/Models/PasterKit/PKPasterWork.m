//
//  PKPasterWork.m
//  Sketch
//
//  Created by    on 12-4-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKPasterWork.h"
#import "UIImageView+DeepCopy.h"

@implementation PKPasterWork

@synthesize geoPasters;
@synthesize pasterView;

- (id)initWithPasterTemplate:(PKPasterTemplate *)pasterTemplate {
    self = [super init];
    if (self) {
        self.geoPasters = [[[NSMutableArray alloc] initWithCapacity:[pasterTemplate.geoPasterTemplates count]] autorelease];
        self.pasterView = [pasterTemplate.pasterView deepCopy];
    }
    return self;
}

-(void)insertGeoPaster:(PKGeometryPaster *)geoPaster atIndex:(NSUInteger)index {
    [self.geoPasters insertObject:[[geoPaster copy] autorelease] atIndex:index];
    [self.pasterView addSubview:geoPaster.geoPasterImageView];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.geoPasters = [aDecoder decodeObjectForKey:@"geoPasters"];
        self.pasterView = [aDecoder decodeObjectForKey:@"pasterView"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:geoPasters forKey:@"geoPasters"];
    [aCoder encodeObject:pasterView forKey:@"pasterView"];
}

- (id)copyWithZone:(NSZone *)zone
{
    PKPasterWork *copy = [[[self class] allocWithZone:zone] init];
    copy.pasterView = [self.pasterView deepCopy];
    copy.geoPasters = [self.geoPasters copy];
    
    return copy;
}

@end
