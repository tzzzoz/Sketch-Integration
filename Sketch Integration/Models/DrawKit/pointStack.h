//
//  Stack.h
//  fillImage
//
//  Created by apple on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface pointStack : NSObject{
    int top;
    int bottom;
    int topX;
    int topY;
    int size;
    int stack[21];
}
-(void) pushPointAtX:(int)x andY:(int)y;
-(void) popPoint;
-(int) getTopPointX;
-(int) getTopPointY;
-(BOOL) isEmpty;
@end
