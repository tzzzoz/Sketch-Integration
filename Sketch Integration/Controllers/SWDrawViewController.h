//
//  SWDrawViewController.h
//  Sketch Integration
//
//  Created by 付 乙荷 on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKPasterTemplate.h"
#import "PKGeometryPasterLibrary.h"
#import "UIImage+NSCoder.h"
#import "RootViewController.h"

@interface SWDrawViewController : UIViewController {
    //视图对象
    UIImageView *pasterView;
    
    //模型对象
    PKPasterTemplate *pasterTemplate;
    PKPasterWork *pasterWork;
    
    //模型层对象，几何贴纸库
    PKGeometryPasterLibrary* geoPasterLibrary;
    
    NSMutableArray* geoPasterButtonArray;
    UIButton *geoPasterButton0;
    UIButton *geoPasterButton1;
    UIButton *geoPasterButton2;
    UIButton *geoPasterButton3;
    UIButton *geoPasterButton4;
    UIButton *geoPasterButton5;
    UIButton *geoPasterButton6;
}
@property (nonatomic, retain) NSMutableArray* geoPasterButtonArray;
@property (nonatomic, retain) IBOutlet UIButton *geoPasterButton0;
@property (nonatomic, retain) IBOutlet UIButton *geoPasterButton1;
@property (nonatomic, retain) IBOutlet UIButton *geoPasterButton2;
@property (nonatomic, retain) IBOutlet UIButton *geoPasterButton3;
@property (nonatomic, retain) IBOutlet UIButton *geoPasterButton4;
@property (nonatomic, retain) IBOutlet UIButton *geoPasterButton5;
@property (nonatomic, retain) IBOutlet UIButton *geoPasterButton6;

@property (retain, nonatomic) UIImageView *pasterView;
@property (retain, nonatomic) PKPasterTemplate *pasterTemplate;
@property (retain, nonatomic) PKPasterWork *pasterWork;
@property (retain, nonatomic) PKGeometryPasterLibrary *geoPasterLibrary;

-(void)setPasterTemplate:(PKPasterTemplate *)tmpPasterTemplate PasterWork:(PKPasterWork *)tmpPasterWork Frame:(CGRect)frame;
-(void)cleanPasterView;
-(IBAction)returnBack:(id)sender;
-(IBAction)pressDrawAlbumButton:(id)sender;
@end

