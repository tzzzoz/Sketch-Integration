//
//  SWPasterWonderlandViewController.m
//  SketchWonderLand
//
//  Created by  on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SWPasterWonderlandViewController.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)

@implementation SWPasterWonderlandViewController
@synthesize backgroundImageView;
@synthesize pasterTemplate0;
@synthesize pasterTemplate1;
@synthesize pasterTemplate2;
@synthesize pasterTemplate3;
@synthesize pasterTemplate4;
@synthesize pasterTemplate5;
@synthesize pasterTemplate6;
@synthesize pasterTemplate7;
@synthesize pasterTemplate8;
@synthesize pasterTemplate9;
@synthesize pasterTemplate10;
@synthesize pasterTemplate11;
@synthesize returnButton;
@synthesize pasterTemplateViews;
@synthesize pasterTemplateLibrary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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

-(void)tapPasterImageView:(UIGestureRecognizer *) gestureRecognizer {
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController pushViewController:rootViewController.drawViewController];
    UIImageView* skipImageView = (UIImageView*)gestureRecognizer.view;
    pasterTemplateLibrary->selectedPosition = skipImageView.center;
    pasterTemplateLibrary->selectedImageView = skipImageView;
    [rootViewController skipWithImageView:skipImageView Destination:ScreenCenterPoint Animation:EaseIn];
    rootViewController.drawViewController->templateImageView = skipImageView;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化视图对象
    pasterTemplateViews =  [[NSMutableArray alloc] init];
    [pasterTemplateViews addObject:pasterTemplate0];
    [pasterTemplateViews addObject:pasterTemplate1];
    [pasterTemplateViews addObject:pasterTemplate2];
    [pasterTemplateViews addObject:pasterTemplate3];
    [pasterTemplateViews addObject:pasterTemplate4];
    [pasterTemplateViews addObject:pasterTemplate5];
    [pasterTemplateViews addObject:pasterTemplate6];
    [pasterTemplateViews addObject:pasterTemplate7];
    [pasterTemplateViews addObject:pasterTemplate8];
    [pasterTemplateViews addObject:pasterTemplate9];
    [pasterTemplateViews addObject:pasterTemplate10];
    [pasterTemplateViews addObject:pasterTemplate11];
    
    pasterTemplateLibrary = [[PKPasterTemplateLibrary alloc] initWithDataOfPlist];
    
    UIImageView *imageView;
    NSUInteger index = 0;
    for (PKPasterTemplate *pasterTemplate in pasterTemplateLibrary.pasterTemplates) {
        if (pasterTemplate.isModified) {
            PKPasterWork *pasterWork = [pasterTemplateLibrary.pasterWorks objectAtIndex:index];
            [[pasterTemplateViews objectAtIndex:index] addSubview:pasterWork.pasterView];
        } else {
            [[pasterTemplateViews objectAtIndex:index] addSubview:pasterTemplate.pasterView];
        }
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPasterImageView:)];
        imageView = [pasterTemplateViews objectAtIndex:index];
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:singleTap];
        index++;
        [singleTap release];
    }

//    for (int i = 0; i < 12; i++) {
//        UIImageView *imageView = [pasterTemplates objectAtIndex:i];
//        NSString *fileName = [[NSString alloc] initWithFormat:@"pasterTemplate%d.png", i];
//        [imageView setImage:[UIImage imageNamed:fileName]];
//        [fileName release];
//    }
    // Do any additional setup after loading the view from its nib.
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