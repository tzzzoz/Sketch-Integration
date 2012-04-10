//
//  SWPasterWonderlandViewController.m
//  SketchWonderLand
//
//  Created by  on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SWPasterWonderlandViewController.h"
#import "RootViewController.h"
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

@synthesize array;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
	return YES;
}

@end
