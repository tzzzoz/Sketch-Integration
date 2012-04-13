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

@synthesize pasterTemplates;

@synthesize pasterTemplateLibrary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        pasterTemplateLibrary = [[PKPasterTemplateLibrary alloc] initWithDataOfPlist];
//        for (PKPasterTemplate *pasterTemplate in pasterTemplateLibrary.pasterTemplates) {
//            if (pasterTemplate.isModified) {
//                [self.view addSubview:pasterTemplate.pasterView];
//                NSLog(@"Can you see me?");
//            }
//        }
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
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    pasterTemplates =  [[NSMutableArray alloc] init];
    [pasterTemplates addObject:pasterTemplate0];
    [pasterTemplates addObject:pasterTemplate1];
    [pasterTemplates addObject:pasterTemplate2];
    [pasterTemplates addObject:pasterTemplate3];
    [pasterTemplates addObject:pasterTemplate4];
    [pasterTemplates addObject:pasterTemplate5];
    [pasterTemplates addObject:pasterTemplate6];
    [pasterTemplates addObject:pasterTemplate7];
    [pasterTemplates addObject:pasterTemplate8];
    [pasterTemplates addObject:pasterTemplate9];
    [pasterTemplates addObject:pasterTemplate10];
    [pasterTemplates addObject:pasterTemplate11];
    for (int i = 0; i < 12; i++) {
        UIImageView *imageView = [pasterTemplates objectAtIndex:i];
        NSString *fileName = [[NSString alloc] initWithFormat:@"pasterTemplate%d.png", i];
        [imageView setImage:[UIImage imageNamed:fileName]];
        [fileName release];
    }
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
