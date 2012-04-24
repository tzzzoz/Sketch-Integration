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
#import "PKGeometryPasterLibrary.h"

@interface SWDrawViewController : UIViewController {
    //视图对象
    UIImageView *pasterView;
    IBOutlet UIView *geoPasterBox;
    UIButton *createPasterButton;
    NSMutableArray *geoPasters;
    
    //模型对象
    //需要进行编辑的贴纸模板和贴纸作品
    PKPasterTemplate *pasterTemplate;
    PKPasterWork *pasterWork;
    PKGeometryPasterLibrary *geoPasterLibrary;
}

@property (retain, nonatomic) UIImageView *pasterView;
@property (retain, nonatomic) IBOutlet UIView *geoPasterBox;
@property (retain, nonatomic) UIButton *createPasterButton;
@property (retain, nonatomic) NSMutableArray *geoPasters;
@property (retain, nonatomic) PKPasterTemplate *pasterTemplate;
@property (retain, nonatomic) PKPasterWork *pasterWork;
@property (retain, nonatomic) PKGeometryPasterLibrary *geoPasterLibrary;

-(void)setPasterTemplate:(PKPasterTemplate *)tmpPasterTemplate PasterWork:(PKPasterWork *)tmpPasterWork Frame:(CGRect)frame;
-(void)cleanPasterView;
-(IBAction)returnBack:(id)sender;
-(IBAction)pressDrawAlbumButton:(id)sender;
@end
