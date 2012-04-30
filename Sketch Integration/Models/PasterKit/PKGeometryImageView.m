//
//  PKGeometryImageView.m
//  Sketch
//
//  Created by 付 乙荷 on 12-3-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKGeometryImageView.h"

@implementation PKGeometryImageView

@synthesize leftTopPoint,rightTopPoint,rightBottomPoint,leftBottomPoint;
@synthesize isGeometrySelected;
@synthesize leftTopPointOriginal,rightTopPointOriginal,rigthBottomPointOriginal,leftBottomPointOriginal;
@synthesize rotationPoint;
@synthesize centerPointOriginal,centerPoint;
@synthesize geometryTransfrom,operationType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        operationType = Nothing;
        isGeometrySelected = NO;
        geometryTransfrom = self.transform;
        [self initFourCorners];
        
    }
    return self;
}

-(void)initFourCorners
{
    leftTopPoint  = CGPointMake(self.frame.origin.x, self.frame.origin.y);
    rightTopPoint = CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y);
    leftBottomPoint = CGPointMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height);
    rightBottomPoint = CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y+self.frame.size.height);
    centerPoint = self.center;
    CGPoint middlePoint = CGPointMake((leftTopPoint.x+rightTopPoint.x)/2, (leftTopPoint.y+rightTopPoint.y)/2);
    rotationPoint = CGPointMake(3*middlePoint.x/2-self.center.x/2, 3*middlePoint.y/2-self.center.y/2);
    
    leftTopPointOriginal = leftTopPoint;
    rightTopPointOriginal = rightTopPoint;
    leftBottomPointOriginal = leftBottomPoint;
    rigthBottomPointOriginal = rightBottomPoint;
    centerPointOriginal = self.center;
}

-(void)calulateFourCorners
{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-self.center.x, -self.center.y);
    transform = CGAffineTransformConcat(transform, self.geometryTransfrom);
    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(self.center.x, self.center.y);
    transform = CGAffineTransformConcat(transform, transform1);
    
    leftTopPoint     = CGPointApplyAffineTransform(leftTopPointOriginal, transform);
    rightTopPoint    = CGPointApplyAffineTransform(rightTopPointOriginal, transform);
    rightBottomPoint = CGPointApplyAffineTransform(rigthBottomPointOriginal, transform);
    leftBottomPoint  = CGPointApplyAffineTransform(leftBottomPointOriginal, transform);
    centerPoint = CGPointApplyAffineTransform(centerPointOriginal, transform);
    
    CGPoint middlePoint = CGPointMake((leftTopPoint.x+rightTopPoint.x)/2, (leftTopPoint.y+rightTopPoint.y)/2);
    rotationPoint = CGPointMake(3*middlePoint.x/2-centerPoint.x/2, 3*middlePoint.y/2-centerPoint.y/2);
}

