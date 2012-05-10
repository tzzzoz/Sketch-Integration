//
//  ArchiveAlbumThread.m
//  Sketch Integration
//
//  Created by 付 乙荷 on 12-5-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ArchiveAlbumThread.h"

@implementation ArchiveAlbumThread

-(void)main {
    NSLog(@"ArchiveAlbumThread Run...");
    RootViewController *rootViewController = [RootViewController sharedRootViewController];
    [rootViewController.drawAlbumViewController saveDrawAlbum];
    NSLog(@"ArchiveAlbumThread Finished");
}
@end
