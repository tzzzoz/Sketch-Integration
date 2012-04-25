//
//  SWHelpViewController.h
//  Sketch Integration
//
//  Created by 付 乙荷 on 12-4-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface SWHelpViewController : UIViewController{
    UIButton *prevButton;
    UIButton *nextButton;
    
    UIImageView *helpImageView;
    
    NSInteger helpImageIndex;
}

@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIImageView *helpImageView;



-(IBAction)clickNextButton:(id)sender;
-(IBAction)clickPrevButton:(id)sender;

-(IBAction)returnBack:(id)sender;
@end
