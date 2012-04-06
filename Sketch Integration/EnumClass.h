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
    Rectangle   = 5,
    Square      = 6
}GeometryType;

typedef enum
{
    Translation = 0,
    Scale       = 1,
    Rotation    = 2,
    Nothing     = 3
}OperationType;

#endif
