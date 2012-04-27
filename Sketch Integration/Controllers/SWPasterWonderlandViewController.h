//
//  SWPasterWonderlandViewController.h
//  SketchWonderLand
//
//  Created by  on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PKPasterTemplateLibrary.h"
#import "RootViewController.h"
#import "UIImageView+DeepCopy.h"

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
    
    UIImageView *selectedImageView;
    CGPoint selectedPosition;
    CGRect selectedRect;
    PKPasterWork *selectedPasterWork;
    PKPasterTemplate *selectedPasterTemplate;
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

@property (nonatomic, retain) UIImageView *selectedImageView;
@property (assign, nonatomic) CGPoint selectedPosition;
@property (assign, nonatomic) CGRect selectedRect;
@property (retain, nonatomic) PKPasterWork *selectedPasterWork;
@property (retain, nonatomic) PKPasterTemplate *selectedPasterTemplate;

@property (nonatomic, retain)  NSMutableArray *pasterViews;

@property (nonatomic, retain) IBOutlet PKPasterTemplateLibrary *pasterTemplateLibrary;


-(IBAction)returnBack:(id)sender;
-(void)tapPasterImageView:(id)sender;
-(void)showSelectedImageView;
-(void)clearSelectedImageView;

@end
