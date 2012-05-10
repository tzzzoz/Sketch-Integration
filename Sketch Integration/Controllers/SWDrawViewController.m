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

@synthesize drawViewState;
@synthesize pasterView;
@synthesize geoPasterBox;
@synthesize geoPasters;
@synthesize createPasterButton;
@synthesize pasterTemplate;
@synthesize pasterWork;
@synthesize drawBoard;
@synthesize geoPasterLibrary;
@synthesize selectedGeoImageView;
@synthesize promptDialogView;
@synthesize undoButton;
@synthesize redoButton;
@synthesize colorImageViewArray;
@synthesize selectedColorImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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

-(void)setViewStateFromNavigationView
{
    undoButton.hidden = NO;
    redoButton.hidden = NO;
    drawViewState = DrawState;
    [drawBoard.drawCanvas.drawCanvasView setHidden:NO];
    [self.view bringSubviewToFront:drawBoard.drawCanvas.drawCanvasView];
    [self hideGeoPasterBox];
    [self.view addSubview:drawBoard.drawCanvas.drawCanvasView];
}

-(void)setPasterTemplate:(PKPasterTemplate *)tmpPasterTemplate PasterWork:(PKPasterWork *)tmpPasterWork Frame:(CGRect)frame
{
    self.pasterTemplate = tmpPasterTemplate;
    self.pasterWork = tmpPasterWork;
    
    //pasterView加入贴纸作品
    pasterView = [[UIPasterView alloc]initWithFrame:CGRectMake(108, 36, 865, 630)];
    pasterView.contentMode = UIViewContentModeScaleToFill;
    
    UIImageView* subView = [[UIImageView alloc]initWithImage:tmpPasterWork.pasterView.image];
    [pasterView addSubview:subView];
    [subView release];
    
    for(PKGeometryImageView* geoImageView in tmpPasterWork.pasterView.subviews)
    {
        if([geoImageView isKindOfClass:[PKGeometryImageView class]])
        {
            geoImageView.transform = CGAffineTransformIdentity;
            PKGeometryImageView* subImageView = [geoImageView deepCopy];
            subImageView.transform = CGAffineTransformConcat(subImageView.transform, subImageView.geometryTransfrom);
            [self.pasterView addSubview:subImageView];
        }
    }
    
    ////////////////////////////////////////////////////
    [self.view addSubview:pasterView];
    
    if(drawViewState == PasterState)
    {
        undoButton.hidden = YES;
        redoButton.hidden = YES;
        [drawBoard.drawCanvas.drawCanvasView setHidden:YES];
        [self displayGeoPasterBox];
    }
    else if(drawViewState == DrawState)
    {
        undoButton.hidden = NO;
        redoButton.hidden = NO;
        [drawBoard.drawCanvas.drawCanvasView setHidden:NO];
        [self.view bringSubviewToFront:drawBoard.drawCanvas.drawCanvasView];
        [self hideGeoPasterBox];
    }
}

