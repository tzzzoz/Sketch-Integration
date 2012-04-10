//
//  RootViewController.h
//  Button Fun
//
//  Created by 付 乙荷 on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWPasterWonderlandViewController.h"

@interface RootViewController : UIViewController {
    SWPasterWonderlandViewController *pasterWonderlandViewController;
    
}

+(RootViewController *)sharedRootViewController;

@property (retain, nonatomic) SWPasterWonderlandViewController *pasterWonderlandViewController;

@end
