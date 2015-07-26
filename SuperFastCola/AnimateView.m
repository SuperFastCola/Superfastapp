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

-(id)initWithUIImageView:(UIImageView*)image thisAmountofSeconds: (float)seconds delayedFor:(float)delay andToXCoor:(float)xcoor andToYCoor:(float)ycoor andToOpacity: (float) opacity withOptions: (NSUInteger) opts andHideAfter: (BOOL) hide{
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
        
        void (^completeBlock) (BOOL) = ^(BOOL success){
            
            NSLog(@"%lu",(long)self.viewToAnimate.tag);
            
            if(hide){
            self.viewToAnimate.alpha = 1;
            [UIView animateWithDuration:secs
                                  delay:0
                                options: 0
                             animations:^{
                                self.viewToAnimate.alpha = 0;
                             }
                             completion:nil];
            }
            
        };
        
        

        [UIView animateWithDuration:secs
                              delay:del
                            options: self.animationOptions
                         animations:animBlock
                         completion:completeBlock];

            
        }
    
    return self;
}




@end
