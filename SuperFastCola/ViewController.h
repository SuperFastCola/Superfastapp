//
//  ViewController.h
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PageNavViewController.h"
#import "PageNavThumbnail.h"
#import "BookPageViewController.h"
#import "SuperSoundPlayer.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource, pageTurner,removePageNavController>

@property (nonatomic, retain) UIPageViewController *pageController;
@property (nonatomic, retain) NSArray * viewControllers;
@property (nonatomic) BookPageViewController *childViewController;
@property (nonatomic) int totalPages;
@property (nonatomic, retain) AVAudioSession* audioSession;
@property (nonatomic, retain) UIViewController * pageNavigation;
@property (nonatomic, retain) NSMutableArray* comicPages;
@property (nonatomic, retain) UIButton* mainMenu;
@property (nonatomic) BOOL pageNavigationLoaded;
@property (nonatomic,retain) NSDictionary* pages_data;
@property (nonatomic, retain) SuperSoundPlayer* soundPlayer;
@property (nonatomic) NSURL* soundFileURL;
@property (nonatomic) NSUInteger mainPageNumber;
@property (nonatomic) NSUInteger initialPageNumber;
@property (nonatomic) NSDictionary* sound_data_object;

-(void) changePage: (int) toSelected;
-(void) checkForSoundAndPlay;
- (BookPageViewController *)viewControllerAtIndex:(NSUInteger)index;
-(void) showPageNavigation: (UIButton*) sender;
-(void) deletePageNavController: (UIViewController*) navigation;

@end
