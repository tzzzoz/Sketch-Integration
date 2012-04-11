//
//  RootViewController.m
//  Button Fun
//
//  Created by 付 乙荷 on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize navigationViewController;
@synthesize pasterWonderlandViewController;
@synthesize drawViewController;
@synthesize drawAlbumViewController;
@synthesize helpViewController;

static  RootViewController *_sharedRootViewController = nil;

+ (RootViewController *) sharedRootViewController {
    if (!_sharedRootViewController) {
        _sharedRootViewController = [[self alloc] init];
    }
    return _sharedRootViewController;
}

+(id)alloc {
    NSAssert(_sharedRootViewController == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        navigationViewController = [[SWNavigationViewController alloc] initWithNibName:@"SWNavigationView" bundle:nil];
        pasterWonderlandViewController = [[SWPasterWonderlandViewController alloc] initWithNibName:@"SWPasterWonderlandView" bundle:nil];
        drawViewController = [[SWDrawViewController alloc] initWithNibName:@"SWDrawView" bundle:nil];
        drawAlbumViewController = [[SWDrawAlbumViewController alloc] initWithNibName:@"SWDrawAlbumView" bundle:nil];
        helpViewController = [[SWHelpViewController alloc] initWithNibName:@"SWHelpView" bundle:nil];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DataOfPasterTemplates" ofType:@"plist"]; 
        NSLog(@"%@", plistPath);
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
    self.view = navigationViewController.view;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [navigationViewController release];
    [pasterWonderlandViewController release];
    [drawViewController release];
    [drawAlbumViewController release];
    [helpViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
