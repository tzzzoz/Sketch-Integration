//
//  SWHelpViewController.m
//  Sketch Integration
//
//  Created by 付 乙荷 on 12-4-10.
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
}

-(IBAction)clickNextButton:(id)sender{
    helpImageIndex++;
    if (helpImageIndex>4) {
        //  nextButton.imageView.image = [UIImage imageNamed:@"beforeButton.png"];
        // UIImage *unNormalImage =[UIImage imageNamed:@"beforeButton.png"];
        //[nextButton setImage:unNormalImage forState:UIControlStateNormal];
        [nextButton setEnabled:NO];
        [prevButton setEnabled:YES];
        //helpImageIndex=0;
    }
    else
        if (helpImageIndex<1) {
            //   prevButton.imageView.image = [UIImage imageNamed:@"nextButton.png"];
            [prevButton setEnabled:NO];
            [nextButton setEnabled:YES];
            // helpImageIndex=0;
        }
        else{
            helpImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"helpImageView%d.png",helpImageIndex]];
            [prevButton setEnabled:YES];
            [nextButton setEnabled:YES];
        }
    
}
-(IBAction)clickPrevButton:(id)sender{
    helpImageIndex--;
    if (helpImageIndex>4) {
        //  nextButton.imageView.image = [UIImage imageNamed:@"beforeButton.png"];
        //   helpImageIndex=0;
        [nextButton setEnabled:NO];
        [prevButton setEnabled:YES];
        
    }
    else
        if (helpImageIndex<1) {
            //     prevButton.imageView.image = [UIImage imageNamed:@"nextButton.png"];
            //    helpImageIndex=0;
            [prevButton setEnabled:NO];
            [nextButton setEnabled:YES];
        }
        else{
            helpImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"helpImageView%d.png",helpImageIndex]];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
