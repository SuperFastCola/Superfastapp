//
//  Page0.h
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimateView.h"

@interface Page0 : UIViewController

@property (nonatomic) NSString* audioFile;
@property (nonatomic, retain) AnimateView* missle;
@property (nonatomic, retain) AnimateView* bird1;
@property (nonatomic, retain) AnimateView* bird2;
@property (nonatomic,retain) UIImageView* rocketFire;
@property (nonatomic, retain) NSArray *animationImages;

-(IBAction)tester:(id)sender;

@end
