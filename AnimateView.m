//
//  AnimateView.m
//  SuperFastCola
//
//  Created by Anthony Baker on 8/16/14.
//  Copyright (c) 2014 com.anthony.baker. All rights reserved.
//

#import "AnimateView.h"

@implementation AnimateView

@synthesize viewToAnimate = _viewToAnimate;
@synthesize animationOptions;

-(id)initWithUIImageView:(UIImageView*)image thisAmountofSeconds: (float)seconds delayedFor:(float)delay andToXCoor:(float)xcoor andToYCoor:(float)ycoor andToOpacity: (float) opacity withOptions: (NSUInteger) opts andDelayRepeatfor: (float) repeatDelay
{
    self = [super init];
    
    if(self)
    {
    
        self.viewToAnimate = image;

        float secs = (seconds)?seconds:.5;
        float del = (delay)?delay:0;
        float xc = (xcoor)?xcoor:self.viewToAnimate.frame.origin.x;
        float yc = (ycoor)?ycoor:self.viewToAnimate.frame.origin.y;
        float opa = opacity;
                
        if(opts){
            self.animationOptions = opts;
        }
        else{
            self.animationOptions = UIViewAnimationOptionCurveLinear;
        }
        
        void (^animBlock) (void) = ^{
            
            CGPoint endPosition = CGPointMake(xc, yc);
            
            CGRect newFrame =  self.viewToAnimate.frame;
            newFrame.origin = endPosition;
            
            self.viewToAnimate.frame = newFrame;
            self.viewToAnimate.alpha = opa;
        };


        [UIView animateWithDuration:secs
                              delay:del
                            options: self.animationOptions
                         animations:animBlock
                         completion:nil];
            
        }
    
    return self;
}




@end
