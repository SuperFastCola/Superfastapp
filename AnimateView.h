//
//  AnimateView.h
//  SuperFastCola
//
//  Created by Anthony Baker on 1/1/14.
//  Copyright (c) 2014 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <QuartzCore/QuartzCore.h>

@interface AnimateView : UIView
@property (nonatomic,retain) UIView* animateThisImage;
@property (nonatomic) UITapGestureRecognizer* tapAction;
@property (nonatomic) CGPoint viewCenter;
@property (nonatomic) UIPanGestureRecognizer* dragObject;
@property (nonatomic) Boolean snapping;
@property (nonatomic) Boolean animating;
@property (nonatomic) Boolean dragging;
@property (nonatomic) Boolean inBounds;
@property (nonatomic) CGPoint outOfBoundsAt;
@property (nonatomic) float snapBackAt;

- (id)initWithImageView: (UIImageView*) imageView;
-(void) addTapRecognizer;
- (void)jiggle:(UITapGestureRecognizer *)sender;
@end