//获得屏幕图像  
- (UIImage *)imageFromView: (UIView *) theView    
{  
    
    UIGraphicsBeginImageContext(theView.frame.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    [theView.layer renderInContext:context];  
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return theImage;  
} 

- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r  
{  
    UIGraphicsBeginImageContext(theView.frame.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextSaveGState(context);  
    UIRectClip(r);  
    [theView.layer renderInContext:context];  
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];  
}

-(void)returnBack:(id)sender 
{
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController popViewController];
    
    
    if([rootViewController.nextViewController isKindOfClass:[SWPasterWonderlandViewController class]])
    {
        [geoPasterLibrary saveDataToDoc:NO];
        
        UIImageView* skipImageView = [[UIImageView alloc]initWithFrame:pasterView.frame];
        for(PKGeometryImageView* imageView in pasterView.subviews)
        {
            if([imageView isKindOfClass:[PKGeometryImageView class]])
            {
                imageView.transform = CGAffineTransformIdentity;
                PKGeometryImageView *subImageView = [imageView deepCopy];
                subImageView.transform = CGAffineTransformConcat(subImageView.transform, subImageView.geometryTransfrom);
                
                [skipImageView addSubview:subImageView];
                
            }
            else if([imageView isKindOfClass:[UIImageView class]])
            {
                skipImageView.image = imageView.image;
            }
        }
        
        //清除pasterWork的内容，由当前视图进行更新
        [self.pasterWork.geoPasters removeAllObjects];
        for (UIView *view in pasterWork.pasterView.subviews) 
        {
            [view removeFromSuperview];
        }
        
        [self updateGeoPasterToPaster];
        
//        [self cleanPasterView];
//        UIImageView* subView = [[UIImageView alloc]initWithImage:pasterWork.pasterView.image];
//        [pasterView addSubview:subView];
//        [subView release];
//        for(PKGeometryImageView* geoImageView in pasterWork.pasterView.subviews)
//        {
//            if([geoImageView isKindOfClass:[PKGeometryImageView class]])
//            {
//                geoImageView.transform = CGAffineTransformIdentity;
//                PKGeometryImageView* subImageView = [geoImageView deepCopy];
//                subImageView.transform = CGAffineTransformConcat(subImageView.transform, subImageView.geometryTransfrom);
//                [self.pasterView addSubview:subImageView];
//            }
//        }
//        [self.view addSubview:pasterView];
        
        [rootViewController skipWithImageView:skipImageView Destination:rootViewController.pasterWonderlandViewController.selectedPosition Animation:EaseOut];
        
        [skipImageView release];
        
        //清楚选中颜色
        if(drawViewState == FillState)
        {
            [self displayGeoPasterBox];
            drawViewState = PasterState;
        }
        //清楚pasterview
        [self cleanPasterView];
    }
    else if([rootViewController.nextViewController isKindOfClass:[SWNavigationViewController class]])
    {
        [drawBoard.drawCanvas.drawCanvasView removeFromSuperview];
        [drawBoard.drawCanvas deleteCanvas];
        [rootViewController skipWithAnimation:EaseOut];
    }
}

-(void)updateGeoPasterToPaster 
{
    for(PKGeometryImageView* geoImageView in pasterView.subviews)
    {
        if([geoImageView isKindOfClass:[PKGeometryImageView class]])
        {
            geoImageView.transform = CGAffineTransformIdentity;
            PKGeometryImageView *newGeoImageView = [geoImageView deepCopy];
            geoImageView.transform = CGAffineTransformConcat(geoImageView.transform, geoImageView.geometryTransfrom);
            
            PKGeometryPaster *geoPaster = [[PKGeometryPaster alloc] initWithGeometryImageView:newGeoImageView];
            [self.pasterWork.geoPasters addObject:geoPaster];
            [self.pasterWork.pasterView addSubview:geoPaster.geoPasterImageView];
            
            [geoPaster release];
        }
    }
}

-(void)savePasterWork 
{
    [self.geoPasterLibrary saveDataToDoc:NO];
    PKPasterTemplateLibrary *tmpPasterTemplateLibrary = [[[RootViewController sharedRootViewController] pasterWonderlandViewController] pasterTemplateLibrary];
    tmpPasterTemplateLibrary.isModified = YES;
    [tmpPasterTemplateLibrary saveDataToDoc:NO];
}

-(void)cleanPasterView 
{
    pasterView.selectedGeoImageView.operationType = Nothing;
    pasterView.selectedGeoImageView.isGeometrySelected = NO;
    pasterView.selectedGeoImageView = nil;
    for (UIView *view in pasterView.subviews) 
    {
        [view removeFromSuperview];
    }
    [pasterView removeFromSuperview];
}

-(void)pressDrawAlbumButton:(id)sender 
{
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController pushViewController:[rootViewController drawAlbumViewController]];
    [tonePlayer[8] play];
    
    [rootViewController skipWithAnimation:EaseIn];
        
    [self updateGeoPasterToPaster];
    
    
    
    [[rootViewController drawAlbumViewController] loadFlowView];
}

