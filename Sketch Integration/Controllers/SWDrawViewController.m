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
@synthesize geoPasters;
@synthesize createPasterButton;
@synthesize pasterTemplate;
@synthesize pasterWork;
@synthesize drawBoard;
@synthesize geoPasterLibrary;
@synthesize selectedGeoImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        pasterView = [[UIPasterView alloc]initWithFrame:CGRectMake(108, 36, 865, 630)];
        pasterView.contentMode = UIViewContentModeScaleToFill;
        // Custom initialization
        geoPasterLibrary = [[PKGeometryPasterLibrary alloc] initWithDataOfPlist];
        geoPasters = [[NSMutableArray alloc] initWithCapacity:geoPasterLibrary.geometryPasters.count];
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
    
    //pasterView加入贴纸作品
    UIImageView* subView = [[UIImageView alloc]initWithImage:tmpPasterWork.pasterView.image];
    [self.pasterView addSubview:subView];
    [subView release];
    
    for(PKGeometryImageView* geoImageView in tmpPasterWork.pasterView.subviews)
    {
        if([geoImageView isKindOfClass:[PKGeometryImageView class]])
        {
            [self.pasterView addSubview:[geoImageView deepCopy]];
        }
    }
    
    
    [self.view addSubview:pasterView];
}


-(void) updateModel {
//    PKGeometryPaster *geoPaster;
//    [self.pasterWork.geoPasters ]
}


-(void)returnBack:(id)sender 
{
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController popViewController];
    
    [geoPasterLibrary saveDataToDoc:NO];
    
    UIImageView* skipImageView = [[UIImageView alloc]initWithFrame:pasterView.frame];
    for(UIImageView* imageView in pasterView.subviews)
    {
        if([imageView isKindOfClass:[PKGeometryImageView class]])
            [skipImageView addSubview:[imageView deepCopy]];
        else
            skipImageView.image = imageView.image;
    }
    
    [rootViewController skipWithImageView:skipImageView Destination:rootViewController.pasterWonderlandViewController.selectedPosition Animation:EaseOut];

    [skipImageView release];
    [self savePasterWork];
    [self cleanPasterView];
}

-(void)savePasterWork {
    [self.geoPasterLibrary saveDataToDoc:NO];
    PKPasterTemplateLibrary *tmpPasterTemplateLibrary =  [[[RootViewController sharedRootViewController] pasterWonderlandViewController] pasterTemplateLibrary];
    tmpPasterTemplateLibrary.isModified = YES;
    [tmpPasterTemplateLibrary saveDataToDoc:NO];
}

-(void)pressDrawAlbumButton:(id)sender {
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController pushViewController:[rootViewController drawAlbumViewController]];
    [self cleanPasterView];
}


-(IBAction)pressCleanButton:(id)sender{
    promptDialogView.hidden = NO;
}
-(IBAction)pressComfirmButton:(id)sender{
    promptDialogView.hidden = YES;
    //    drawBoard.drawCanvasView.view = nil;
    self.drawBoard.drawCanvas.drawCanvasView.image = nil;
}
-(IBAction)pressCancelButton:(id)sender{
    promptDialogView.hidden = YES;
}

-(IBAction)pressSaveButton:(id)sender{
    UIImageView *savedWork = [[UIImageView alloc] initWithFrame:CGRectMake(180.0f, 100.0f, 512.0f, 512.0f)];
    //    [savedWork setImage:[UIImage imageNamed:@"backgroundImageViewDAV.png"]];
    //    savedWork.image = pasterView.image;
    //    [savedWork setImage:];
    
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:3];
    [UIImageView setAnimationBeginsFromCurrentState:YES];
    savedWork.frame = CGRectMake(0.0, 504.0, 0.0, 0.0);
    [UIImageView commitAnimations];
    [self.view addSubview:savedWork];
    
    [savedWork release];
}


-(void)cleanPasterView 
{
    for (UIView *view in pasterView.subviews) 
    {
        [view removeFromSuperview];
    }
    [pasterView removeFromSuperview];
}

-(void)tapGeoImageView:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView* imageView = (PKGeometryImageView*)gestureRecognizer.view;
    int index = 0;
    for(UIImageView* tmpImageView in geoPasterBox.subviews)
    {
        if([tmpImageView isEqual:imageView])
        {
            break;
        }
        index++;
    }
    NSLog(@"tap!");
    PKGeometryPaster* geoPaster = [geoPasterLibrary.geometryPasters objectAtIndex:index];
    PKGeometryImageView* geoPasterView = (PKGeometryImageView*)[geoPaster.geoPasterImageView deepCopy];
    [self.view addSubview:geoPasterView];
    [geoPasterView release];
}

