//
//  SCPoint.h
//  Dudel
//
//  Created by tzzzoz on 11-12-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCPoint : NSObject
{
    float x,y;
    float originalX;
    float originalY;
    float s,d,c;
    int total;
}

-(id) initWithX:(float) xx andY:(float)yy;
-(float) x;
-(float) y;
-(void) setX:(float) xx;
-(void) setY:(float) yy;
-(void) setTotal:(int)i;

-(void) setOriginalWithSCPoint:(SCPoint *)point;
-(SCPoint *)plus:(SCPoint *)addPoint;
-(void) translationFromPoint:(SCPoint *)vec;
-(void) setOriginal;

@property (readwrite) float x;
@property (readwrite) float y;
@property (readwrite) float originalX;
@property (readwrite) float originalY;
@property (readwrite) float s;
@property (readwrite) float d;
@property (readwrite) float c;
@property (readwrite) int   total;

@end
