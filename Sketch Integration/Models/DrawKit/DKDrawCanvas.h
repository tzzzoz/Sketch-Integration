//
//  DKDrawCanvas.h
//  Sketch Integration
//
//  Created by  on 12-4-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BroadView.h"


@interface DKDrawCanvas : NSObject{
    UIImageView *drawCanvasView;
//    NSMutableArray *strokes;
//    NSMutableArray *points;
}

@property (retain, nonatomic) UIImageView *drawCanvasView;

@end