-(void)drawFrameWithContext:(CGContextRef)context
{
    for (int i=0; i<4; i++) 
    {
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextSetLineWidth(context, 1.0f);
        switch(i)
        {
            case 0:
            {
                CGContextMoveToPoint(context, leftTopPoint.x, leftTopPoint.y);
                CGContextAddLineToPoint(context, rightTopPoint.x, rightTopPoint.y);
                CGContextStrokePath(context);
                break;
            }
            case 1:
            {
                CGContextMoveToPoint(context, rightTopPoint.x, rightTopPoint.y);
                CGContextAddLineToPoint(context, rightBottomPoint.x, rightBottomPoint.y);
                CGContextStrokePath(context);
                break;
            }
            case 2:
            {
                CGContextMoveToPoint(context, rightBottomPoint.x, rightBottomPoint.y);
                CGContextAddLineToPoint(context, leftBottomPoint.x, leftBottomPoint.y);
                CGContextStrokePath(context);
                break;
            }
            case 3:
            {
                CGContextMoveToPoint(context, leftBottomPoint.x, leftBottomPoint.y);
                CGContextAddLineToPoint(context, leftTopPoint.x, leftTopPoint.y);
                CGContextStrokePath(context);
                break;
            }
        }
    }
    UIImage* pointImage = [UIImage imageNamed:@"controlPointScale.png"];
    [pointImage drawAtPoint:CGPointMake(leftTopPoint.x-6, leftTopPoint.y-6)];
    [pointImage drawAtPoint:CGPointMake(rightTopPoint.x-6, rightTopPoint.y-6)];
    [pointImage drawAtPoint:CGPointMake(rightBottomPoint.x-6, rightBottomPoint.y-6)];
    [pointImage drawAtPoint:CGPointMake(leftBottomPoint.x-6, leftBottomPoint.y-6)];
    
    CGPoint middlePoint = CGPointMake((leftTopPoint.x+rightTopPoint.x)/2, (leftTopPoint.y+rightTopPoint.y)/2);
    CGContextMoveToPoint(context, middlePoint.x, middlePoint.y);
    CGContextAddLineToPoint(context, rotationPoint.x, rotationPoint.y);
    CGContextStrokePath(context);
    pointImage = [UIImage imageNamed:@"controlPointRotation.png"];
    [pointImage drawAtPoint:CGPointMake(rotationPoint.x-9, rotationPoint.y-9)];    
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.frame = [aDecoder decodeCGRectForKey:@"frame"];
        self.isGeometrySelected = [aDecoder decodeBoolForKey:@"isGeometrySelected"];
        self.leftTopPoint = [aDecoder decodeCGPointForKey:@"leftTopPoint"];
        self.rightTopPoint = [aDecoder decodeCGPointForKey:@"rightTopPoint"];
        self.leftBottomPoint = [aDecoder decodeCGPointForKey:@"leftBottomPoint"];
        self.rightBottomPoint = [aDecoder decodeCGPointForKey:@"rightBottomPoint"];
        self.rotationPoint = [aDecoder decodeCGPointForKey:@"rotationPoint"];
        self.centerPoint = [aDecoder decodeCGPointForKey:@"centerPoint"];
        
        self.geometryTransfrom = [aDecoder decodeCGAffineTransformForKey:@"geometryTransfrom"];
        self.operationType = [aDecoder decodeIntForKey:@"operationType"];
        
        self.leftTopPointOriginal = [aDecoder decodeCGPointForKey:@"leftTopPointOriginal"];
        self.rightTopPointOriginal = [aDecoder decodeCGPointForKey:@"rightTopPointOriginal"];
        self.leftBottomPointOriginal = [aDecoder decodeCGPointForKey:@"leftBottomPointOriginal"];
        self.rigthBottomPointOriginal = [aDecoder decodeCGPointForKey:@"rigthBottomPointOriginal"];
        self.centerPointOriginal = [aDecoder decodeCGPointForKey:@"centerPointOriginal"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeCGRect:self.frame forKey:@"frame"];
    [aCoder encodeBool:isGeometrySelected forKey:@"isGeometrySelected"];
    [aCoder encodeCGPoint:leftTopPoint forKey:@"leftTopPoint"];
    [aCoder encodeCGPoint:rightTopPoint forKey:@"rightTopPoint"];
    [aCoder encodeCGPoint:leftBottomPoint forKey:@"leftBottomPoint"];
    [aCoder encodeCGPoint:rightBottomPoint forKey:@"rightBottomPoint"];
    [aCoder encodeCGPoint:rotationPoint forKey:@"rotationPoint"];
    [aCoder encodeCGPoint:centerPoint forKey:@"centerPoint"];
    
    [aCoder encodeCGAffineTransform:geometryTransfrom forKey:@"geometryTransfrom"];
    [aCoder encodeInt:operationType forKey:@"operationType"];
    
    [aCoder encodeCGPoint:leftTopPointOriginal forKey:@"leftTopPointOriginal"];
    [aCoder encodeCGPoint:rightTopPointOriginal forKey:@"rightTopPointOriginal"];
    [aCoder encodeCGPoint:leftBottomPointOriginal forKey:@"leftBottomPointOriginal"];
    [aCoder encodeCGPoint:rigthBottomPointOriginal forKey:@"rigthBottomPointOriginal"];
    [aCoder encodeCGPoint:centerPointOriginal forKey:@"centerPointOriginal"];
}

-(id)deepCopy {
    PKGeometryImageView *geoImageView = [super deepCopy];
    if (geoImageView) {
        geoImageView.leftTopPoint = leftTopPoint;
        geoImageView.rightTopPoint = rightTopPoint;
        geoImageView.leftBottomPoint = leftBottomPoint;
        geoImageView.rightBottomPoint = rightBottomPoint;
        geoImageView.rotationPoint = rotationPoint;
        geoImageView.centerPoint = centerPoint;
        
        geoImageView.geometryTransfrom = geometryTransfrom;
        geoImageView.operationType = operationType;

        geoImageView.leftTopPointOriginal = leftTopPointOriginal;
        geoImageView.rightTopPointOriginal = rightTopPointOriginal;
        geoImageView.leftBottomPointOriginal = leftBottomPointOriginal;
        geoImageView.rigthBottomPointOriginal = rigthBottomPointOriginal;
        geoImageView.centerPointOriginal = centerPointOriginal;
    }
    return geoImageView;
}

@end
