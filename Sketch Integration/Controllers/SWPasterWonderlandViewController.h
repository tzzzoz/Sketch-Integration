//
//  SWPasterWonderlandViewController.h
//  SketchWonderLand
//
//  Created by  on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKPasterTemplateLibrary.h"
#import "RootViewController.h"

@interface SWPasterWonderlandViewController : UIViewController{
    //视图对象
    UIImageView *backgroundImageView;
    UIImageView *pasterTemplate0;
    UIImageView *pasterTemplate1;
    UIImageView *pasterTemplate2;
    UIImageView *pasterTemplate3;
    UIImageView *pasterTemplate4;
    UIImageView *pasterTemplate5;
    UIImageView *pasterTemplate6;
    UIImageView *pasterTemplate7;
    UIImageView *pasterTemplate8;
    UIImageView *pasterTemplate9;
    UIImageView *pasterTemplate10;
    UIImageView *pasterTemplate11;
    UIButton *returnButton;
    
    NSMutableArray *pasterViews;
    
    //模型对象
    PKPasterTemplateLibrary *pasterTemplateLibrary;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate0;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate1;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate2;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate3;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate4;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate5;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate6;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate7;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate8;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate9;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate10;
@property (nonatomic, retain) IBOutlet UIImageView *pasterTemplate11;
@property (nonatomic, retain) IBOutlet UIButton *returnButton;

@property (nonatomic, retain)  NSMutableArray *pasterViews;

@property (nonatomic, retain) IBOutlet PKPasterTemplateLibrary *pasterTemplateLibrary;


-(IBAction)returnBack:(id)sender;
-(void)tapPasterImageView:(id)sender;
@end
