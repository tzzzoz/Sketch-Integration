//
//  fillImage.m
//  fillImage
//
//  Created by apple on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "FillImage.h"

@implementation FillImage

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [myStack init];
    }
    
    return self;
}
- (id)initWithImage:(UIImage *)i{
    self = [super init];
    if (self) {
        // Initialization code here.
        image=i;
        width=[image size].width;
        height=[image size].height;
        imageData=[ImageHelper convertUIImageToBitmapRGBA8:image];  //获取图片的data
    }
    return self;
}
-(UIImage *)getImage{
    image=[ImageHelper convertBitmapRGBA8ToUIImage:imageData withWidth:width withHeight:height];
    return image;
}
-(BOOL)isIndexValid:(int)x andY:(int)y{
    if(x>=0&&x<width&&y<height&&y>=0)
        return true;
    else
        return false;
    
}
-(BOOL)isPixelValid:(int)x andY:(int)y{
    if([self isIndexValid:x andY:y]){
        int red = imageData[(y*width+x)*4]*1;
        int green = imageData[(y*width+x)*4+1]*1;
        int blue = imageData[(y*width+x)*4+2]*1;
        int alpha = imageData[(y*width+x)*4+3]*1;
        if ((boundaryColor.red==red&&boundaryColor.green==green&&boundaryColor.blue==blue&&boundaryColor.alpha==alpha)) {
            return true;
        }
        else{
            return false;
        }
    }
    else
        return false;
}
-(int) FillLineLeft:(int)x andY:(int)y{
    int count=0;
    for (;[self isIndexValid:x andY:y]&&[self isPixelValid:x andY:y];x--)
    {
        //AM[x, y] = tc
        imageData[(y*width+x)*4]=targetColor.red;
        imageData[(y*width+x)*4+1]=targetColor.green;
        imageData[(y*width+x)*4+2]=targetColor.blue;
        imageData[(y*width+x)*4+3]=targetColor.alpha;
        count++;
    }
    return count;
}
-(int) FillLineRight:(int)x andY:(int)y{
    int count=0;
    for (;[self isIndexValid:x andY:y]&&[self isPixelValid:x andY:y];x++)
    {
        imageData[(y*width+x)*4]=targetColor.red;
        imageData[(y*width+x)*4+1]=targetColor.green;
        imageData[(y*width+x)*4+2]=targetColor.blue;
        imageData[(y*width+x)*4+3]=targetColor.alpha;
        count++;
    }
    return count;
}
-(int) SkipInvalidInLine:(int) x andY:(int) y andxRight:(int) xRight
{
    int span = 0;
    int i = 0;
    for (; x < xRight; i++,x++)
        if ([self isPixelValid:x andY:y])
            break;
    if ([self isPixelValid:x andY:y])
        span += i;
    return span;
}
-(void) SearchLineNewSeed:(int)xLeft andXRight:(int)xRight andY:(int) y
{
    int xt = xLeft;
    bool findNewSeed = false;
    while (xt <= xRight)
    {
        findNewSeed = false;
        while ([self isPixelValid:xt andY:y]&& (xt < xRight))
        {
            findNewSeed = true;
            xt++;
        }
        if (findNewSeed)
        {
            if ([self isPixelValid:xt andY:y] && (xt == xRight)){
                [myStack pushPointAtX:xt andY:y];
            }
            else{
                [myStack pushPointAtX:xt-1 andY:y];
            }
        }
        //向右跳过内部的无效点（处理区间右端有障碍点的情况）
        int xspan = [self SkipInvalidInLine:xt andY:y andxRight:xRight];
        xt += (xspan == 0) ? 1 : xspan;
        //处理特殊情况,以退出while(x<=xright)循环
    }
}
-(void) ScanLineSeedFill:(int)x andY:(int)y withTC:(ColorRGBA)tc
{
    myStack=[[MyPointStack alloc] init];
    targetColor=tc;
    if([self isIndexValid:x andY:y]){
    boundaryColor.red = imageData[(y*width+x)*4]*1;
    boundaryColor.green = imageData[(y*width+x)*4+1]*1;
    boundaryColor.blue = imageData[(y*width+x)*4+2]*1;
    boundaryColor.alpha = imageData[(y*width+x)*4+3]*1;
    }
    else return;
    [myStack pushPointAtX:x andY:y];//第1步，种子点入站
    while(![myStack isEmpty])
    {
        [myStack popPoint]; //第2步，取当前种子点
        int seedX=[myStack getTopPointX];
        int seedY=[myStack getTopPointY];
        //第3步，向左右填充
        int count = [self FillLineRight:seedX andY:seedY];//向右填充
        int xRight = seedX + count - 1;
        count = [self FillLineLeft:seedX-1 andY:seedY];//向左填充
        int xLeft = seedX - count;
        //第4步，处理相邻两条扫描线
        [self SearchLineNewSeed:xLeft andXRight:xRight andY:seedY-1];
        [self SearchLineNewSeed:xLeft andXRight:xRight andY:seedY+1];
    }
    [myStack release];
}
-(void)changeColor:(int)x andY:(int)y withTC:(ColorRGBA)tc{        //对几何贴纸更改颜色
    targetColor=tc;
    if([self isIndexValid:x andY:y]){
        boundaryColor.alpha=imageData[(y*width+x)*4+3]*1;
    }
    if(boundaryColor.alpha!=0)
        for(int i=0;i<height;i++)
            for(int j=0;j<width;j++)
                if(imageData[(i*width+j)*4+3]!=0){
                    imageData[(i*width+j)*4]=targetColor.red;
                    imageData[(i*width+j)*4+1]=targetColor.green;
                    imageData[(i*width+j)*4+2]=targetColor.blue;
                    imageData[(i*width+j)*4+3]=targetColor.alpha;
                }
}
-(void)dealloc{
    [super dealloc];
}
@end
