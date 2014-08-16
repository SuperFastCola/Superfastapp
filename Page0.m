//
//  Page0.m
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "Page0.h"
#import "SuperSoundPlayer.h"
#import "SpringyView.h"
#import "AnimateView.h"

@interface Page0 ()

@end

@implementation Page0

@synthesize audioFile;
@synthesize missle;
@synthesize bird1;
@synthesize bird2;
@synthesize rocketFire;
@synthesize mask;
@synthesize maskImage;
@synthesize tear1;
@synthesize tear2;
@synthesize tear3;
@synthesize tear4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"Touch");
    }
    return self;
}

-(void)animateClouds:(UIImageView*)cloud inThisAmountOfTime:(float)seconds {
    
    void (^animCloud) (void) = ^{
        
        NSLog(@"%f",cloud.bounds.origin.y);
        CGPoint endPosition = CGPointMake(([UIScreen mainScreen].bounds.size.width + cloud.bounds.size.width), cloud.frame.origin.y);
        
        CGRect newFrame = cloud.frame;
        newFrame.origin = endPosition;
        
        cloud.frame = newFrame;
        cloud.alpha = 1.0;
    };
    
    [UIView animateWithDuration:seconds
                          delay:0
                        options: (UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear)
                     animations:animCloud
                     completion:nil];
}
    
-(void)startRocketFire
{
    self.animationImages = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"page_1_tlm_flames0.png"],
                                [UIImage imageNamed:@"page_1_tlm_flames1.png"],
                                [UIImage imageNamed:@"page_1_tlm_flames2.png"],
                                [UIImage imageNamed:@"page_1_tlm_flames3.png"],
                                [UIImage imageNamed:@"page_1_tlm_flames4.png"],
                                [UIImage imageNamed:@"page_1_tlm_flames5.png"],
                                [UIImage imageNamed:@"page_1_tlm_flames6.png"],
                                [UIImage imageNamed:@"page_1_tlm_flames7.png"],
                                [UIImage imageNamed:@"page_1_tlm_flames8.png"],
                                [UIImage imageNamed:@"page_1_tlm_flames9.png"],
//                                [UIImage imageNamed:@"page_1_tlm_flames5.png"],
//                                [UIImage imageNamed:@"page_1_tlm_flames4.png"],
//                                [UIImage imageNamed:@"page_1_tlm_flames3.png"],
//                                [UIImage imageNamed:@"page_1_tlm_flames2.png"],
//                                [UIImage imageNamed:@"page_1_tlm_flames1.png"],
//                                [UIImage imageNamed:@"page_1_tlm_flames0.png"],

                                nil];
    
    self.rocketFire = (UIImageView*)[self.view viewWithTag:500];
    self.rocketFire.animationImages = self.animationImages;
    self.rocketFire.animationRepeatCount = 0;
    self.rocketFire.animationDuration= 5;
    [self.rocketFire startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.missle = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:101]];
    
    double delayInSeconds = .25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);

    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        self.bird1 = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:200]];
    });
    
    delayInSeconds = .45;
    popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        self.bird2 = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:201]];
    });
    
   // [self animateClouds:(UIImageView*)[self.view viewWithTag:600] inThisAmountOfTime:10];

    
    self.cloud1 = [[AnimateView alloc]
                    initWithUIImageView:(UIImageView*)[self.view viewWithTag:600]
                    thisAmountofSeconds:20
                    delayedFor:12
                    andToXCoor:[UIScreen mainScreen].bounds.size.width + 200
                    andToYCoor:0
                    andToOpacity:1.0
                    withOptions:(UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear)
                   andDelayRepeatfor:0];
    
    self.cloud2 = [[AnimateView alloc]
                   initWithUIImageView:(UIImageView*)[self.view viewWithTag:601]
                   thisAmountofSeconds:25
                   delayedFor:0
                   andToXCoor:[UIScreen mainScreen].bounds.size.width + 300
                   andToYCoor:0
                   andToOpacity:1.0
                   withOptions:(UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear)
                   andDelayRepeatfor:0];
    
    
    self.mask = [CALayer layer];
    self.maskImage = [UIImage imageNamed:@"page_1_tlm_cloud_mask.png"];
    self.mask.contents = (id)[self.maskImage CGImage];
    self.mask.frame = CGRectMake(0, 0,self.maskImage.size.width, self.maskImage.size.height);
    
    [self.view viewWithTag:800].layer.mask = self.mask;
    [self.view viewWithTag:800].layer.masksToBounds = YES;
    
    
    
    self.tear1 = [[AnimateView alloc]
                   initWithUIImageView:(UIImageView*)[self.view viewWithTag:901]
                   thisAmountofSeconds:1
                   delayedFor:.25
                   andToXCoor:0
                   andToYCoor:550
                   andToOpacity:0.1
                   withOptions:UIViewAnimationOptionRepeat
                   andDelayRepeatfor:1];
    
    self.tear2 = [[AnimateView alloc]
                  initWithUIImageView:(UIImageView*)[self.view viewWithTag:902]
                  thisAmountofSeconds:1.5
                  delayedFor:.30
                  andToXCoor:0
                  andToYCoor:550
                  andToOpacity:0.1
                  withOptions:UIViewAnimationOptionRepeat
                  andDelayRepeatfor:1];

    
    
    [self startRocketFire];

    
}

-(IBAction)tester:(id)sender{
    NSLog(@"Touch");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if([self isViewLoaded] && [self.view window]== nil){
        self.view = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


@end
