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
@synthesize pasterImageView;
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
@synthesize penArray;
@synthesize selectedImageView;

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
    subView.hidden = YES;
    [self.pasterView addSubview:subView];
    [subView release];
    
    pasterImageView = [[UIImageView alloc]initWithFrame:pasterView.frame];
    pasterImageView.image = subView.image;
    [self.view addSubview:pasterImageView];
    
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
}

-(void)returnBack:(id)sender 
{
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController popViewController];
    
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
        else
            skipImageView.image = imageView.image;
    }
    
    //清除pasterWork的内容，由当前视图进行更新
    [self.pasterWork.geoPasters removeAllObjects];
    for (UIView *view in pasterWork.pasterView.subviews) 
    {
        [view removeFromSuperview];
    }
    
    [self updateGeoPasterToPaster];
    
    [rootViewController skipWithImageView:skipImageView Destination:rootViewController.pasterWonderlandViewController.selectedPosition Animation:EaseOut];
    [tonePlayer[10] play];

    [skipImageView release];
    [pasterImageView removeFromSuperview];
    
    [self cleanPasterView];
}

-(void)updateGeoPasterToPaster {
    for(PKGeometryImageView* geoImageView in pasterView.subviews)
    {
        if([geoImageView isKindOfClass:[PKGeometryImageView class]])
        {
            geoImageView.transform = CGAffineTransformIdentity;
            PKGeometryImageView *newGeoImageView = [geoImageView deepCopy];
//            newGeoImageView.transform = CGAffineTransformConcat(geoImageView.transform, geoImageView.geometryTransfrom);
            
            PKGeometryPaster *geoPaster = [[PKGeometryPaster alloc] initWithGeometryImageView:newGeoImageView];
            [self.pasterWork.geoPasters addObject:geoPaster];
            [self.pasterWork.pasterView addSubview:geoPaster.geoPasterImageView];
            
            [geoPaster release];
        }
    }
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
    [tonePlayer[8] play];
    [self cleanPasterView];
}


