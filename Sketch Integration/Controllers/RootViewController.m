//
//  RootViewController.m
//  Button Fun
//
//  Created by    on 12-4-5.
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
@synthesize starImageView;

static  RootViewController *_sharedRootViewController = nil;
static int controlIndex = 0;

const CGPoint ScreenCenterPoint = {1024/2,768/2};
const CGPoint ScreenLeftPoint   = {-1024/2,768/2};
const CGPoint ScreenRightPoint  = {1024+1024/2,768/2};

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
        pasterWonderlandViewController = [[SWPasterWonderlandViewController alloc] initWithNibName:@"SWPasterWonderlandView" bundle:nil];
        drawViewController = [[SWDrawViewController alloc] initWithNibName:@"SWDrawView" bundle:nil];
        drawAlbumViewController = [[SWDrawAlbumViewController alloc] initWithNibName:@"SWDrawAlbumView" bundle:nil];
        helpViewController = [[SWHelpViewController alloc] initWithNibName:@"SWHelpView" bundle:nil];
        
        //当前
        currentViewController = nil;
        nextViewController = nil;       
        [self runWithViewController:navigationViewController];
        currentViewController = navigationViewController;
    }
    return self;
}

-(void)display {
    NSAssert(nextViewController != nil, @"nextViewController can't be nil");
//    [currentViewController willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft duration:0.5];
    nextViewController.view.layer.opacity = 1.0f;
    [self.view addSubview:nextViewController.view];
    [nextViewController viewWillAppear:YES];
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

-(void)skipWithAnimation:(SkipAnimationType)animation
{
    if(animation == EaseIn)
    {
        [nextViewController.view setCenter:ScreenRightPoint];
    }
    else if(animation == EaseOut)
    {
        [nextViewController.view setCenter:ScreenLeftPoint];
    }
    
    nextViewController.view.layer.opacity = 0.0f;
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^(void)
     {
         currentViewController.view.layer.opacity = 0.0f;
         
         nextViewController.view.center = ScreenCenterPoint;
         nextViewController.view.layer.opacity = 1.0f;
     }completion:^(BOOL finished)
     {
         [currentViewController.view removeFromSuperview];
         currentViewController = nextViewController;
         nextViewController = nil;
     }];
    
}

-(void)skipWithImageView:(UIImageView *)imageView Destination:(CGPoint)destinationPoint Animation:(SkipAnimationType)animation
{
    UIImageView* skipImageView = imageView;
    [self.view addSubview:skipImageView];
    CGAffineTransform transform;
    
    if(animation == EaseIn && [nextViewController isKindOfClass:[SWDrawViewController class]] && [currentViewController isKindOfClass:[SWPasterWonderlandViewController class]])
    {
        [nextViewController.view setCenter:ScreenRightPoint];
        transform = CGAffineTransformScale(skipImageView.transform, 865/288.0f, 630/210.0f);
//        transform = CGAffineTransformMakeScale(865/288.0f, 630/210.0f);
//        transform = CGAffineTransformMakeScale(3.0, 3.0);
    }
    else if(animation == EaseOut && [nextViewController isKindOfClass:[SWPasterWonderlandViewController class]] && [currentViewController isKindOfClass:[SWDrawViewController class]])
    {
        [nextViewController.view setCenter:ScreenLeftPoint];
        transform = CGAffineTransformScale(skipImageView.transform, 288/865.0f, 210/630.0f);
//        transform = CGAffineTransformMakeScale(288/865.0f, 210/630.0f);
    }
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^(void)
     {
         currentViewController.view.layer.opacity = 0.0f;
         
         skipImageView.center = destinationPoint;
         skipImageView.transform = transform;
         
         nextViewController.view.center = ScreenCenterPoint;
         nextViewController.view.layer.opacity = 1.0f;
     }completion:^(BOOL finished)
     {
         if(animation == EaseOut && [nextViewController isKindOfClass:[SWPasterWonderlandViewController class]] && [currentViewController isKindOfClass:[SWDrawViewController class]])
         {
             [(SWPasterWonderlandViewController*)nextViewController showSelectedImageView:skipImageView];
             
             starImageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"star_8.png"]autorelease]];
             starImageView.center = destinationPoint;
             [self.view addSubview:starImageView];
             [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(showStarAnimation:) userInfo:nil repeats:YES];
             [drawViewController savePasterWork];
             [drawViewController->tonePlayer[10] play];
         }
         else if(animation == EaseIn && [nextViewController isKindOfClass:[SWDrawViewController class]] && [currentViewController isKindOfClass:[SWPasterWonderlandViewController class]])
         {
             SWPasterWonderlandViewController* wonderLandController = (SWPasterWonderlandViewController*)currentViewController;
             SWDrawViewController* drawController = (SWDrawViewController*)nextViewController;
             [drawController setPasterTemplate:wonderLandController.selectedPasterTemplate PasterWork:wonderLandController.selectedPasterWork Frame:skipImageView.frame];
             [skipImageView removeFromSuperview];
         }
         
         [currentViewController.view removeFromSuperview];
         currentViewController = nextViewController;
         nextViewController = nil;
     }];
}

-(void)showStarAnimation:(NSTimer *)timer
{
    if(controlIndex == 8)
    {
        controlIndex = 0;
        [starImageView removeFromSuperview];
        [timer invalidate];
    }
    
    NSString* imageName = [NSString stringWithFormat:@"star_%d.png",8-controlIndex];
    UIImage*  tempImage = [UIImage imageNamed:imageName];
    starImageView.image = tempImage;
    controlIndex++;
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
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc {
    [navigationViewController release];
    [pasterWonderlandViewController release];
    [drawViewController release];
    [drawAlbumViewController release];
    [helpViewController release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
