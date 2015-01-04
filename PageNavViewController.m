//
//  PageNavViewController.m
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "PageNavViewController.h"
#import "PageNavThumbnail.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface PageNavViewController ()

@end

@implementation PageNavViewController

@synthesize pageThumbnailsSource;
@synthesize thumbsHolder;
@synthesize thumbWidth;
@synthesize thumbHeight;
@synthesize thumbSpacing;
@synthesize delegate;
@synthesize currentNavX;
@synthesize widthDiff;
@synthesize backedUpVar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil usingPages: (NSMutableArray*) pages
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pageThumbnailsSource = pages;
    

        
        
        self.thumbWidth = 150;
        self.thumbHeight = 113;
        self.thumbSpacing = 20;
        
        int viewSize = (int)([pageThumbnailsSource count] * (self.thumbWidth + self.thumbSpacing));
        viewSize -= self.thumbSpacing;
        self.thumbsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize, 113)];
        self.thumbsHolder.userInteractionEnabled = YES;
    }
    return self;
}

-(void) resizeMainHolder{
    
    CGPoint position = CGPointMake(0, 768);
    CGRect newFrame = self.view.frame;
    newFrame.origin = position;
    self.view.frame = newFrame;
}

-(void) animatePageNavView{

    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 160);
    } completion:^(BOOL finished){
   
    }];
}

-(void) animatePageNavViewOutOfFrame{

    void (^deletePageNav) (BOOL) = ^(BOOL success){
        [self.thumbsHolder removeFromSuperview];
        [[self.view viewWithTag:300] removeFromSuperview];
        
        self.pageThumbnailsSource = nil;
        
//        for (UIView* delete in [self.thumbsHolder subviews]) {
//            [delete removeFromSuperview];
//        }
        
//        self.thumbsHolder = nil;
        
        [self.view removeFromSuperview];
        [self.delegate deletePageNavController:self];
        self.delegate = nil;
        
    };
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        //self.view.alpha = 1.0;
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 160);
    } completion:deletePageNav];

}

-(IBAction) hidePageNavView{
    [self animatePageNavViewOutOfFrame];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resizeMainHolder];
    
    self.delegate = [self parentViewController];
    
    self.backedUpVar = 12;
    
    int start = 75;
    int page = 0;
    
    @autoreleasepool {

    PageNavThumbnail* temp;
    
    for (NSString *element in pageThumbnailsSource) {
        temp = [[PageNavThumbnail alloc] initWithImageSource:element AndPageNumber:page PassingDelegate:self.parentViewController];
        temp.center = CGPointMake(start, 56.5);
        
        [thumbsHolder addSubview:temp];
    
        
        start += (thumbWidth + thumbSpacing);
        page++;
    }
        
    temp = nil;

    
    [[self.view viewWithTag:300] addSubview:thumbsHolder];
    [self.view viewWithTag:300].clipsToBounds = YES;

    }// end autorelease

    [self animatePageNavView];
    UIPanGestureRecognizer* p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panning:)];
    [thumbsHolder addGestureRecognizer:p];
    
}

// http://www.raywenderlich.com/6567/uigesturerecognizer-tutorial-in-ios-5-pinches-pans-and-more

- (void) panning: (UIPanGestureRecognizer*) recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateBegan){
        
        CGPoint translation = [recognizer translationInView:thumbsHolder];
        //recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        
        self.currentNavX =  CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
        
        //get difference of size between thumbsHolder and its container
        UIView * allslidesHolder = [self.view viewWithTag:300];
        self.widthDiff = allslidesHolder.frame.size.width - recognizer.view.frame.size.width;
        self.widthDiff *= (self.widthDiff<0)?-1.0:1.0;
        allslidesHolder = nil;
        
        //get left limit position of thumbsHolder
        self.leftLimit = recognizer.view.frame.size.width/2 - self.widthDiff;
        
        //get right limit position of thumbsHolder
        self.rightLimit = recognizer.view.frame.size.width/2;
        
        if(self.currentNavX.x > self.rightLimit){
            self.currentNavX = CGPointMake(self.rightLimit, recognizer.view.center.y);
        }
        else if(self.currentNavX.x < self.leftLimit){
            self.currentNavX = CGPointMake(self.leftLimit, recognizer.view.center.y);
        }
        
        recognizer.view.center = self.currentNavX;
        [recognizer setTranslation:CGPointMake(0, 0) inView:thumbsHolder];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:thumbsHolder];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 500;
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),recognizer.view.center.y);
        
        if(finalPoint.x > self.rightLimit){
            finalPoint.x=self.rightLimit;
        }
        else if(finalPoint.x < self.leftLimit){
            finalPoint.x=self.leftLimit;
        }
        //finalPoint.x = MIN(MAX(finalPoint.x, 0), thumbsHolder.bounds.size.width);
        //finalPoint.y = MIN(MAX(finalPoint.y, 0), thumbsHolder.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];

    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //nullify the temp image and thumbnails array
    
    for (NSString *element in pageThumbnailsSource){
        //remove element from array
        [pageThumbnailsSource removeObject:element];
    }
    
    pageThumbnailsSource = nil;
    
    // Dispose of any resources that can be recreated.
}

@end
