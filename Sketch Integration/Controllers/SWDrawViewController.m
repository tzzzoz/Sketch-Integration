//
//  SWDrawViewController.m
//  Sketch Integration
//
//  Created by 付 乙荷 on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SWDrawViewController.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)

@implementation SWDrawViewController

@synthesize pasterView;
@synthesize geoPasterBox;
@synthesize createPasterButton;
@synthesize geoPasters;
@synthesize pasterTemplate;
@synthesize pasterWork;
@synthesize geoPasterLibrary;

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

-(void)setPasterTemplate:(PKPasterTemplate *)tmpPasterTemplate PasterWork:(PKPasterWork *)tmpPasterWork Frame:(CGRect)frame
{
    self.pasterTemplate = tmpPasterTemplate;
    self.pasterWork = tmpPasterWork;
    pasterView = [[UIImageView alloc]initWithFrame:frame];
    pasterView.contentMode = UIViewContentModeScaleToFill;
    if(pasterTemplate.isModified)
    {
        UIImageView* subView = [pasterTemplate.pasterView deepCopy];
        subView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        [pasterView addSubview:subView];
    }
    else
    {
        UIImageView* subView = [pasterWork.pasterView deepCopy];
        subView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        [pasterView addSubview:subView];
    }
    [self.view addSubview:pasterView];
}

-(void)returnBack:(id)sender {
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController popViewController];
    UIImageView* skipImageView = [pasterView deepCopy];
    [rootViewController skipWithImageView:skipImageView Destination:rootViewController.pasterWonderlandViewController.selectedPosition Animation:EaseOut];
    [self cleanPasterView];
}

-(void)pressDrawAlbumButton:(id)sender {
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController pushViewController:[rootViewController drawAlbumViewController]];
    [self cleanPasterView];
}

-(void)cleanPasterView 
{
    for (UIView *view in pasterView.subviews) 
    {
        [view removeFromSuperview];
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
    
    pasterView = [[UIImageView alloc] init];
    geoPasterLibrary = [[PKGeometryPasterLibrary alloc] initWithDataOfPlist];
    geoPasters = [[NSMutableArray alloc] initWithCapacity:geoPasterLibrary.geometryPasterTemplates.count];
    
    for (PKGeometryPaster *geoPasterTemplate in geoPasterLibrary.geometryPasters) {
        [self.geoPasterBox addSubview:geoPasterTemplate.geoPasterImageView];
    }
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

-(void)dealloc {
    [super dealloc];
    [pasterView release];
    [geoPasterLibrary release];
    [geoPasters release];
}

@end