-(IBAction)pressCleanButton:(id)sender{
    promptDialogView = [[UIImageView alloc]initWithFrame:CGRectMake(62.0f, 180.0f, 225.0f, 175.0f)];
    comfirmButton = [[UIButton alloc]initWithFrame:CGRectMake(62.0, 90.0, 50.0, 50.0)];
    cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(120.0, 90.0, 50.0, 50.0)];
    promptText = [[UILabel alloc] initWithFrame:CGRectMake(61.0, 31.0, 126.0, 64.0)];
    promptText.numberOfLines = 2;
    promptText.text = @"是否清空所有操作？";
    promptText.font = [UIFont systemFontOfSize:22.0f];
    promptText.textColor = [UIColor purpleColor];
    promptText.backgroundColor = [UIColor clearColor];
    [promptText sizeToFit];
    [promptDialogView addSubview:promptText];
    [tonePlayer[9] play];
    //    promptDialogView.frame = CGRectMake(62.0f, 180.0f, 225.0f, 175.0f);
    promptDialogView.image = [UIImage imageNamed:@"basicBackgroundImageView.png"];
    
    //    UIButton *comfirmButton;
    //    UIButton *cancelButton;
    UIImage *confirmImage = [UIImage imageNamed:@"confirmButton.png"];
    UIImage *cancelImage = [UIImage imageNamed:@"cancleButton.png"];
    
    //    comfirmButton.frame = CGRectMake(62.0, 90.0, 50.0, 50.0);
    //    cancelButton.frame = CGRectMake( 120.0, 90.0, 50.0, 50.0);
    
    //    comfirmButton.imageView = [UIImage imageNamed:@"confirmButton.png"];
    [comfirmButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
    [comfirmButton addTarget:self action:@selector(pressComfirmButton) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(pressCancelButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    [promptDialogView addSubview:comfirmButton];
    [promptDialogView addSubview:cancelButton];
    
    [self.view addSubview:promptDialogView];
    //提示框上的按钮都按不到？？
    [self.view bringSubviewToFront:promptDialogView];
    
    [confirmImage release];
    [cancelImage release];
}
-(IBAction)pressComfirmButton:(id)sender{
    [tonePlayer[0] play];
    //    promptDialogView.hidden = YES;
    //    drawBoard.drawCanvasView.view = nil;
    //    self.drawBoard.drawCanvas.drawCanvasView.image = nil;
}
-(IBAction)pressCancelButton:(id)sender{
    //    promptDialogView.hidden = YES;
}

-(IBAction)pressSaveButton:(id)sender{
    ColorRGBA tc={255,0,0,255};
    [pasterView setTC:tc];
    [tonePlayer[11] play];
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
    pasterView.selectedGeoImageView = nil;
    for (UIView *view in pasterView.subviews) 
    {
        [view removeFromSuperview];
    }
    [pasterView removeFromSuperview];
}

-(void)initPen{
    for (int i = 0; i < 18; i++) {
        [[drawBoard.colorPenArray objectAtIndex: i] initWithColorNumber:i];
        [self.view addSubview:[[drawBoard.colorPenArray objectAtIndex: i] colorPen]];
        [[drawBoard.colorPenArray objectAtIndex:i] colorPen].hidden = YES;
        [penArray addObject:[drawBoard.colorPenArray objectAtIndex: i]];
    }
}

-(void)hiddenGeoPasterBox{
    geoPasterBox.hidden=YES;
    for (int i = 0; i < 18; i++) {
        [[drawBoard.colorPenArray objectAtIndex:i] colorPen].hidden = NO;
    }
    //[self.view addSubview:drawBoard.drawCanvas.drawCanvasView];
}

-(void)displayGeoPasterBox{
    geoPasterBox.hidden=NO;
    for (int i = 0; i < 18; i++) {
        [[drawBoard.colorPenArray objectAtIndex:i] colorPen].hidden = YES;
        [[drawBoard.colorPenArray objectAtIndex:i] setPenState:NO];
        [[drawBoard.colorPenArray objectAtIndex:i] changePenStateWith:NO];
        ColorRGBA color={0,0,0,0};
        [pasterView setTC:color];
    }
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

//点击画笔事件
-(void)tapColorImageView:(UIGestureRecognizer *) gestureRecognizer 
{
    UIImageView *imageView = (UIImageView*)gestureRecognizer.view;
    selectedImageView = imageView;
    
    //    selectedImageView.frame = CGRectMake(122, 600, 42, 130);
    //    [self.view addSubview:selectedImageView];
    
    NSUInteger index = 0;
    for (DKWaterColorPen *colorPens in penArray) 
        //    for (DKWaterColorPen *colorPens in drawBoard.colorPenArray) 
    {
        if ([selectedImageView isEqual:colorPens.colorPen]) 
        {
            NSLog(@"%d", index);
            [colorPlayer[index]play];
            break;
        }   
        index++;
    }
    
    
    for (int i = 0; i < 18; i++) {
        if (index != i ) {
            [[penArray objectAtIndex:i] setPenState:NO];
            [[penArray objectAtIndex:i] changePenStateWith:NO];
        }
        
    }
    [[penArray objectAtIndex:index] changeState];
    [[penArray objectAtIndex:index] changePenStateWith:[[penArray objectAtIndex:index] penState]];
    DKWaterColorPen *colorPen = [penArray objectAtIndex:index];
    if ([[penArray objectAtIndex:index] penState]) {
        drawBoard.drawCanvas.drawCanvasView.currentColor = [colorPen changeColorWith:index];
        UIColor *uicolor = [colorPen changeColorWith:index];
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
    else{
        drawBoard.drawCanvas.drawCanvasView.currentColor = [colorPen changeColorWith:18];
        UIColor *uicolor = [colorPen changeColorWith:18];
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
    
    //在视图加入几何贴纸
    NSUInteger index = 0;
    for (PKGeometryPaster *geoPaster in geoPasterLibrary.geometryPasters) {
        PKGeometryImageView *imageView = [geoPaster.geoPasterImageView deepCopy];
        
        [geoPasters insertObject:imageView atIndex:index];
        [imageView release];
        [geoPasterBox addSubview:[geoPasters objectAtIndex:index]];
        index++;
    }
    //加入画板,参数YES则加入画纸功能，否则只有笔的功能
    drawBoard = [[DKDrawBoard alloc] initWithBoardState:NO];
    penArray = [[NSMutableArray alloc] initWithCapacity:18];
    //    加入画笔和画板
    [self initPen];
    [self.view addSubview:drawBoard.drawCanvas.drawCanvasView];
    //    添加点击画笔响应
    UIImageView *imageView;
    index = 0;
    for (DKWaterColorPen *waterPen in penArray) 
    {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapColorImageView:)];
        imageView = [[penArray objectAtIndex:index] colorPen] ;
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:singleTap];
        index++;
        [singleTap release];
    }
    //载入音频文件
    [self loadSound];
    //对每个几何贴纸视图加入手势识别
    //    NSLog(@"count of subviews: %d",[geoPasterBox.subviews count]);
    //    for(UIImageView* imageView in geoPasters)
    //    {
    //        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGeoImageView:)];
    //        [imageView addGestureRecognizer:singleTap];
    //        [singleTap release];
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
