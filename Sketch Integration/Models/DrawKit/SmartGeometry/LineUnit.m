//
//  LineUnit.m
//  Dudel
//
//  Created by tzzzoz on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LineUnit.h"

@implementation LineUnit

@synthesize k,b,isCutLine,cutPoint;

- (id)init
{
    self = [super init];
    if (self) 
    {
        type=1;// 直 线 类 型 
        start.x=0;
        start.y=0;
        end.x=0;
        end.y=0;
        isCutLine = NO;
        self.isSelected = NO;
        [self setOriginal];
    }
    
    return self;
}

-(id)initWithPoints:(NSMutableArray *)points 
{
    self = [super init];
    isCutLine = NO;
    self.isSelected = NO;
    SCPoint *s;
    SCPoint *e;
    s = [points objectAtIndex:0];
    e = [points lastObject];
    
    type=1;
    start.x=s.x;
    start.y=s.y;
    end.x=e.x;
    end.y=e.y;
    isCutLine = NO;
    self.isSelected = NO;
    [self setOriginal];
    [self calculateK_B];
    return self;
}

-(id)initWithStartPoint:(SCPoint *)s endPoint:(SCPoint *)e 
{
    type=1;
    start=s;
    end=e;
    isCutLine = NO;
    self.isSelected = NO;
    [self calculateK_B];
    [self setOriginal];
    return self;
}

-(void) setOriginal 
{
    [start setOriginal];
    [end setOriginal];
    if(isCutLine)
    {
        [cutPoint setOriginal];
    }
}

-(BOOL)judge:(NSMutableArray *)pList {
    int number=[pList count];
    int x_sum=0;
    int y_sum=0;
    double x_aver=0;
    double y_aver=0;
    double lxy=0;
    double lxx=0;
    double lyy=0;
    double p=0;
    SCPoint *point;
    
    for (int i=0;i<number;i++)
    {
        point = [pList objectAtIndex:i];
        x_sum+=point.x;
        y_sum+=point.y;
    }
    x_aver=x_sum/number;
    y_aver=y_sum/number;
    for(int i=0;i<number;i++)
    {
        point = [pList objectAtIndex:i];
        lxy+=(point.x-x_aver)*(point.y-y_aver);
        lxx+=(point.x-x_aver)*(point.x-x_aver);         // 计 算 方 差
        lyy+=(point.y-y_aver)*(point.y-y_aver);
    }
    
    p=lxy/(sqrt(lxx*lyy));
    if ((p > judge_line_value) || p < -judge_line_value)// 在 阀 值 内 可 以 拟 合 为 直 线
    {
        return true;
    }
    return false;
}

-(void)setstart:(SCPoint *)newstart {
    start=newstart;
    [self calculateK_B];
}

-(void)setstartX:(float)newstart_x Y:(float)newstart_y {
    start.x=newstart_x;
    start.y=newstart_y;
    [self calculateK_B];
}

-(void)setend:(SCPoint *)newend {
    end=newend;
    [self calculateK_B];
}

-(void)setendX:(float)newend_x Y:(float)newend_y {
    end.x=newend_x;
    end.y=newend_y;
    [self calculateK_B];
}

-(void)calculateK_B {
    if (start.x==end.x)
    {
        k=MAX_K;
        b=-(double)start.x;
    }
    else
    {
        k=(end.y-start.y)/(end.x-start.x+0.0000000001);
        b=(double)start.y-k*(double)start.x;
    }
}

-(double)OriginalB {
    return (double)start.originalY- [self OriginalK]*(double)start.originalX;
}

-(double)OriginalK {
    return (end.originalY-start.originalY)/(end.originalX-start.originalX+0.00000000001);
}

-(void)drawWithContext:(CGContextRef)context
{
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    CGContextStrokePath(context);
}

@end
