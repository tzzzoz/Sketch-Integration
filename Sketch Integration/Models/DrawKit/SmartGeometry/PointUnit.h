//
//  PointUnit.h
//  Dudel
//
//  Created by tzzzoz on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gunit.h"

@interface PointUnit : Gunit {
    
}

-(id) initWithPoint:(SCPoint*)a;
-(id) initWithPoints:(NSMutableArray*)points;
-(void) drawWithContext:(CGContextRef)context;
-(void) setOriginal;
@end