-(IBAction)pressCleanButton:(id)sender
{
    //禁用pasterView的手势识别
    [pasterView setUserInteractionEnabled:NO];
    
    UIImageView *promptBackground;
    UIButton *comfirmButton;
    UIButton *cancelButton;
    UILabel *promptText;
    promptDialogView = [[UIView alloc]initWithFrame:CGRectMake(62.0f, 180.0f, 225.0f, 175.0f)];
    promptBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 225.0f, 175.0f)];
    comfirmButton = [[UIButton alloc]initWithFrame:CGRectMake(30.0, 90.0, 50.0, 50.0)];
    cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(150.0, 90.0, 50.0, 50.0)];
    promptText = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 126.0, 30.0)];
    promptText.numberOfLines = 2;
    
    promptBackground.image = [UIImage imageNamed:@"basicBackgroundImageView.png"];
    [promptDialogView addSubview:promptBackground];
    
    promptText.text = @"是否清空所有操作？";
    promptText.font = [UIFont systemFontOfSize:22.0f];
    promptText.textColor = [UIColor purpleColor];
    promptText.backgroundColor = [UIColor clearColor];
    [promptText sizeToFit];
    [promptDialogView addSubview:promptText];
    
    
    UIImage *confirmImage = [UIImage imageNamed:@"confirmButton.png"];
    UIImage *cancelImage = [UIImage imageNamed:@"cancleButton.png"];
    [comfirmButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
    [comfirmButton addTarget:self action:@selector(pressComfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [promptDialogView addSubview:comfirmButton];
    [promptDialogView addSubview:cancelButton];
    
    [self.view addSubview:promptDialogView];
    [tonePlayer[9] play];
    
    [promptBackground release];
    [confirmImage release];
    [cancelImage release];
}
-(void)pressComfirmButton:(id)sender
{
    [tonePlayer[0] play];
    
    if(drawViewState == DrawState)
    {
        [drawBoard.drawCanvas.drawCanvasView removeFromSuperview];
        [drawBoard.drawCanvas deleteCanvas];
        [self.view addSubview:drawBoard.drawCanvas.drawCanvasView];
    }
    
    if(drawViewState != DrawState)
    {
        //添加清空操作
        pasterView.selectedGeoImageView.isGeometrySelected = NO;
        pasterView.selectedGeoImageView.operationType = Nothing;
        pasterView.selectedGeoImageView = nil;
        pasterView.frameView.currentPasterView = nil;
        for(UIView *view in pasterView.subviews)
        {
            if([view isKindOfClass:[UIFrameView class]])
            {
                [pasterView.frameView setNeedsDisplay];
            }
            else
            {
                [view removeFromSuperview];
            }
        }
        //启用pasterView手势识别
        [pasterView addSubview:pasterTemplate.pasterView];
        [pasterView setUserInteractionEnabled:YES];
        if(drawViewState == FillState)
        {
            [self displayGeoPasterBox];
        }
    }
    
    promptDialogView.hidden = YES;
}
-(void)pressCancelButton:(id)sender{
    [tonePlayer[6] play];
    promptDialogView.hidden = YES;
    //启用pasterView手势识别
    [pasterView setUserInteractionEnabled:YES];
}

-(IBAction)pressSaveButton:(id)sender
{
    [tonePlayer[11] play];
    
    if (drawViewState != 2) {
        UIImageView *showImageView;
        UIImageView *showImageView2;
        int i = arc4random()%5;
        showImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(140.0, 80.0, 760.0, 560.0) ]autorelease];
        showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"drawWorkBackgroundImageView%d", i]];
        
        
        RootViewController *rootViewController = [RootViewController sharedRootViewController];
        NSDate *dateToDay = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [df setLocale:locale];
        NSString *date = [df stringFromDate:dateToDay];
        ///////////加入文字////////////////////////////
//        UILabel *dateText;
//        dateText = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 30)];
//        dateText.text = [NSString stringWithFormat:@"%@", date];
//        dateText.font = [UIFont systemFontOfSize:22.0f];
//        dateText.textColor = [UIColor blackColor];
//        dateText.backgroundColor = [UIColor clearColor];
//        [dateText sizeToFit];
//        [pasterView addSubview:dateText];
    
    	NSLog(@"%@", date);
        UIImage *image = [self imageFromView:pasterView atFrame:CGRectMake(30.0, 20.0, 760.0, 560.0)];
        showImageView2 = [[UIImageView alloc] initWithImage:image];
        [showImageView addSubview:showImageView2];
        
    
        [rootViewController.drawAlbumViewController setDrawWorkWithPasterWork:pasterWork PasterWorkName:date pasterImageWork:[self imageFromView:showImageView atFrame:CGRectMake(0.0, 0.0, 760.0, 560.0)]];

    }
}


