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

typedef enum {
    black, 
    red, 
    yellow, 
    lightBlue, 
    grassGreen, 
    purple, 
    brown, 
    lightOrange, 
    lightPurple, 
    roseRed, 
    lightGreen, 
    darkPurple, 
    grey, 
    green, 
    blue, 
    darkBlue, 
    darkGreen, 
    pink
}ColorType;

static const int sizeOfGeoPasterTemplate = 85;
#endif
