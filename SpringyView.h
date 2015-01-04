//
//  AnimateView.h
//  SuperFastCola
//
//  Created by Anthony Baker on 1/1/14.
//  Copyright (c) 2014 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@protocol dialoger <NSObject>
-(void) playDialog;
@end

@interface SpringyView : UIView
@property (nonatomic) UIView* animateThisImage;
@property (nonatomic) UITapGestureRecognizer* tapAction;
@property (nonatomic) CGPoint viewCenter;
@property (nonatomic) UIPanGestureRecognizer* dragObject;
@property (nonatomic) Boolean snapping;
@property (nonatomic) Boolean animating;
@property (nonatomic) Boolean dragging;
@property (nonatomic) Boolean inBounds;
@property (nonatomic) CAKeyframeAnimation* anim1;
@property (nonatomic) CGPoint outOfBoundsAt;
@property (nonatomic) CGRect detectionPath;
@property (nonatomic) Boolean useDetectionPath;
@property (nonatomic) AVAudioPlayer* soundPlayer;
@property (nonatomic) NSURL* soundFileUrl;
@property (nonatomic) NSArray* animateTagsOnTouch;
@property (nonatomic) NSArray* animateTagsWithCues;
@property (nonatomic) int pageNumber;
@property (nonatomic, weak) id delegate;

@property (nonatomic) float snapBackAt;

- (id)initWithImageView:(UIImageView*) imageView andPlaySound: (NSString*) soundfile;
-(void) addTapRecognizer;
-(void) floatingInSpace: (UIView*) floater;
-(void)jiggle:(UITapGestureRecognizer *)sender;
-(void) addDetectionPath: (CGRect) path;
-(float)returnRadians:(float)usingPercentage :(float)ofRadians;
-(CGPoint)returnPoint:(float)usingDistance :(float)withX :(float)withY :(float)andRadians;
-(void) snapBackAnimation:(float)currentX :(float)currentY :(float)distance;
- (void) panning: (UIPanGestureRecognizer*) gesture;
-(void)animationDidStart:(CAAnimation *)theAnimation;
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;
//-(void)animateMouthOnTouch;
//-(void) animateTags: (NSArray*) tag usingDelay: (NSArray*) cues;

@end
