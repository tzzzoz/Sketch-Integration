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

@interface SWDrawAlbumViewController : UIViewController {
    //模型对象
    NSMutableArray *pasterWorkShows;
    //音频
    AVAudioPlayer *returnPlayer;
    AVAudioPlayer *slipPlayer;
    AVAudioPlayer *deletePlayer;
}

@property (retain, nonatomic) NSMutableArray *pasterWorkShows;

-(IBAction)returnBack:(id)sender;
-(IBAction)deleteButtonPressed:(id)sender;
@end
