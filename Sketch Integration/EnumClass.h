//
//  EnumClass.h
//  Sketch
//
//  Created by kwan terry on 12-3-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Sketch_EnumClass_h
#define Sketch_EnumClass_h

typedef enum
{
    Triangle    = 0,
    Trapezium   = 1,
    Ellipse     = 2,
    Pentacle    = 3,
    CirCle      = 4,
    Square      = 5,
    Rectangle   = 6
}GeometryType;

typedef enum
{
    Translation = 0,
    Scale       = 1,
    Rotation    = 2,
    Nothing     = 3
}OperationType;


typedef enum 
{
    black           = 0, 
    red             = 1, 
    yellow          = 2, 
    lightBlue       = 3, 
    grassGreen      = 4, 
    purple          = 5, 
    brown           = 6, 
    lightOrange     = 7, 
    lightPurple     = 8, 
    roseRed         = 9, 
    lightGreen      = 10, 
    darkPurple      = 11, 
    grey            = 12, 
    green           = 13, 
    blue            = 14, 
    darkBlue        = 15, 
    darkGreen       = 16, 
    pink            = 17
}ColorType;

typedef enum
{
    EaseIn = 0,
    EaseOut = 1
}SkipAnimationType;

typedef enum 
{
    PasterState = 0,
    FillState   = 1,
    DrawState   = 2
}DrawViewState;

static const int sizeOfGeoPasterTemplate = 85;

#endif
