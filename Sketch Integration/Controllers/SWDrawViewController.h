//
//  SWDrawViewController.h
//  Sketch Integration
//
//  Created by    on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PKPasterTemplate.h"
#import "RootViewController.h"
#import "DKDrawBoard.h"
#import "PKGeometryPasterLibrary.h"
#import "fillImage.h"
#import "UIPasterView.h"
#import "UIImageView+DeepCopy.h"
#import "ImageHelper.h"

@interface SWDrawViewController : UIViewController {
    //视图对象
    UIPasterView *pasterView;
    //显示贴纸模版的imageview
    UIImageView* pasterImageView;
    IBOutlet UIView *geoPasterBox;
    IBOutlet UIButton *createPasterButton;
    NSMutableArray *geoPasters;
    
    PKGeometryImageView* selectedGeoImageView;
    CGRect selectedRectOriginal;
//    IBOutlet UIView *promptDialogView;
    
    //提示框
    UIImageView *promptDialogView;
    UIButton *comfirmButton;
    UIButton *cancelButton;
    UILabel *promptText;
    
    //模型对象
    //需要进行编辑的贴纸模板和贴纸作品
    PKPasterTemplate *pasterTemplate;
    PKPasterWork *pasterWork;
    DKDrawBoard *drawBoard;
    PKGeometryPasterLibrary *geoPasterLibrary;
    
    //    画笔
    NSMutableArray *penArray;
    UIImageView *selectedImageView;
    //涂色
    CGPoint xy;
    
    //音频对象
    AVAudioPlayer  *tonePlayer[13];
    AVAudioPlayer *colorPlayer[18];
    AVAudioPlayer  *geoPlayer[7];

}

@property (retain, nonatomic) DKDrawBoard *drawBoard;
@property (retain, nonatomic) UIPasterView *pasterView;
@property (retain, nonatomic) UIImageView* pasterImageView;
@property (retain, nonatomic) IBOutlet UIView *geoPasterBox;
@property (retain, nonatomic) IBOutlet UIButton *createPasterButton;
@property (retain, nonatomic) NSMutableArray *geoPasters;
@property (retain, nonatomic) PKPasterTemplate *pasterTemplate;
@property (retain, nonatomic) PKPasterWork *pasterWork;
@property (retain, nonatomic) PKGeometryPasterLibrary *geoPasterLibrary;
@property (retain, nonatomic) PKGeometryImageView* selectedGeoImageView;
@property (retain, nonatomic) UIImageView *promptDialogView;
@property (nonatomic, retain) NSMutableArray *penArray;
@property (nonatomic, retain) UIImageView *selectedImageView;

//涂色
//-(IBAction)buttonPressed:(id)sender;

-(void)initPen;
-(void)loadSound;

-(void)hiddenGeoPasterBox;
-(void)displayGeoPasterBox;
-(void)setPasterTemplate:(PKPasterTemplate *)tmpPasterTemplate PasterWork:(PKPasterWork *)tmpPasterWork Frame:(CGRect)frame;
-(void)cleanPasterView;
-(IBAction)returnBack:(id)sender;
-(IBAction)pressDrawAlbumButton:(id)sender;
-(void)tapGeoImageView:(UIGestureRecognizer*)gestureRecognizer;
-(void)savePasterWork;
-(void)updateGeoPasterToPaster;
//-(IBAction)pressCleanButton:(id)sender;
//-(IBAction)pressComfirmButton:(id)sender;
//-(IBAction)pressCancelButton:(id)sender;
-(IBAction)pressSaveButton:(id)sender;
//-(void)penStateChange;
@end
