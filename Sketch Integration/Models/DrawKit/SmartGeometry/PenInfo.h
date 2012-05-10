//
//  PenInfo.h
//  Dudel
//
//  Created by tzzzoz on 11-12-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPoint.h"
@interface PenInfo : NSObject
{
    NSMutableArray *points;
}
@property (retain) NSMutableArray *points;

- (id) initWithPoints:(NSMutableArray*) temp;
- (NSMutableArray*) oldPenInfo;
- (NSMutableArray*) newPenInfo;

@end
