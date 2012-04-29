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
#import "DKDrawBoard.h"
#import "PKGeometryPasterLibrary.h"
#import "fillImage.h"
#import "UIPasterView.h"
#import "ImageHelper.h"

@interface SWDrawViewController : UIViewController {
    //视图对象
    UIPasterView *pasterView;
    IBOutlet UIView *geoPasterBox;
    IBOutlet UIButton *createPasterButton;
    NSMutableArray *geoPasters;
    IBOutlet UIView *promptDialogView;
    
    //模型对象
    //需要进行编辑的贴纸模板和贴纸作品
    PKPasterTemplate *pasterTemplate;
    PKPasterWork *pasterWork;
    DKDrawBoard *drawBoard;
    PKGeometryPasterLibrary *geoPasterLibrary;
    //涂色
    CGPoint xy;
}

@property (retain, nonatomic) DKDrawBoard *drawBoard;
@property (retain, nonatomic) UIPasterView *pasterView;
@property (retain, nonatomic) IBOutlet UIView *geoPasterBox;
@property (retain, nonatomic) IBOutlet UIButton *createPasterButton;
@property (retain, nonatomic) NSMutableArray *geoPasters;
@property (retain, nonatomic) PKPasterTemplate *pasterTemplate;
@property (retain, nonatomic) PKPasterWork *pasterWork;
@property (retain, nonatomic) PKGeometryPasterLibrary *geoPasterLibrary;

@property (retain, nonatomic) PKGeometryImageView* selectedGeoImageView;
@property (assign, nonatomic) CGPoint beginPoint;
@property (assign, nonatomic) CGAffineTransform rotationTransform;
@property (assign, nonatomic) CGAffineTransform translationTransform;
@property (assign, nonatomic) CGAffineTransform scaleTransform;
//涂色
//-(IBAction)buttonPressed:(id)sender;

-(void)setPasterTemplate:(PKPasterTemplate *)tmpPasterTemplate PasterWork:(PKPasterWork *)tmpPasterWork Frame:(CGRect)frame;
-(void)cleanPasterView;
-(IBAction)returnBack:(id)sender;
-(IBAction)pressDrawAlbumButton:(id)sender;
-(void)tapGeoImageView:(UIGestureRecognizer*)gestureRecognizer;
//-(IBAction)pressCleanButton:(id)sender;
//-(IBAction)pressComfirmButton:(id)sender;
//-(IBAction)pressCancelButton:(id)sender;
//-(IBAction)pressSaveButton:(id)sender;
//-(void)penStateChange;
@end
