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

@synthesize geoPasterButtonArray;
@synthesize geoPasterButton0;
@synthesize geoPasterButton1;
@synthesize geoPasterButton2;
@synthesize geoPasterButton3;
@synthesize geoPasterButton4;
@synthesize geoPasterButton5;
@synthesize geoPasterButton6;
@synthesize pasterView;

@synthesize pasterTemplate;
@synthesize pasterWork;
@synthesize geoPasterLibrary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pasterView = [[UIImageView alloc] init];
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

-(void)returnBack:(id)sender
{
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController popViewController];
    UIImageView* skipImageView = [pasterView deepCopy];
    [rootViewController skipWithImageView:skipImageView Destination:rootViewController.pasterWonderlandViewController.selectedPosition Animation:EaseOut];
    [self cleanPasterView];
}

-(void)pressDrawAlbumButton:(id)sender 
{
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
    
    geoPasterLibrary = [[PKGeometryPasterLibrary alloc]initWithDataOfPlist];
    
    geoPasterButtonArray = [[NSMutableArray alloc]initWithCapacity:7];
    [geoPasterButtonArray addObject:geoPasterButton0];
    [geoPasterButtonArray addObject:geoPasterButton1];
    [geoPasterButtonArray addObject:geoPasterButton2];
    [geoPasterButtonArray addObject:geoPasterButton3];
    [geoPasterButtonArray addObject:geoPasterButton4];
    [geoPasterButtonArray addObject:geoPasterButton5];
    [geoPasterButtonArray addObject:geoPasterButton6];
    
    for(int i=0; i<7; i++)
    {
        UIButton* geoPasterButton = [geoPasterButtonArray objectAtIndex:i];
        PKGeometryPasterTemplate* tmpGeoTemplate = [geoPasterLibrary.geometryPasterTemplates objectAtIndex:i];
//        PKGeometryPaster* tmpGeoPaster = [geoPasterLibrary.geometryPasters objectAtIndex:i];
        if(!tmpGeoTemplate.isModified)
        {
            [geoPasterButton setImage:tmpGeoTemplate.geoTemplateImageView.image  forState:UIControlStateNormal];
        }
        else
        {
//           [geoPasterButton setImage:tmpGeoPaster.geoPasterImageView.image  forState:UIControlEventAllEvents]; 
        }
    }
}

- (void)viewDidUnload
{
    [self setGeoPasterButton0:nil];
    [self setGeoPasterButton1:nil];
    [self setGeoPasterButton2:nil];
    [self setGeoPasterButton3:nil];
    [self setGeoPasterButton4:nil];
    [self setGeoPasterButton5:nil];
    [self setGeoPasterButton6:nil];
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

- (void)dealloc {
    [geoPasterButton0 release];
    [geoPasterButton1 release];
    [geoPasterButton2 release];
    [geoPasterButton3 release];
    [geoPasterButton4 release];
    [geoPasterButton5 release];
    [geoPasterButton6 release];
    [super dealloc];
}
@end
