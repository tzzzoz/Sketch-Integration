//
//  SWNavigationViewController.h
//  Sketch Integration
//
//  Created by kwan terry on 12-4-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RootViewController.h"
#import "UnarchiveAlbumThread.h"

@interface SWNavigationViewController : UIViewController {
    //音频
    AVAudioPlayer  *audioPlayer;
    AVAudioPlayer  *jumpPlayer;
}

-(IBAction)pressPasterWonderlandButton:(id)sender;
-(IBAction)pressDrawAlbumButton:(id)sender;
-(IBAction)pressDrawViewButton:(id)sender;
-(IBAction)pressHelpButton:(id)sender;

@end
