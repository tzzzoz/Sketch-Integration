//
//  SWDrawViewController.h
//  Sketch Integration
//
//  Created by 付 乙荷 on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKPasterTemplate.h"
#import "RootViewController.h"

@interface SWDrawViewController : UIViewController {
    //视图对象
    UIImageView *pasterView;
    //贴纸模版对象
    @public UIImageView *templateImageView;
    //模型对象
    PKPasterTemplate *pasterTemplate;
}
@property (nonatomic, retain) IBOutlet UIImageView *templateImageView;
@property (retain, nonatomic) UIImageView *pasterView;
@property (retain, nonatomic) PKPasterTemplate *pasterTemplate;

-(IBAction)returnBack:(id)sender;
-(IBAction)pressDrawAlbumButton:(id)sender;

@end