-(void)hideGeoPasterBox
{
    geoPasterBox.hidden=YES;
    [self displayColorImageViewArray];
}

-(void)displayGeoPasterBox
{
    geoPasterBox.hidden=NO;
    [self hideColorImageViewArray];
    ColorRGBA colorRGBA = {0,0,0,0};
    [pasterView setTC:colorRGBA];
}

-(void)hideColorImageViewArray
{
    if(selectedColorImageView != nil)
    {
        [selectedColorImageView setFrame:CGRectMake(selectedColorImageView.frame.origin.x, selectedColorImageView.frame.origin.y+20, selectedColorImageView.frame.size.width, selectedColorImageView.frame.size.height)];
        selectedColorImageView = nil;
    } 
    for(UIImageView* colorImageView in colorImageViewArray)
    {
        colorImageView.hidden = YES;
    }
}

-(void)displayColorImageViewArray
{
    if(selectedColorImageView != nil)
    {
        [selectedColorImageView setFrame:CGRectMake(selectedColorImageView.frame.origin.x, selectedColorImageView.frame.origin.y+20, selectedColorImageView.frame.size.width, selectedColorImageView.frame.size.height)];
        selectedColorImageView = nil;
    }
    for(UIImageView* colorImageView in colorImageViewArray)
    {
        colorImageView.hidden = NO;
    }
}

//点击画笔事件
-(void)tapColorImageView:(UIGestureRecognizer *) gestureRecognizer 
{
    if(selectedColorImageView != nil)
    {
        [selectedColorImageView setFrame:CGRectMake(selectedColorImageView.frame.origin.x, selectedColorImageView.frame.origin.y+20, selectedColorImageView.frame.size.width, selectedColorImageView.frame.size.height)];
    }
    
    UIImageView *imageView = (UIImageView*)gestureRecognizer.view;
    selectedColorImageView = imageView;
    int index = [colorImageViewArray indexOfObject:imageView];
    drawBoard.colorPalette.selectedColorIndex = index;
    [selectedColorImageView setFrame:CGRectMake(selectedColorImageView.frame.origin.x, selectedColorImageView.frame.origin.y-20, selectedColorImageView.frame.size.width, selectedColorImageView.frame.size.height)];
    
    int indexOfColor = drawBoard.colorPalette.selectedColorIndex;
    [colorPlayer[indexOfColor] play];

    DKColor* colorTemp = [drawBoard.colorPalette.colorArray objectAtIndex:indexOfColor];
    drawBoard.waterColorPen.color.colorType = colorTemp.colorType;
    drawBoard.waterColorPen.color.color     = [DKColorPalette changeColorWith:indexOfColor];
    
    if (selectedColorImageView != nil) 
    {
        drawBoard.drawCanvas.drawCanvasView.currentColor = colorTemp.color;
        UIColor *uicolor = colorTemp.color;
        CGColorRef color = [uicolor  CGColor]; 
        int numComponents = CGColorGetNumberOfComponents(color);
        ColorRGBA tc;
        if (numComponents >= 3)
        {
            CGFloat *tmComponents = CGColorGetComponents(color);
            tc.red =(int) (tmComponents[0]*255);
            tc.green =(int) (tmComponents[1]*255);
            tc.blue =(int) (tmComponents[2]*255);
            tc.alpha =(int) (tmComponents[3]*255);
        }
        [pasterView setTC:tc];
    }
    else
    {
        drawBoard.drawCanvas.drawCanvasView.currentColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        UIColor *uicolor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        CGColorRef color = [uicolor  CGColor]; 
        int numComponents = CGColorGetNumberOfComponents(color);
        ColorRGBA tc;
        if (numComponents >= 3)
        {
            CGFloat *tmComponents = CGColorGetComponents(color);
            tc.red =(int) (tmComponents[0]*255);
            tc.green =(int) (tmComponents[1]*255);
            tc.blue =(int) (tmComponents[2]*255);
            tc.alpha =(int) (tmComponents[3]*255);
        }
        [pasterView setTC:tc];
    }
}


