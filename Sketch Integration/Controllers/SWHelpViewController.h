//
//  SWHelpViewController.h
//  Sketch Integration
//
//  Created by    on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RootViewController.h"

@interface SWHelpViewController : UIViewController{
    UIButton *prevButton;
    UIButton *nextButton;
    
    UIImageView *helpImageView;
    
    NSInteger helpImageIndex;
    //音频
    AVAudioPlayer *returnPlayer;
    AVAudioPlayer *slipPlayer;
    AVAudioPlayer *noUsePlayer;
}

@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIImageView *helpImageView;



-(IBAction)clickNextButton:(id)sender;
-(IBAction)clickPrevButton:(id)sender;

-(IBAction)returnBack:(id)sender;
@end
