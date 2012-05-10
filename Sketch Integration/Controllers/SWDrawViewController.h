//
//  SWDrawViewController.h
//  Sketch Integration
//
//  Created by    on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EnumClass.h"
#import "PKPasterTemplate.h"
#import "RootViewController.h"
#import "DKDrawBoard.h"
#import "PKGeometryPasterLibrary.h"
#import "fillImage.h"
#import "UIPasterView.h"
#import "UIImageView+DeepCopy.h"
#import "ImageHelper.h"

@interface SWDrawViewController : UIViewController 
{    
////////////绘画界面有三种状态/////////////////
    DrawViewState drawViewState;
    
//////////关于贴纸操作的相关全局变量////////////
    //视图层对象
    UIPasterView *pasterView;
    IBOutlet UIView *geoPasterBox;
    IBOutlet UIButton *createPasterButton;
    NSMutableArray *geoPasters;
    PKGeometryImageView* selectedGeoImageView;
    CGRect selectedRectOriginal;
    //模型对象
    //需要进行编辑的贴纸模板和贴纸作品
    PKGeometryPasterLibrary *geoPasterLibrary;
    PKPasterTemplate *pasterTemplate;
    PKPasterWork *pasterWork;
    
/////////提示框相关全局变量/////////////////////
    UIView *promptDialogView;
    UIButton *undoButton;
    UIButton *redoButton;
    
//////////关于画板的相关全局变量////////////    
    //模型层对象
    DKDrawBoard *drawBoard;
    //视图层对象
    NSMutableArray *colorImageViewArray;
    UIImageView *selectedColorImageView;
    
//////////音频对象///////////////////////////
    @public
    AVAudioPlayer  *tonePlayer[13];
    AVAudioPlayer  *colorPlayer[18];
    AVAudioPlayer  *geoPlayer[7];
}

@property (assign, nonatomic) DrawViewState     drawViewState;

@property (retain, nonatomic) DKDrawBoard*      drawBoard;
@property (retain, nonatomic) NSMutableArray*   colorImageViewArray;
@property (retain, nonatomic) UIImageView*      selectedColorImageView;

@property (retain, nonatomic) UIPasterView*     pasterView;
@property (retain, nonatomic) IBOutlet UIView*  geoPasterBox;
@property (retain, nonatomic) IBOutlet UIButton*    createPasterButton;
@property (retain, nonatomic) NSMutableArray*   geoPasters;
@property (retain, nonatomic) PKPasterTemplate* pasterTemplate;
@property (retain, nonatomic) PKPasterWork*     pasterWork;
@property (retain, nonatomic) PKGeometryPasterLibrary*  geoPasterLibrary;
@property (retain, nonatomic) PKGeometryImageView*      selectedGeoImageView;

@property (retain, nonatomic) UIView *promptDialogView;

@property (nonatomic, retain) IBOutlet UIButton *undoButton;
@property (nonatomic, retain) IBOutlet UIButton *redoButton;

//////////////////////加载声音///////////////////////////
-(void)loadSound;

/////////////////////geoPasterBox与colorImageViewArray切换////////////////
-(void)hideGeoPasterBox;
-(void)displayGeoPasterBox;
-(void)hideColorImageViewArray;
-(void)displayColorImageViewArray;
//点击颜色响应函数
-(void)tapColorImageView:(UIGestureRecognizer *) gestureRecognizer;

/////////////////////与跳转有关//////////////////////////
-(void)setViewStateFromNavigationView;
//初始化贴纸作品
-(void)setPasterTemplate:(PKPasterTemplate *)tmpPasterTemplate PasterWork:(PKPasterWork *)tmpPasterWork Frame:(CGRect)frame;
//清空pasterView
-(void)cleanPasterView;
//保存
-(void)savePasterWork;
-(void)updateGeoPasterToPaster;

////////////////////响应控件函数/////////////////////////
-(IBAction)returnBack:(id)sender;
-(IBAction)pressDrawAlbumButton:(id)sender;
-(IBAction)pressSaveButton:(id)sender;
//-(IBAction)pressCleanButton:(id)sender;
//-(IBAction)pressComfirmButton:(id)sender;
//-(IBAction)pressCancelButton:(id)sender;
- (IBAction)pressUndo:(id)sender;
- (IBAction)pressRedo:(id)sender;

- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;

@end
