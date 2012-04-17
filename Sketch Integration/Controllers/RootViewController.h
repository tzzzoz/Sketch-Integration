//
//  RootViewController.h
//  Button Fun
//
//  Created by 付 乙荷 on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWPasterWonderlandViewController.h"

@interface RootViewController : UIViewController 
{
    SWPasterWonderlandViewController *pasterWonderlandViewController;
    //当前的currentViewController
    UIViewController* currentViewController; 
    //存储viewController的堆栈
    NSMutableArray* viewControllerStack;
}

@property (retain, nonatomic) SWPasterWonderlandViewController *pasterWonderlandViewController;
@property (retain, nonatomic) UIViewController* currentViewController;
@property (retain, nonatomic) NSMutableArray* viewControllerStack;

+(RootViewController*)sharedInstance;



@end
