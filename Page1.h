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
//http://cocoamatic.blogspot.com/2010/07/uicolor-macro-with-hex-values.html

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Page1 : UIViewController
@property (nonatomic, retain) SpringyView* planet;
@property (nonatomic, retain) SpringyView* sun;
@property (nonatomic, retain) SpringyView* moon;
@property (nonatomic, retain) SpringyView* missle_day;
@property (nonatomic, retain) AnimateView* clouds;
@property (nonatomic, retain) NSArray *animationImages;
@property (nonatomic,retain) UIImageView* rocketFire;

@property (nonatomic, retain) CALayer *mask;
@property (nonatomic, retain) UIImage *maskImage;
@property (nonatomic, retain) UIView* sign;


@end
