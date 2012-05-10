//
//  SWDrawAlbumViewController.h
//  Sketch Integration
//
//  Created by    on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RootViewController.h"
#import "AFOpenFlowView.h"
#import "ArchiveAlbumThread.h"
#import "UnarchiveAlbumThread.h"

@interface SWDrawAlbumViewController : UIViewController <AFOpenFlowViewDelegate> {
    //模型对象
    NSMutableArray *workShows;
    NSMutableArray *workShowsDate;
    //音频
    AVAudioPlayer *returnPlayer;
    AVAudioPlayer *slipPlayer;
    AVAudioPlayer *deletePlayer;
    AVAudioPlayer *cancelPlayer;
    AVAudioPlayer *promptPlayer;
    //提示框
    UIView *promptDialogView;
    //视图层
    NSMutableArray *workShowViews;
    
    AFOpenFlowView *flowView;
    NSInteger deleteViewNumber;
    BOOL isDeleted;
    
    NSOperationQueue *operationQueue;
}

@property (retain, nonatomic) NSMutableArray *pasterWorkShows;
@property (retain, nonatomic) AFOpenFlowView *flowView;
@property (retain, nonatomic) NSOperationQueue *operationQueue;
@property (retain, nonatomic) NSMutableArray *workShows;
@property (retain, nonatomic) NSMutableArray *workShowViews;
@property (retain, nonatomic) NSMutableArray *workShowsDate;

-(IBAction)returnBack:(id)sender;
-(IBAction)deleteButtonPressed:(id)sender;
-(void)setDrawWorkWithPasterWork:(PKPasterWork *) pasterWork PasterWorkName:(NSString*)date pasterImageWork:(UIImage*) pasterWorkImage;
-(void)saveDrawAlbum;
-(void)initDataFromArchiver;
-(void)loadFlowView;
@end
