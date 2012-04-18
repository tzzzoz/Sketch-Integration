//
//  RootViewController.m
//  Button Fun
//
//  Created by 付 乙荷 on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize viewControllersStack;
@synthesize navigationViewController;
@synthesize pasterWonderlandViewController;
@synthesize drawViewController;
@synthesize drawAlbumViewController;
@synthesize helpViewController;
@synthesize currentViewController;
@synthesize nextViewController;

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

- (id)init
{
    self = [super init];
    if (self) {
        // 从xib文件中读取视图资源，对试图控制器进行初始化
        viewControllersStack = [[NSMutableArray alloc] init];
        navigationViewController = [[SWNavigationViewController alloc] initWithNibName:@"SWNavigationView" bundle:nil];
        //NSLog(@"1retainCount is %d", [currentViewController retainCount]);
        pasterWonderlandViewController = [[SWPasterWonderlandViewController alloc] initWithNibName:@"SWPasterWonderlandView" bundle:nil];
        drawViewController = [[SWDrawViewController alloc] initWithNibName:@"SWDrawView" bundle:nil];
        drawAlbumViewController = [[SWDrawAlbumViewController alloc] initWithNibName:@"SWDrawAlbumView" bundle:nil];
        helpViewController = [[SWHelpViewController alloc] initWithNibName:@"SWHelpView" bundle:nil];
        
        //当前
        currentViewController = nil;
        nextViewController = nil;
        //NSLog(@"2retainCount is %d", [currentViewController retainCount]);        
        [self runWithViewController:navigationViewController];
        //NSLog(@"3retainCount is %d", [currentViewController retainCount]);

        //NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DataOfPasterTemplates" ofType:@"plist"];
        //NSLog(@"%@", plistPath);
    }
    return self;
}

-(void)display {
    NSAssert(nextViewController != nil, @"nextViewController can't be nil");
    currentViewController = nextViewController;
    nextViewController = nil;
    [currentViewController willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft duration:0.5];
    self.view = currentViewController.view;
}


-(void)runWithViewController:(UIViewController*) viewController {
    NSAssert(viewController != nil, @"Argument must be not nil");
    NSAssert(currentViewController == nil, @"You can't run a viewController when the other viewController is running, please use push or replace");
    
    [self pushViewController:viewController];
}


-(void)pushViewController:(UIViewController*) viewController {
    NSAssert(viewController != nil, @"Argument must be not nil");
    
    [viewControllersStack addObject:viewController];
    nextViewController = viewController;
    [self display];
}

-(void)popViewController {
    NSAssert(currentViewController != nil, @"currentViewController is needed");
    
    [viewControllersStack removeLastObject];
    
    NSInteger count = [viewControllersStack count];
    
    if (count == 0) {
        [self viewDidUnload];
    } else {
        nextViewController = [viewControllersStack lastObject];
        [self display];
    }
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
    [self display];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    navigationViewController = nil;
    pasterWonderlandViewController = nil;
    drawViewController = nil;
    drawAlbumViewController = nil;
    helpViewController = nil;
}

-(void)dealloc {
    [super dealloc];
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