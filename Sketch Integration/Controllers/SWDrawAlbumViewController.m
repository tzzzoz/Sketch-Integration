//
//  SWDrawAlbumViewController.m
//  Sketch Integration
//
//  Created by    on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SWDrawAlbumViewController.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)

@implementation SWDrawAlbumViewController

@synthesize pasterWorkShows;

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

-(void)returnBack:(id)sender {
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController popViewController];
    [returnPlayer play];
}

-(void)deleteButtonPressed:(id)sender{
    [deletePlayer play];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //加载音频文件
    NSURL  *url = [NSURL fileURLWithPath:[NSString  
                                          stringWithFormat:@"%@/sound_slip.wav",  [[NSBundle mainBundle]  resourcePath]]];
    NSError  *error;
    slipPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
    slipPlayer.numberOfLoops  = 0;
    if  (slipPlayer == nil)      //文件不存在
        printf("音频加载失败");
    
    url = [NSURL fileURLWithPath:[NSString  
                                  stringWithFormat:@"%@/sound_returnButton.wav",  [[NSBundle mainBundle]  resourcePath]]];
    returnPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载return音效
    returnPlayer.numberOfLoops  = 0;
    if  (returnPlayer == nil)      //文件不存在
        printf("音频加载失败");
    
    url = [NSURL fileURLWithPath:[NSString  
                                  stringWithFormat:@"%@/sound_deleteButton.wav",  [[NSBundle mainBundle]  resourcePath]]];
    deletePlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载return音效
    deletePlayer.numberOfLoops  = 0;
    if  (deletePlayer == nil)      //文件不存在
        printf("音频加载失败");
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    [returnPlayer release];
    [slipPlayer release];
    [deletePlayer release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
        self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
    } else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
        self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
    }
}

@end
