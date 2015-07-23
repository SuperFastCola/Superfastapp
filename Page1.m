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
@synthesize moon;
@synthesize missle_day;
@synthesize mask;
@synthesize maskImage;
@synthesize clouds;
@synthesize sign;
@synthesize animationImages;
@synthesize rocketFire;

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
         self.sun = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:300] andPlaySound:nil];
         self.moon = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:301] andPlaySound:nil];
         
         double delayInSeconds = .25;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             //code to be executed on the main queue after delay
             self.missle_day = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:200] andPlaySound:nil];
         });
         
         [self startRocketFire];
         
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
         [self rotateSign:YES:0.25f:4.0f];
         
         delayInSeconds = 3.5;
         dispatch_time_t sniffOne = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(sniffOne, dispatch_get_main_queue(), ^(void){
             [self fadeInView:201:0];
         });
         
         delayInSeconds = 4.25;
         dispatch_time_t sniffOneOut = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(sniffOneOut, dispatch_get_main_queue(), ^(void){
             [self fadeOutView:201];
         });
         
         delayInSeconds = 8.25;
         dispatch_time_t signPutAway = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(signPutAway, dispatch_get_main_queue(), ^(void){
            [self rotateSign:NO:0.25f:0.0f];
         });
         
         delayInSeconds = 9.0;
         dispatch_time_t signReappear = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(signReappear, dispatch_get_main_queue(), ^(void){
             [self rotateSign:YES:0.25f:0.0f];
         });
         
         delayInSeconds = 9.25;
         dispatch_time_t hideElements = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(hideElements, dispatch_get_main_queue(), ^(void){
             [self fadeInView:102:0];
             [self fadeOutView:401];
             [self fadeOutView:300];
             [self fadeOutView:202];
             [self fadeInView:203:0];
             [self.view viewWithTag:104].alpha = 0;
             [self.view viewWithTag:105].alpha = 1;
             [self animateNightBackground];
         });
         
         

     }
}

//[self fadeOutView:201];
//[self fadeInView:204];


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

-(void) fadeInView:(int)WithTag : (float)UsingDuration{
    void (^fadeIn) (void) = ^{
        [self.view viewWithTag:WithTag].alpha = 1.0;
    };

    
    [UIView animateWithDuration: ((UsingDuration==0)?0.1:UsingDuration)
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

-(void)startRocketFire
{
    @autoreleasepool {
        self.animationImages = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"page_2_flame1.png"],
                                [UIImage imageNamed:@"page_2_flame2.png"],
                                [UIImage imageNamed:@"page_2_flame3.png"],
                                [UIImage imageNamed:@"page_2_flame4.png"],
                                nil];
        
        self.rocketFire = (UIImageView*)[self.view viewWithTag:205];
        self.rocketFire.animationImages = self.animationImages;
        self.rocketFire.animationRepeatCount = 0;
        self.rocketFire.animationDuration= .1;
        
    }
    [self.rocketFire startAnimating];
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
