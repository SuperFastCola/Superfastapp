//
//  Page1.h
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperSoundPlayer.h"
#import "AnimateView.h"

@interface Page1 : UIViewController

@property (nonatomic, retain) SuperSoundPlayer* soundPlayer;
@property (nonatomic, retain) NSURL* soundFile;
@property (nonatomic, retain) AnimateView* sun;
@property (nonatomic, retain) AnimateView* asteroid1;

@end
