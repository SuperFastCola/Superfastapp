//
//  PageNavViewController.h
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol removePageNavController <NSObject>
-(void) deletePageNavController: (UIViewController*) navigation;
@end

@interface PageNavViewController : UIViewController

@property (nonatomic, weak) NSMutableArray* pageThumbnailsSource;
@property (nonatomic, weak) UIViewController* pageSelector;
@property (nonatomic, retain) UIView* thumbsHolder;
@property (nonatomic) int thumbWidth;
@property (nonatomic) int thumbHeight;
@property (nonatomic) int thumbSpacing;
@property (nonatomic) CGPoint currentNavX;
@property (nonatomic) int widthDiff;
@property (nonatomic) int leftLimit;
@property (nonatomic) int rightLimit;

@property (nonatomic) id delegate;

-(void) animatePageNavView;
-(void) resizeMainHolder;
-(void) animatePageNavViewOutOfFrame;
-(IBAction) hidePageNavView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil usingPages: (NSMutableArray*) pages;

@end
