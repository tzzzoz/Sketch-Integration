//
//  Stack.m
//  fillImage
//
//  Created by apple on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyPointStack.h"

@implementation MyPointStack

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        int i;
        size=20;
        for (i=0;i<=size;i++)
            stack[i]=0;
        top=bottom=0;
    }
    
    return self;
}

-(void)pushPointAtX:(int)x andY:(int)y{
    if ((top-bottom)>=size)//栈满
    {
        return ;
    }
    stack[++top]=x;
    stack[++top]=y;
    return;
}

-(int)getTopPointX{
    return topX;
}

-(int)getTopPointY{
    return topY;
}

-(void)popPoint{
    if (top ==bottom)
        return;
    topY=stack[top--];
    topX=stack[top--];
    return;
}

-(BOOL)isEmpty{
    if (top==bottom)
        return YES;
    else
        return NO;
}
@end
