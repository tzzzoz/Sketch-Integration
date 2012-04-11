//
//  RootViewController.h
//  Button Fun
//
//  Created by 付 乙荷 on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWDrawViewController;
@class SWNavigationViewController;
@class SWPasterWonderlandViewController;
@class SWHelpViewController;
@class SWDrawAlbumViewController;

#import "SWPasterWonderlandViewController.h"
#import "SWNavigationViewController.h"
#import "SWDrawViewController.h"
#import "SWDrawAlbumViewController.h"
#import "SWHelpViewController.h"

@interface RootViewController : UIViewController {
    SWNavigationViewController *navigationViewController;
    SWPasterWonderlandViewController *pasterWonderlandViewController;
    SWDrawViewController *drawViewController;
    SWDrawAlbumViewController *drawAlbumViewController;
    SWHelpViewController *helpViewController;
}

//Singleton method
+(RootViewController *)sharedRootViewController;

@property (retain, nonatomic) SWNavigationViewController *navigationViewController;
@property (retain, nonatomic) SWPasterWonderlandViewController *pasterWonderlandViewController;
@property (retain, nonatomic) SWDrawViewController *drawViewController;
@property (retain, nonatomic) SWDrawAlbumViewController *drawAlbumViewController;
@property (retain, nonatomic) SWHelpViewController *helpViewController;

@end
