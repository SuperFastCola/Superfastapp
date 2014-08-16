//
//  AnimateView.h
//  SuperFastCola
//
//  Created by Anthony Baker on 8/16/14.
//  Copyright (c) 2014 com.anthony.baker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AnimateView : NSObject

@property (nonatomic) UIImageView* viewToAnimate;
@property (nonatomic) NSUInteger animationOptions;

-(id)initWithUIImageView:(UIImageView*)image thisAmountofSeconds: (float)seconds delayedFor:(float)delay andToXCoor:(float)xcoor andToYCoor:(float)ycoor andToOpacity: (float) opacity withOptions: (NSUInteger) opts andDelayRepeatfor: (float) repeatDelay;

@end