#pragma mark - touch respond

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"controller  touch!!!");
    CGPoint beginPoint = [[touches anyObject]locationInView:self.geoPasterBox];
    
    for(PKGeometryImageView* geoTmp in geoPasters)
    {
        if(CGRectContainsPoint(geoTmp.frame, beginPoint))
        {
            selectedGeoImageView = [geoTmp deepCopy];
            selectedGeoImageView.frame = CGRectMake(geoPasterBox.frame.origin.x+selectedGeoImageView.frame.origin.x, geoPasterBox.frame.origin.y+selectedGeoImageView.frame.origin.y, selectedGeoImageView.frame.size.width, selectedGeoImageView.frame.size.height);
            selectedRectOriginal = selectedGeoImageView.frame;
            [self.view addSubview:selectedGeoImageView];
            
            CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)];
            scaleAnimation.duration = 0.1f;
            scaleAnimation.fillMode = kCAFillModeForwards;
            [selectedGeoImageView.layer addAnimation:scaleAnimation forKey:@"scale"];
            
            selectedGeoImageView.frame = CGRectMake(0, 0, selectedGeoImageView.frame.size.width*1.5, selectedGeoImageView.frame.size.height*1.5);
            selectedGeoImageView.center = CGPointMake(geoPasterBox.frame.origin.x+geoTmp.center.x, geoPasterBox.frame.origin.y+geoTmp.center.y);
            [selectedGeoImageView initFourCorners];
            
            return;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject]previousLocationInView:self.view];
    if(selectedGeoImageView != nil)
    {
        CGPoint vector = CGPointMake(point.x-prevPoint.x, point.y-prevPoint.y);
        selectedGeoImageView.transform = CGAffineTransformConcat(selectedGeoImageView.transform, CGAffineTransformMakeTranslation(vector.x, vector.y));
        selectedGeoImageView.geometryTransfrom = selectedGeoImageView.transform;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint endPoint = [[touches anyObject]locationInView:self.view];
    if(selectedGeoImageView != nil)
    {
        if(CGRectContainsPoint(pasterView.frame, endPoint))
        {
            selectedGeoImageView.frame = CGRectMake(selectedGeoImageView.frame.origin.x-pasterView.frame.origin.x, selectedGeoImageView.frame.origin.y-pasterView.frame.origin.y, selectedGeoImageView.frame.size.width, selectedGeoImageView.frame.size.height);
            [pasterView addSubview:selectedGeoImageView];

            //模型层贴纸作品数据更新
            PKGeometryImageView *newGeoImageView = [selectedGeoImageView deepCopy];
            PKGeometryPaster *geoPaster = [[PKGeometryPaster alloc] initWithGeometryImageView:newGeoImageView];
            [self.pasterWork.geoPasters addObject:geoPaster];
            [self.pasterWork.pasterView addSubview:geoPaster.geoPasterImageView];
            
            [newGeoImageView release];
            [geoPaster release];
            
            selectedGeoImageView = nil;
            selectedRectOriginal = CGRectInfinite;
        }
        else
        {
            [UIView animateWithDuration:0.5f animations:^(void) {
                selectedGeoImageView.frame = selectedRectOriginal;
            } completion:^(BOOL finished) {
                [selectedGeoImageView removeFromSuperview];
                selectedGeoImageView = nil;
                selectedRectOriginal = CGRectInfinite;
            }];
        }
    }
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //    drawBoard = [[DKDrawBoard alloc]init];
    //    [self.view addSubview:drawBoard.drawCanvas.drawCanvasView];
    //    
    [super viewDidLoad];
    
    //在视图加入几何贴纸
    NSUInteger index = 0;
    for (PKGeometryPaster *geoPaster in geoPasterLibrary.geometryPasters) {
        PKGeometryImageView *imageView = [geoPaster.geoPasterImageView deepCopy];
        
        [geoPasters insertObject:imageView atIndex:index];
        [imageView release];
        [geoPasterBox addSubview:[geoPasters objectAtIndex:index]];
        index++;
    }
    
    //对每个几何贴纸视图加入手势识别
    //    NSLog(@"count of subviews: %d",[geoPasterBox.subviews count]);
    //    for(UIImageView* imageView in geoPasters)
    //    {
    //        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGeoImageView:)];
    //        [imageView addGestureRecognizer:singleTap];
    //        [singleTap release];
    //    }
    
    promptDialogView.hidden = YES;
    
    //    [drawBoard.waterColorPen addObserver:self forKeyPath:@"state" options:NO|YES context:nil];
    //    
    //    if (drawBoard.isLikely) {
    //        [self penStateChange];
    //    }
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
    
    //    [drawBoard.waterColorPen removeObserver:self forKeyPath:@"state"];
    [pasterView release];
    [geoPasterLibrary release];
    [geoPasters release];
    [geoPasterBox release];
    [super dealloc];
}


//-(IBAction)buttonPressed:(id)sender{
//    UIImage *image=pasterView.image;
//    fillImage *fill=[[fillImage alloc]initWithImage:image];
//    struct ColorRGBAStruct tc={255,0,0,255};
//    struct ColorRGBAStruct bc={254,254,255,255};
//    int x=(int)xy.x;
//    int y=(int)xy.y;
//    if(x>=0&&y>=0&&x<image.size.width&&y<image.size.height){
//        [fill ScanLineSeedFill:x andY:y withTC:tc andBC:bc];
//        image=[fill getImage];
//        pasterView.image=image;
//        [fill release];
//    }
//}




//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    UITouch* touch = [touches anyObject];
//    //UIImageView* subImageView = [pasterView.subviews lastObject];
//    xy = [touch locationInView:self.pasterView];
//    printf("the click location is %f,%f",xy.x,xy.y);
//    UIImage *image= pasterView.image;
//    fillImage *fill=[[fillImage alloc]initWithImage:image];
//    struct ColorRGBAStruct tc={255,0,0,255};
//    struct ColorRGBAStruct bc={255,255,255,255};
//    int x=(int)xy.x*image.size.width/pasterView.frame.size.width;
//    int y=(int)xy.y*image.size.height/pasterView.frame.size.height;
//    printf("the x is %d,the y is %d,the width is %f,the height is %f",x,y,image.size.width,image.size.height);
//    if(x>=0&&y>=0&&x<image.size.width&&y<image.size.height){
//        [fill ScanLineSeedFill:x andY:y withTC:tc andBC:bc];
//        image=[fill getImage];
//        pasterView.image=image;
//        [fill release];
//    }
//}

//-(void)penStateChange{
//    [drawBoard.waterColorPen setValue:NO forKey:@"state"];
//}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    
//}


@end
