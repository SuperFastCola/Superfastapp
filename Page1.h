//
//  Page1.h
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpringyView.h"
#import "AnimateView.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface Page1 : UIViewController
@property (nonatomic, retain) SpringyView* planet;
@property (nonatomic, retain) SpringyView* sun;
@property (nonatomic, retain) SpringyView* missle_day;
@property (nonatomic, retain) AnimateView* clouds;

@property (nonatomic, retain) CALayer *mask;
@property (nonatomic, retain) UIImage *maskImage;
@property (nonatomic, retain) UIView* sign;


@end
