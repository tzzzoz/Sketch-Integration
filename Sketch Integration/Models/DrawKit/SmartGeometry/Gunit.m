//
//  Gunit.m
//  Dudel
//
//  Created by tzzzoz on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Gunit.h"

@implementation Gunit

@synthesize start;
@synthesize end;
@synthesize type;
@synthesize isSelected;

- (id)init 
{
    self = [super init];
    if (self) 
    {
        //isSelected = NO;
        start = [[SCPoint alloc]init];
        end   = [[SCPoint alloc]init];
        start.x = 0;
        start.y = 0;
        end.x = 0;
        end.y = 0;
        type  = 0;
    }
    
    return self;
}

-(id)initWithStartPoint:(SCPoint *)s endPoint:(SCPoint *)e 
{
    [super init];
    
    type  = 0;
    start = [[SCPoint alloc]init];
    end   = [[SCPoint alloc]init];
    isSelected=false;
    start.x=s.x;
    start.y=s.y;
    end.x=e.x;
    end.y=e.y;
    
    return self;
}

-(id)initWithPoints:(NSMutableArray *)points 
{
    [super init];
    
    type  = 0;
    start = [[SCPoint alloc]init];
    end   = [[SCPoint alloc]init];
    isSelected=false;
    SCPoint *s;
    SCPoint *e;
    s = [points objectAtIndex:0];
    e = [points lastObject];
    start.x = s.x;
    start.y = s.y;
    end.x = e.x;
    end.y = e.y;
    return self;
}

@end
