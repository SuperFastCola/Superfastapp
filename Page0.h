//
//  Page0.h
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpringyView.h"
#import "AnimateView.h"

@interface Page0 : UIViewController

@property (nonatomic) NSString* audioFile;
@property (nonatomic, retain) SpringyView* missle;
@property (nonatomic, retain) SpringyView* bird1;
@property (nonatomic, retain) SpringyView* bird2;
@property (nonatomic, retain) AnimateView* cloud1;
@property (nonatomic, retain) AnimateView* cloud2;
@property (nonatomic, retain) AnimateView* tear1;
@property (nonatomic, retain) AnimateView* tear2;
@property (nonatomic, retain) AnimateView* tear3;
@property (nonatomic, retain) AnimateView* tear4;

@property (nonatomic,retain) UIImageView* rocketFire;
@property (nonatomic, retain) NSArray *animationImages;

@property (nonatomic, retain) CALayer *mask;
@property (nonatomic, retain) UIImage *maskImage;

-(void)animateClouds:(UIImageView*)cloud inThisAmountOfTime:(float)seconds;
-(void)startRocketFire;
-(IBAction)tester:(id)sender;

@end
