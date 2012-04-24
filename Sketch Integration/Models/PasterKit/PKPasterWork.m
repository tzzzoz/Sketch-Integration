//
//  PKPasterWork.m
//  Sketch
//
//  Created by 付 乙荷 on 12-4-3.
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
        self.geoPasters = [[NSMutableArray alloc] initWithCapacity:[pasterTemplate.geoPasterTemplates count]];
        self.pasterView = [[UIImageView alloc] init];
        self.pasterView = [pasterTemplate.pasterView deepCopy];
    }
    return self;
}

-(void)insertGeoPaster:(PKGeometryPaster *)geoPaster atIndex:(NSUInteger)index {
    [self.geoPasters insertObject:geoPasters atIndex:index];
    [self.pasterView addSubview:geoPaster.geoPasterImageView];
}

@end
