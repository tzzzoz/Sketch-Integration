//
//  UnarchiveAlbumThread.m
//  Sketch Integration
//
//  Created by  on 12-5-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UnarchiveAlbumThread.h"

@implementation UnarchiveAlbumThread

-(void)main {
    NSLog(@"UnarchiveAlbumThread Run...");
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController.drawAlbumViewController initDataFromArchiver];
    NSLog(@"UnarchiveAlbumThread Finished");

}

@end
