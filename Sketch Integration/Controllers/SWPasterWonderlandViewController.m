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

@synthesize selectedImageView;
@synthesize selectedRect;
@synthesize selectedPasterTemplate,selectedPasterWork,selectedPosition;

@synthesize pasterViews;

@synthesize pasterTemplateLibrary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        pasterTemplateLibrary = [[PKPasterTemplateLibrary alloc] initWithDataOfPlist];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void)returnBack:(id)sender 
{
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController popViewController];
    [rootViewController skipWithAnimation:EaseOut];
}

-(void)tapPasterImageView:(UIGestureRecognizer *) gestureRecognizer 
{
    UIImageView *imageView = (UIImageView*)gestureRecognizer.view;
    selectedImageView = imageView;
    
    NSUInteger index = 0;
    for (UIImageView *pasterView in pasterViews) 
    {
        if ([imageView isEqual:pasterView]) 
        {
            break;
        }   
        index++;
    }
    PKPasterTemplate *pasterTemplate = [pasterTemplateLibrary.pasterTemplates objectAtIndex:index];
    PKPasterWork *pasterWork = [pasterTemplateLibrary.pasterWorks objectAtIndex:index];
    
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController pushViewController:rootViewController.drawViewController];
    
    UIImageView* subView = [[imageView.subviews objectAtIndex:0]deepCopy];
    subView.frame = imageView.frame;
    UIImageView* skipImageView = subView;
    
    selectedPosition = skipImageView.center;
    selectedPasterWork = pasterWork;
    selectedPasterTemplate = pasterTemplate;
    
    CGPoint destinationPoint = CGPointMake(549.5, 351);
    [rootViewController skipWithImageView:skipImageView Destination:destinationPoint Animation:EaseIn];
    [self clearSelectedImageView];
}

-(void)showSelectedImageView:(UIImageView*)copyImageView
{
    if(copyImageView == nil)
        return;
    
    UIImageView* subView = [copyImageView deepCopy];
    subView.frame = CGRectMake(0, 0, selectedImageView.frame.size.width, selectedImageView.frame.size.height);
    [selectedImageView addSubview:subView];
}

-(void)clearSelectedImageView
{
    for(UIView* subView in selectedImageView.subviews)
    {
        [subView removeFromSuperview];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化视图对象
    pasterViews =  [[NSMutableArray alloc] init];
    [pasterViews addObject:pasterTemplate0];
    [pasterViews addObject:pasterTemplate1];
    [pasterViews addObject:pasterTemplate2];
    [pasterViews addObject:pasterTemplate3];
    [pasterViews addObject:pasterTemplate4];
    [pasterViews addObject:pasterTemplate5];
    [pasterViews addObject:pasterTemplate6];
    [pasterViews addObject:pasterTemplate7];
    [pasterViews addObject:pasterTemplate8];
    [pasterViews addObject:pasterTemplate9];
    [pasterViews addObject:pasterTemplate10];
    [pasterViews addObject:pasterTemplate11];
    
    UIImageView *imageView;
    NSUInteger index = 0;
    for (PKPasterTemplate *pasterTemplate in pasterTemplateLibrary.pasterTemplates) 
    {
        UIImageView* pasterWorkImageView = [pasterViews objectAtIndex:index];
        PKPasterWork* pasterWork = [pasterTemplateLibrary.pasterWorks objectAtIndex:index];
        UIImageView* subView = [pasterWork.pasterView deepCopy];
        //对pasterWork缩小
        CGAffineTransform transform = CGAffineTransformScale(subView.transform, 288/865.0f, 210/630.0f);
        subView.transform = transform;
        
        subView.frame = CGRectMake(0, 0, pasterWorkImageView.frame.size.width, pasterWorkImageView.frame.size.height);
        [pasterWorkImageView addSubview:subView];

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPasterImageView:)];
        imageView = [pasterViews objectAtIndex:index];
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:singleTap];
        [singleTap release];
        
        index++;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    
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
