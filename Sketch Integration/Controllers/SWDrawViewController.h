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
#import "ImageHelper.h"

@interface SWDrawViewController : UIViewController {
    //视图对象
    UIImageView *pasterView;
    IBOutlet UIView *geoPasterBox;
    UIButton *createPasterButton;
    NSMutableArray *geoPasters;
    IBOutlet UIView *promptDialogView;
    
    //模型对象
    PKPasterTemplate *pasterTemplate;
    PKPasterWork *pasterWork;
    DKDrawBoard *drawBoard;
    PKGeometryPasterLibrary *geoPasterLibrary;
    //涂色
    CGPoint xy;
}

@property (retain, nonatomic) DKDrawBoard *drawBoard;
@property (retain, nonatomic) UIImageView *pasterView;
@property (retain, nonatomic) IBOutlet UIView *geoPasterBox;
@property (retain, nonatomic) UIButton *createPasterButton;
@property (retain, nonatomic) NSMutableArray *geoPasters;
@property (retain, nonatomic) PKPasterTemplate *pasterTemplate;
@property (retain, nonatomic) PKPasterWork *pasterWork;
@property (retain, nonatomic) PKGeometryPasterLibrary *geoPasterLibrary;

//涂色
-(IBAction)buttonPressed:(id)sender;

-(void)setPasterTemplate:(PKPasterTemplate *)tmpPasterTemplate PasterWork:(PKPasterWork *)tmpPasterWork;
-(void)cleanDrawView;
-(IBAction)returnBack:(id)sender;
-(IBAction)pressDrawAlbumButton:(id)sender;
-(IBAction)pressCleanButton:(id)sender;
-(IBAction)pressComfirmButton:(id)sender;
-(IBAction)pressCancelButton:(id)sender;
-(IBAction)pressSaveButton:(id)sender;
-(void)penStateChange;
@end
