//
//  UIPasterView.m
//  Sketch Integration
//
//  Created by kwan terry on 12-4-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIPasterView.h"

@implementation UIPasterView

@synthesize beginPoint;
@synthesize rotationTransform,translationTransform,scaleTransform;
@synthesize selectedGeoImageView,pasterTemplateImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self becomeFirstResponder];
        [self setBackgroundColor:[[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"pasterview  touch!!!");
    
    beginPoint = [[touches anyObject]locationInView:self];
    
    if(selectedGeoImageView == nil)
    {
        for(UIImageView* imageView in self.subviews)
        {
            if(![imageView isKindOfClass:[PKGeometryImageView class]])
                continue;
            else
            {
                if(CGRectContainsPoint(imageView.frame, beginPoint))
                {
                    selectedGeoImageView = (PKGeometryImageView*)imageView;
                    
                    self.rotationTransform = selectedGeoImageView.transform;
                    self.translationTransform = selectedGeoImageView.transform;
                    self.scaleTransform = selectedGeoImageView.transform;
                }
            }
        }
        if(selectedGeoImageView == nil)
            return;
    }
    
    if(!selectedGeoImageView.isGeometrySelected)
    {
        if(CGRectContainsPoint(selectedGeoImageView.frame, beginPoint))
        {
            selectedGeoImageView.isGeometrySelected = YES;
            selectedGeoImageView.operationType = Translation;
            
            self.rotationTransform = selectedGeoImageView.transform;
            self.translationTransform = selectedGeoImageView.transform;
            self.scaleTransform = selectedGeoImageView.transform;
        }
        else
        {
            selectedGeoImageView.isGeometrySelected = NO;
            selectedGeoImageView.operationType = Nothing;
            selectedGeoImageView = nil;
        }
    }
    else
    {
        CGRect rotationSelectRect = CGRectMake(selectedGeoImageView.rotationPoint.x-9, selectedGeoImageView.rotationPoint.y-9, 18, 18);
        CGRect scaleSelectRect[4];
        scaleSelectRect[0] = CGRectMake(selectedGeoImageView.leftTopPoint.x-6, selectedGeoImageView.leftTopPoint.y-6, 12, 12);
        scaleSelectRect[1] = CGRectMake(selectedGeoImageView.rightTopPoint.x-6, selectedGeoImageView.rightTopPoint.y-6, 12, 12);
        scaleSelectRect[2] = CGRectMake(selectedGeoImageView.rightBottomPoint.x-6, selectedGeoImageView.rightBottomPoint.y-6, 12, 12);
        scaleSelectRect[3] = CGRectMake(selectedGeoImageView.leftBottomPoint.x-6, selectedGeoImageView.leftBottomPoint.y-6, 12, 12);
        if(CGRectContainsPoint(rotationSelectRect, beginPoint))
        {
            selectedGeoImageView.operationType = Rotation;
        }
        else if(CGRectContainsPoint(scaleSelectRect[0], beginPoint) ||
                CGRectContainsPoint(scaleSelectRect[1], beginPoint) ||
                CGRectContainsPoint(scaleSelectRect[2], beginPoint) ||
                CGRectContainsPoint(scaleSelectRect[3], beginPoint))
        {
            selectedGeoImageView.operationType = Scale;
        }
        else if(CGRectContainsPoint(selectedGeoImageView.frame, beginPoint))
        {
            selectedGeoImageView.operationType = Translation;
        }
        else
        {
            selectedGeoImageView.isGeometrySelected = NO;
            selectedGeoImageView.operationType = Nothing;
            selectedGeoImageView = nil;
        }
        
    }
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:self];
    CGPoint prevPoint = [[touches anyObject]previousLocationInView:self];
    
    if(selectedGeoImageView.isGeometrySelected && selectedGeoImageView.operationType == Rotation)
    {
        CGPoint vector1 = CGPointMake(prevPoint.x-selectedGeoImageView.centerPoint.x, prevPoint.y-selectedGeoImageView.centerPoint.y);
        CGPoint vector2 = CGPointMake(point.x-selectedGeoImageView.centerPoint.x, point.y-selectedGeoImageView.centerPoint.y);
        float angle1 = atan2f(vector1.x, vector1.y);
        float angle2 = atan2f(vector2.x, vector2.y);
        float rotationAngle = -(angle2-angle1);
        self.rotationTransform = CGAffineTransformRotate(self.rotationTransform, rotationAngle);
        selectedGeoImageView.transform = self.rotationTransform;
        selectedGeoImageView.geometryTransfrom = self.rotationTransform;
        [selectedGeoImageView calulateFourCorners];
        
        [self setNeedsDisplay];
        return;
    }
    if(selectedGeoImageView.isGeometrySelected && selectedGeoImageView.operationType == Translation)
    {
        CGPoint vector = CGPointMake(point.x-prevPoint.x, point.y-prevPoint.y);
        self.translationTransform = CGAffineTransformConcat(self.translationTransform, CGAffineTransformMakeTranslation(vector.x, vector.y));
        selectedGeoImageView.transform = self.translationTransform;
        selectedGeoImageView.geometryTransfrom = self.translationTransform;
        [selectedGeoImageView calulateFourCorners];
        
        [self setNeedsDisplay];
        return;
    }
    if(selectedGeoImageView.isGeometrySelected && selectedGeoImageView.operationType == Scale)
    {
        CGPoint vector1 = CGPointMake(prevPoint.x-selectedGeoImageView.centerPoint.x, prevPoint.y-selectedGeoImageView.centerPoint.y);
        CGPoint vector2 = CGPointMake(point.x-selectedGeoImageView.centerPoint.x, point.y-selectedGeoImageView.centerPoint.y);
        float len1 = sqrtf(vector1.x*vector1.x + vector1.y*vector1.y);
        float len2 = sqrtf(vector2.x*vector2.x + vector2.y*vector2.y);
        float scaleFactor = len2/len1;
        self.scaleTransform = CGAffineTransformScale(self.scaleTransform, scaleFactor, scaleFactor);
        selectedGeoImageView.transform = self.scaleTransform;
        selectedGeoImageView.geometryTransfrom = self.scaleTransform;
        [selectedGeoImageView calulateFourCorners];
        
        [self setNeedsDisplay];
        return;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:self];
    if(!CGRectContainsPoint(self.bounds, point) && selectedGeoImageView.operationType == Translation)
    {
        isFoul = YES;
        CGPoint vector = CGPointMake(beginPoint.x-point.x, beginPoint.y-point.y);
        self.translationTransform = CGAffineTransformConcat(self.translationTransform, CGAffineTransformMakeTranslation(vector.x, vector.y));
        
        [UIView animateWithDuration:0.5f animations:^(void) {
            selectedGeoImageView.transform = self.translationTransform;
        } completion:^(BOOL finished) {
            selectedGeoImageView.geometryTransfrom = self.translationTransform;
            [selectedGeoImageView calulateFourCorners];
            isFoul = NO;
        }];
        
    }
    
    self.rotationTransform = selectedGeoImageView.transform;
    self.translationTransform = selectedGeoImageView.transform;
    self.scaleTransform = selectedGeoImageView.transform;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(selectedGeoImageView.isGeometrySelected && !isFoul)
        [selectedGeoImageView drawFrameWithContext:context];
}

@end
