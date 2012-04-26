//
//  SWDrawAlbumViewController.h
//  Sketch Integration
//
//  Created by 付 乙荷 on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface SWDrawAlbumViewController : UIViewController {
    //模型对象
    NSMutableArray *pasterWorkShows;
}

@property (retain, nonatomic) NSMutableArray *pasterWorkShows;

-(IBAction)returnBack:(id)sender;

@end