#pragma mark - touch respond

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"controller  touch!!!");
    if(!geoPasterBox.hidden)
    {
        CGPoint beginPoint = [[touches anyObject]locationInView:self.geoPasterBox];
        if(beginPoint.y>34.0&&beginPoint.y<120.0){
            if(beginPoint.x>27&&beginPoint.x<113){
                [geoPlayer[0] play];
            }
            if(beginPoint.x>140&&beginPoint.x<226){
                [geoPlayer[1] play];
            }
            if(beginPoint.x>253&&beginPoint.x<339){
                [geoPlayer[2] play];
            }
            if(beginPoint.x>366&&beginPoint.x<452){
                [geoPlayer[3] play];
            }
            if(beginPoint.x>479&&beginPoint.x<565){
                [geoPlayer[4] play];
            }
            if(beginPoint.x>592&&beginPoint.x<678){
                [geoPlayer[5] play];
            }
            if(beginPoint.x>705&&beginPoint.x<791){
                [geoPlayer[6] play];
            }
        }
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
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!geoPasterBox.hidden){
        CGPoint point = [[touches anyObject]locationInView:self.view];
        CGPoint prevPoint = [[touches anyObject]previousLocationInView:self.view];
        if(selectedGeoImageView != nil)
        {
            CGPoint vector = CGPointMake(point.x-prevPoint.x, point.y-prevPoint.y);
            selectedGeoImageView.transform = CGAffineTransformConcat(selectedGeoImageView.transform, CGAffineTransformMakeTranslation(vector.x, vector.y));
            selectedGeoImageView.geometryTransfrom = selectedGeoImageView.transform;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!geoPasterBox.hidden){
        CGPoint endPoint = [[touches anyObject]locationInView:self.view];
        if(selectedGeoImageView != nil)
        {
            if(CGRectContainsPoint(pasterView.frame, endPoint))
            {
                selectedGeoImageView.frame = CGRectMake(selectedGeoImageView.frame.origin.x-pasterView.frame.origin.x, selectedGeoImageView.frame.origin.y-pasterView.frame.origin.y, selectedGeoImageView.frame.size.width, selectedGeoImageView.frame.size.height);
                
                PKGeometryImageView* newGeoImageView = [[PKGeometryImageView alloc]initWithFrame:selectedGeoImageView.frame];
                newGeoImageView.image = selectedGeoImageView.image;
                [pasterView addSubview:newGeoImageView];
                
                [selectedGeoImageView removeFromSuperview];
                selectedGeoImageView = nil;
                selectedRectOriginal = CGRectInfinite;
                
                //模型层贴纸作品数据更新
                PKGeometryImageView *modelGeoImageView = [newGeoImageView deepCopy];
                PKGeometryPaster *geoPaster = [[PKGeometryPaster alloc] initWithGeometryImageView:modelGeoImageView];
                [self.pasterWork.geoPasters addObject:geoPaster];
                [self.pasterWork.pasterView addSubview:geoPaster.geoPasterImageView];
                [geoPaster release];
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
}

#pragma mark - View lifecycle


-(void)loadSound{
    NSString * geo[7]={@"%@/sound_triangle.wav",@"%@/sound_trapezium.wav",@"%@/sound_ellipse.wav",@"%@/sound_pentacle.wav",@"%@/sound_circle.wav",@"%@/sound_square.wav",@"%@/sound_rectangle.wav"};
    NSString *tone[13]={@"%@/sound_clearButton.wav",@"%@/sound_deleteButton.wav",@"%@/sound_doGood.wav",@"%@/sound_doNotGood.wav",@"%@/sound_editGeometryPasterButton.wav",@"%@/sound_finishTask.wav",@"%@/sound_normalButton.wav",@"%@/sound_noUse.wav",@"%@/sound_pageJump.wav",@"%@/sound_prompt.mp3",@"%@/sound_returnButton.wav",@"%@/sound_saveButton.wav",@"%@/sound_slip.wav"};
    NSString *color[18]={@"%@/sound_black.wav",@"%@/sound_red.wav",@"%@/sound_yellow.wav",@"%@/sound_light_blue.wav",@"%@/sound_green.wav",@"%@/sound_purple.wav",@"%@/sound_brown.wav",@"%@/sound_orange.wav",@"%@/sound_purple_red.wav",@"%@/sound_peach_red.wav",@"%@/sound_yellow_blue.wav",@"%@/sound_deep_purple.wav",@"%@/sound_silver.wav",@"%@/sound_deep_green.wav",@"%@/sound_blue.wav",@"%@/sound_deep_blue.wav",@"%@/sound_blue_green.wav",@"%@/sound_pink.wav"};
    NSURL * url;
    NSError *error;
    for(int i=0;i<7;i++){
        url = [NSURL fileURLWithPath:[NSString  
                                      stringWithFormat:geo[i],  [[NSBundle mainBundle]  resourcePath]]];
        geoPlayer[i]  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
        geoPlayer[i].numberOfLoops  = 0;
        if  (geoPlayer[i] == nil)      //文件不存在
            printf("音频加载失败G%d",i);
    }
    for(int i=0;i<13;i++){
        url = [NSURL fileURLWithPath:[NSString  
                                      stringWithFormat:tone[i],  [[NSBundle mainBundle]  resourcePath]]];
        tonePlayer[i]  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
        tonePlayer[i].numberOfLoops  = 0;
        if  (tonePlayer[i] == nil)      //文件不存在
            printf("音频加载失败T%d",i);
    }
    for(int i=0;i<18;i++){
        url = [NSURL fileURLWithPath:[NSString  
                                      stringWithFormat:color[i],  [[NSBundle mainBundle]  resourcePath]]];
        colorPlayer[i]  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
        colorPlayer[i].numberOfLoops  = 0;
        if  (colorPlayer[i] == nil)      //文件不存在
            printf("音频加载失败C%d",i);
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{  
    [super viewDidLoad];
    
    ////////////////////////初始化画板的界面//////////////////////////////
    drawBoard = [[DKDrawBoard alloc]initWithBoardState:YES];
    
    //在视图加入几何贴纸
    NSUInteger index = 0;
    for (PKGeometryPaster *geoPaster in geoPasterLibrary.geometryPasters) 
    {
        PKGeometryImageView *imageView = [geoPaster.geoPasterImageView deepCopy];
        
        [geoPasters insertObject:imageView atIndex:index];
        [imageView release];
        [geoPasterBox addSubview:[geoPasters objectAtIndex:index]];
        index++;
    }
    
    colorImageViewArray = [[NSMutableArray alloc]initWithCapacity:18];
    for(DKColor* colorData in drawBoard.colorPalette.colorArray)
    {
        UIImageView* colorImageView = [colorData.colorImageView deepCopy];
        [colorImageViewArray addObject:colorImageView];
        [self.view addSubview:colorImageView];
        [colorImageView release];
    }
    
    //添加点击画笔响应
    for (UIImageView *colorImageView in colorImageViewArray) 
    {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapColorImageView:)];
        [colorImageView setUserInteractionEnabled:YES];
        [colorImageView addGestureRecognizer:singleTap];
        [singleTap release];
    }
    
    [self hideGeoPasterBox];
    [self hideColorImageViewArray];
    
    //载入音频文件
    [self loadSound];
}

- (void)viewDidUnload
{
    [self setUndoButton:nil];
    [self setRedoButton:nil];
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
    
    //[drawBoard.waterColorPen removeObserver:self forKeyPath:@"state"];
    for(int i=0;i<7;i++){
        [geoPlayer[i] release];
    }
    for(int i=0;i<13;i++){
        [tonePlayer[i] release];
    }
    for(int i=0;i<18;i++){
        [colorPlayer[i] release];
    }
    [pasterView release];
    [geoPasterLibrary release];
    [geoPasters release];
    [promptDialogView release];
    [geoPasterBox release];
    [undoButton release];
    [redoButton release];
    [super dealloc];
}

//-(void)penStateChange{
//    [drawBoard.waterColorPen setValue:NO forKey:@"state"];
//}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    
//}


- (IBAction)pressUndo:(id)sender 
{
    [tonePlayer[6]play];
    if(drawViewState == DrawState)
    {
        [drawBoard.drawCanvas undo];
    }
}

- (IBAction)pressRedo:(id)sender 
{
    [tonePlayer[6]play];
    if(drawViewState == DrawState)
    {
        [drawBoard.drawCanvas redo];
    }
}
@end
