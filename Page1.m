//
//  Page1.m
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "Page1.h"
#import "SuperSoundPlayer.h"
#import "SpringyView.h"
#import "AnimateView.h"

@implementation Page1

@synthesize planet;
@synthesize sun;
@synthesize missle_day;
@synthesize mask;
@synthesize maskImage;
@synthesize clouds;
@synthesize sign;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        @autoreleasepool {

        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     @autoreleasepool {
         
         self.planet = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:100] andPlaySound:nil];
    
         double delayInSeconds = .5;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             //code to be executed on the main queue after delay
             self.sun = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:300] andPlaySound:nil];
         });
         
        delayInSeconds = .25;
        popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             //code to be executed on the main queue after delay
             self.missle_day = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:200] andPlaySound:nil];
         });
         
         self.mask = [CALayer layer];
         self.maskImage = [UIImage imageNamed:@"page_2_tlm_parts_page2_cloud_mask.png"];
         self.mask.contents = (id)[self.maskImage CGImage];
         self.mask.frame = CGRectMake(0, 0,self.maskImage.size.width, self.maskImage.size.height);
         
         [self.view viewWithTag:400].layer.mask = self.mask;
         [self.view viewWithTag:400].layer.masksToBounds = YES;
         
         self.sign = (UIImageView*)[self.view viewWithTag:103];
         
         self.clouds = [[AnimateView alloc]
                        initWithUIImageView:(UIImageView*)[self.view viewWithTag:401]
                        thisAmountofSeconds:10
                        delayedFor:0
                        andToXCoor:420
                        andToYCoor:0
                        andToOpacity:1.0
                        withOptions:(UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear)
                        andHideAfter: NO
                        ];
         
         self.sign.layer.AnchorPoint = CGPointMake(0,0.5);
         
         CGRect newFrame = self.sign.frame;
         newFrame.origin = CGPointMake(273, 62);
         
         self.sign.frame = newFrame;
         [self rotateSign:YES:0.25f:1.5f];
         
         delayInSeconds = 5.0;
         dispatch_time_t signPutAway = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(signPutAway, dispatch_get_main_queue(), ^(void){
            [self rotateSign:NO:0.25f:0.0f];
         });
         
         delayInSeconds = 5.5;
         dispatch_time_t signReappear = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(signReappear, dispatch_get_main_queue(), ^(void){
             [self fadeInView:102];
             [self.view viewWithTag:104].alpha = 0;
             [self.view viewWithTag:105].alpha = 1;
             [self rotateSign:YES:0.25f:0.0f];
             [self animateNightBackground];
         });
     }
}


-(void) animateNightBackground{
    void (^changeColor) (void) = ^{
        [self.view viewWithTag:400].backgroundColor = UIColorFromRGB(0x0D68C2);
    };
    
    [UIView animateWithDuration:.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:changeColor
                     completion:nil];

}

-(void) fadeInView:(int)WithTag{
    void (^fadeIn) (void) = ^{
        [self.view viewWithTag:WithTag].alpha = 1.0;
    };
    
    [UIView animateWithDuration:.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:fadeIn
                     completion:nil];
}

-(void) fadeOutView:(int)WithTag{
    void (^fadeOut) (void) = ^{
        [self.view viewWithTag:WithTag].alpha = 0.0;
    };
    
    [UIView animateWithDuration:.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:fadeOut
                     completion:nil];
}


-(void) rotateSign:(Boolean)In :(float)forDuration :(float)andDelay{

    if(In==YES){
        self.sign.transform = CGAffineTransformMakeRotation( DegreesToRadians(-180));
        
        [UIView animateWithDuration:forDuration delay:andDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.sign.transform = CGAffineTransformMakeRotation( DegreesToRadians(0));
        } completion:^(BOOL finished) {
        }];
    }else{
        self.sign.transform = CGAffineTransformMakeRotation( DegreesToRadians(0));
        
        [UIView animateWithDuration:forDuration delay:andDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.sign.transform = CGAffineTransformMakeRotation( DegreesToRadians(-180));
        } completion:^(BOOL finished) {
        }];
    }
    
    
}


- (void)viewDidUnload{
    [super viewDidUnload];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if([self isViewLoaded] && [self.view window]== nil){
        self.view = nil;
    }
}



@end
