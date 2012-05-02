//
//  SWHelpViewController.m
//  Sketch Integration
//
//  Created by    on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SWHelpViewController.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)

@implementation SWHelpViewController
@synthesize prevButton, nextButton, helpImageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        helpImageIndex = 1;
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
    [rootViewController skipWithAnimation:EaseOut];
    [returnPlayer play];
}

-(IBAction)clickNextButton:(id)sender{
    helpImageIndex++;
    if (helpImageIndex>25) {
        //  nextButton.imageView.image = [UIImage imageNamed:@"beforeButton.png"];
        // UIImage *unNormalImage =[UIImage imageNamed:@"beforeButton.png"];
        //[nextButton setImage:unNormalImage forState:UIControlStateNormal];
        [nextButton setEnabled:NO];
        [prevButton setEnabled:YES];
        [noUsePlayer play];
        //helpImageIndex=0;
    }
    else
        if (helpImageIndex<1) {
            //   prevButton.imageView.image = [UIImage imageNamed:@"nextButton.png"];
            [noUsePlayer play];
            [prevButton setEnabled:NO];
            [nextButton setEnabled:YES];
            // helpImageIndex=0;
        }
        else{
            [slipPlayer play];
            helpImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"helpImageView%d.png",helpImageIndex]];
            [prevButton setEnabled:YES];
            [nextButton setEnabled:YES];
        }
    
}
-(IBAction)clickPrevButton:(id)sender{
    helpImageIndex--;
    if (helpImageIndex>25) {
        //  nextButton.imageView.image = [UIImage imageNamed:@"beforeButton.png"];
        //   helpImageIndex=0;
        [noUsePlayer play];
        [nextButton setEnabled:NO];
        [prevButton setEnabled:YES];
        
    }
    else
        if (helpImageIndex<1) {
            //     prevButton.imageView.image = [UIImage imageNamed:@"nextButton.png"];
            //    helpImageIndex=0;
            [noUsePlayer play];
            [prevButton setEnabled:NO];
            [nextButton setEnabled:YES];
        }
        else{
            helpImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"helpImageView%d.png",helpImageIndex]];
            [slipPlayer play];
            [prevButton setEnabled:YES];
            [nextButton setEnabled:YES];
        }
    
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
                                  stringWithFormat:@"%@/sound_noUse.wav",  [[NSBundle mainBundle]  resourcePath]]];
    noUsePlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载return音效
    noUsePlayer.numberOfLoops  = 0;
    if  (noUsePlayer == nil)      //文件不存在
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
    [noUsePlayer release];
    [slipPlayer release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
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
