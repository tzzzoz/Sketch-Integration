//
//  SWDrawAlbumViewController.m
//  Sketch Integration
//
//  Created by    on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SWDrawAlbumViewController.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)

@implementation SWDrawAlbumViewController

@synthesize pasterWorkShows, flowView, operationQueue, workShows, workShowViews, workShowsDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        operationQueue = [[NSOperationQueue alloc] init];
        
        flowView=[[AFOpenFlowView alloc]initWithFrame:CGRectMake(0, 110, 1024, 658)];
        [flowView setViewDelegate:self];
        flowView.viewDelegate = self;
        deleteViewNumber = 0;
        isDeleted = NO;
    }
    return self;
}

-(void)initDataFromArchiver {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename;
    filename = [path stringByAppendingPathComponent:@"DrawAlbum_WorkShows"];
    self.workShows = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
    filename = [path stringByAppendingPathComponent:@"DrawAlbum_WorkShowViews"];
    self.workShowViews = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
    
    //如果初始化还未成功，手动声明
    if (!workShows || !workShowViews) {
        self.workShows = [[[NSMutableArray alloc]init] autorelease];
        self.workShowsDate = [[[NSMutableArray alloc]init] autorelease];
        self.workShowViews = [[[NSMutableArray alloc]init] autorelease];
        
    }
}

-(void)loadFlowView
{
    if (isDeleted == YES) {
        [workShowViews removeObjectAtIndex:deleteViewNumber];
        isDeleted = NO;
    }
    
    for (int i = 0; i < [workShowViews count]; i++) 
    {
        [flowView setImage:[workShowViews objectAtIndex:i] forIndex:i];
    }
    
    [flowView setNumberOfImages:[workShowViews count]];
    
    NSLog(@"size %d", [workShows count]);
    [self.view addSubview:flowView];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)returnBack:(id)sender 
{
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController popViewController];
    [rootViewController skipWithAnimation:EaseOut];
    [returnPlayer play];
}

//-(void)deleteButtonPressed:(id)sender{
//    UIImageView *promptBackground;
//    UIButton *comfirmButton;
//    UIButton *cancelButton;
//    UILabel *promptText;
//    promptDialogView = [[UIView alloc]initWithFrame:CGRectMake(770.0f, 130.0f, 225.0f, 175.0f)];
//    promptBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 225.0f, 175.0f)];
//    comfirmButton = [[UIButton alloc]initWithFrame:CGRectMake(30.0, 110.0, 50.0, 50.0)];
//    cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(120.0, 110.0, 50.0, 50.0)];
//    promptText = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 126.0, 30.0)];
//    promptText.numberOfLines = 2;
//    
//    promptBackground.image = [UIImage imageNamed:@"basicReverseBackgroundImageView.png"];
//    [promptDialogView addSubview:promptBackground];
//    
//    promptText.text = @"是否删除选中画作？";
//    promptText.font = [UIFont systemFontOfSize:22.0f];
//    promptText.textColor = [UIColor purpleColor];
//    promptText.backgroundColor = [UIColor clearColor];
//    [promptText sizeToFit];
//    [promptDialogView addSubview:promptText];
//    
//    
//    UIImage *confirmImage = [UIImage imageNamed:@"confirmButton.png"];
//    UIImage *cancelImage = [UIImage imageNamed:@"cancleButton.png"];
//    [comfirmButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
//    [comfirmButton addTarget:self action:@selector(pressComfirmButton:) forControlEvents:UIControlEventTouchUpInside];
//    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
//    [promptDialogView addSubview:comfirmButton];
//    [promptDialogView addSubview:cancelButton];
//    
//    [self.view addSubview:promptDialogView];
//    [promptPlayer play];
//    
//    [promptBackground release];
//    [confirmImage release];
//    [cancelImage release];
//}
//
-(void)setDrawWorkWithPasterWork:(PKPasterWork *) pasterWork PasterWorkName:(NSString*)date pasterImageWork:(UIImage*) pasterWorkImage
{
    PKPasterWork *tmpPasterWork = [pasterWork copy];
    [workShows addObject:tmpPasterWork];
    [workShowsDate addObject:date];
    [workShowViews addObject:pasterWorkImage];
    [self loadFlowView];
    
    //开一个线程负责保存画作回磁盘
//    ArchiveAlbumThread *archiveThread = [[[ArchiveAlbumThread alloc] init] autorelease];
//    [operationQueue addOperation:archiveThread];

    return;
}


-(void)saveDrawAlbum {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:@"DrawAlbum_WorkShows"];
    [NSKeyedArchiver archiveRootObject:workShows toFile:fileName];
    
    fileName = [path stringByAppendingPathComponent:@"DrawAlbum_WorkShowViews"];
    [NSKeyedArchiver archiveRootObject:workShowViews toFile:fileName];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index
{ 
    NSLog(@"%d is selected",index);
    deleteViewNumber = index;
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView singleTaped:(int)index
{
    NSLog(@"%d is touched",index); 
}

-(void)pressComfirmButton:(id)sender
{
    [deletePlayer play];
    //添加删除操作
    
//    deleteViewNumber 
    isDeleted = YES;
    NSLog(@"%d", deleteViewNumber);
    
    promptDialogView.hidden = YES;
    [self loadFlowView];
}
-(void)pressCancelButton:(id)sender
{
    [cancelPlayer play];
    promptDialogView.hidden = YES;
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
    //加载音频文件
    NSURL  *url = [NSURL fileURLWithPath:[NSString  
                                          stringWithFormat:@"%@/sound_slip.wav",  [[NSBundle mainBundle]  resourcePath]]];
    NSError  *error;
    slipPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
    slipPlayer.numberOfLoops  = 0;
    if  (slipPlayer == nil)      //文件不存在
        printf("音频加载失败");
    
    url = [NSURL fileURLWithPath:[NSString  
                                  stringWithFormat:@"%@/sound_returnButton.wav",  [[NSBundle mainBundle]  resourcePath]]];
    returnPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载return音效
    returnPlayer.numberOfLoops  = 0;
    if  (returnPlayer == nil)      //文件不存在
        printf("音频加载失败");
    
    url = [NSURL fileURLWithPath:[NSString  
                                  stringWithFormat:@"%@/sound_deleteButton.wav",  [[NSBundle mainBundle]  resourcePath]]];
    deletePlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载return音效
    deletePlayer.numberOfLoops  = 0;
    if  (deletePlayer == nil)      //文件不存在
        printf("音频加载失败");
    
    url = [NSURL fileURLWithPath:[NSString  
                                  stringWithFormat:@"%@/sound_normalButton.wav",  [[NSBundle mainBundle]  resourcePath]]];
    cancelPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载return音效
    cancelPlayer.numberOfLoops  = 0;
    if  (cancelPlayer == nil)      //文件不存在
        printf("音频加载失败");
    
    url = [NSURL fileURLWithPath:[NSString  
                                  stringWithFormat:@"%@/sound_prompt.mp3",  [[NSBundle mainBundle]  resourcePath]]];
    promptPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载return音效
    promptPlayer.numberOfLoops  = 0;
    if  (promptPlayer == nil)      //文件不存在
        printf("音频加载失败");
    
    if ([self.workShows count] != 0)
    {
        [self loadFlowView];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc{
    [operationQueue release];
    [returnPlayer release];
    [slipPlayer release];
    [deletePlayer release];
    [promptPlayer release];
    [cancelPlayer release];
    [promptDialogView release];
    [flowView release];
    [super dealloc];
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
