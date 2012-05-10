//
//  SWNavigationViewController.m
//  Sketch Integration
//
//  Created by    on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SWNavigationViewController.h"

@implementation SWNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)pressPasterWonderlandButton:(id)sender {
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController pushViewController:[rootViewController pasterWonderlandViewController]];
    [rootViewController skipWithAnimation:EaseIn];
    [jumpPlayer play];
}

-(void)pressDrawViewButton:(id)sender {
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController pushViewController:[rootViewController drawViewController]];
    [rootViewController skipWithAnimation:EaseIn];
    [jumpPlayer play];
}

-(void)pressDrawAlbumButton:(id)sender {
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController pushViewController:[rootViewController drawAlbumViewController]];
    [rootViewController skipWithAnimation:EaseIn];
    [jumpPlayer play];
}

-(void)pressHelpButton:(id)sender {
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController pushViewController:[rootViewController helpViewController]];
    [rootViewController skipWithAnimation:EaseIn];
    [jumpPlayer play];

}
#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL  *url = [NSURL fileURLWithPath:[NSString  
                                          stringWithFormat:@"%@/sound_navigationView.mp3",  [[NSBundle mainBundle]  resourcePath]]];
    NSError  *error;
    audioPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];    //加载背景音乐
    audioPlayer.numberOfLoops  = -1;
    audioPlayer.volume=0.3;   //音量设置
    if  (audioPlayer == nil)      //文件不存在
        printf("音频加载失败");    
    else                          //文件存在
        [audioPlayer  play];           //播放背景音乐
    url = [NSURL fileURLWithPath:[NSString  
                                  stringWithFormat:@"%@/sound_pageJump.wav",  [[NSBundle mainBundle]  resourcePath]]];
    
    jumpPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
    jumpPlayer.numberOfLoops  = 0;
    if  (jumpPlayer == nil)      //文件不存在
        printf("音频加载失败");
    
    //开了一个线程负责加载数据
    NSOperationQueue *operationQueue = [[[NSOperationQueue alloc] init] autorelease];
    UnarchiveAlbumThread *unarchiveAlbumThread = [[[UnarchiveAlbumThread alloc] init] autorelease];
    [operationQueue addOperation:unarchiveAlbumThread];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)dealloc {
    [audioPlayer release];
    [jumpPlayer release];
    [super dealloc];
}

@end
