//
//  PKPasterWork.h
//  Sketch
//
//  Created by    on 12-4-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKPasterTemplate.h"
#import "PKGeometryPaster.h"

@interface PKPasterWork : NSObject <NSCoding> {
    NSMutableArray *geoPasters;                 //存放几何贴纸对象
    UIImageView *pasterView;                    //存放几何贴纸的view
}

@property (retain, nonatomic) NSMutableArray *geoPasters;
@property (retain, nonatomic) UIImageView *pasterView;

//根据贴纸模板中几何贴纸的个数来初始化geoPasters数组的长度
-(id)initWithPasterTemplate:(PKPasterTemplate *)pasterTemplate;
//将几何贴纸对象添加到贴纸画作中，包括它的view
-(void)insertGeoPaster:(PKGeometryPaster *)geoPaster atIndex:(NSUInteger)index;
//判断贴纸作品完成，符合模板要求
@end
