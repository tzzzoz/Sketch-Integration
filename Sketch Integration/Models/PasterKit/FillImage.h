//
//  FillImage.h
//  fillImage
//  填充类
//  Created by apple on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPointStack.h"
#import "ImageHelper.h"

typedef struct ColorRGBAStruct{
    int red;
    int green;
    int blue;
    int alpha;
}ColorRGBA;

@interface FillImage : NSObject{
    int width;
    int height;
    struct ColorRGBAStruct targetColor;
    struct ColorRGBAStruct boundaryColor;
    UIImage *image;
    MyPointStack *myStack;
    unsigned char *imageData;
}


- (id)initWithImage:(UIImage *)i;
- (UIImage *)getImage;
-(void) changeColor:(int)x andY:(int)y withTC:(ColorRGBA) tc;
-(BOOL) isPixelValid:(int)x andY:(int)y;
-(BOOL) isIndexValid:(int)x andY:(int)y; 
-(int) FillLineRight:(int)x andY:(int)y;
-(int) FillLineLeft:(int)x andY:(int)y;
-(int) SkipInvalidInLine:(int) x andY:(int) y andxRight:(int) xRight;
-(void) SearchLineNewSeed:(int)xLeft andXRight:(int)xRight andY:(int) y;
-(void) ScanLineSeedFill:(int)x andY:(int)y withTC:(ColorRGBA)tc;
@end
