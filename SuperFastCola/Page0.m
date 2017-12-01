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
#import "BookPageViewController.h"

@interface Page0 ()

@end

@implementation Page0

@synthesize audioFile;
@synthesize missle;
@synthesize missleEyes;
@synthesize missleBlinkImages;
@synthesize bird1;
@synthesize bird2;
@synthesize rocketFire;
@synthesize mask;
@synthesize maskImage;
@synthesize tear1;
@synthesize tear2;
@synthesize tear3;
@synthesize tear4;
@synthesize bird1BlinkImages;
@synthesize bird2BlinkImages;
@synthesize birdBlinker;
@synthesize missleMouth1;
@synthesize missleMouth2;
@synthesize missleMouth3;
@synthesize missleMouth4;
@synthesize mouthAnimation;
@synthesize mouthTags;
@synthesize mouthControl;

@synthesize missleHitArea;
@synthesize mouth1;
@synthesize mouth2;
@synthesize mouth3;
@synthesize mouth4;


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
    @autoreleasepool {
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
        
    }
    [self.rocketFire startAnimating];
}

-(void)startBlinking{
    
    @autoreleasepool {
        
        float blinkDuration = 0.35;
        self.bird1BlinkImages = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"page_1_tlm_bird1_1.png"],
                                 [UIImage imageNamed:@"page_1_tlm_bird1_2.png"],
                                 nil
                                 ];
        
        ((UIImageView*) self.bird1.animateThisImage).animationImages =  self.bird1BlinkImages;
        ((UIImageView*) self.bird1.animateThisImage).animationRepeatCount = 1;
        ((UIImageView*) self.bird1.animateThisImage).animationDuration = blinkDuration;
        
        self.bird2BlinkImages = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"page_1_tlm_bird2_1.png"],
                                 [UIImage imageNamed:@"page_1_tlm_bird2_2.png"],
                                 nil
                                 ];
        ((UIImageView*) self.bird2.animateThisImage).animationImages =  self.bird2BlinkImages;
        ((UIImageView*) self.bird2.animateThisImage).animationRepeatCount = 1;
        ((UIImageView*) self.bird2.animateThisImage).animationDuration = blinkDuration;
        
        
        self.missleBlinkImages = [NSArray arrayWithObjects:
                                  [UIImage imageNamed:@"page_1_tlm_eyes_v1.png"],
                                  [UIImage imageNamed:@"page_1_tlm_eyes_v2.png"],
                                  nil
                                  ];
        self.missleEyes = (UIImageView*) [self.view viewWithTag:202];
        self.missleEyes.animationImages = self.missleBlinkImages;
        self.missleEyes.animationRepeatCount = 1;
        self.missleEyes.animationDuration = blinkDuration;
        
        self.birdBlinker = [NSTimer scheduledTimerWithTimeInterval:5  target:self selector:@selector(playBlinkers) userInfo:nil repeats:YES];
    }
}


-(void)playBlinkers{
    
    [((UIImageView*) self.bird1.animateThisImage) stopAnimating];
    [((UIImageView*) self.bird2.animateThisImage) stopAnimating];
    [self.missleEyes stopAnimating];
    
    [((UIImageView*) self.bird1.animateThisImage) startAnimating];
    
    int blinkRandom = 4;
    float randomBlink =  rand() % blinkRandom;
    
    dispatch_time_t blinkTime = dispatch_time(DISPATCH_TIME_NOW, randomBlink * NSEC_PER_SEC);
    dispatch_after(blinkTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [((UIImageView*) self.bird2.animateThisImage) startAnimating];
    });
    
    randomBlink =  rand() % blinkRandom;
    
    dispatch_time_t missleBlinkTime = dispatch_time(DISPATCH_TIME_NOW, randomBlink * NSEC_PER_SEC);
    dispatch_after(missleBlinkTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self.missleEyes startAnimating];
    });
    
}

-(void) drawMissleMouthParts{
    
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"page_1_tlm_mouth_v1" ofType:@"png"];
    self.missleMouth1 = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:imagePath]];
    
    imagePath = [[NSBundle mainBundle] pathForResource:@"page_1_tlm_mouth_v2" ofType:@"png"];
    self.missleMouth2 = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:imagePath]];
    
    imagePath = [[NSBundle mainBundle] pathForResource:@"page_1_tlm_mouth_v3" ofType:@"png"];
    self.missleMouth3 = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:imagePath]];
    
    imagePath = [[NSBundle mainBundle] pathForResource:@"page_1_tlm_mouth_v4" ofType:@"png"];
    self.missleMouth4 = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:imagePath]];
    
    imagePath = nil;
    
    CGRect mouthArea = [self.view viewWithTag:1399].frame;
    
    self.missleMouth1.frame = mouthArea;
    self.missleMouth2.frame = mouthArea;
    self.missleMouth3.frame = mouthArea;
    self.missleMouth4.frame = mouthArea;
    
    self.missleMouth1.tag = 1400;
    self.missleMouth2.tag = 1401;
    self.missleMouth3.tag = 1402;
    self.missleMouth4.tag = 1403;
    
    self.missleMouth1.alpha = 0;
    self.missleMouth2.alpha = 0;
    self.missleMouth3.alpha = 0;
    self.missleMouth4.alpha = 0;
    
    [[self.view viewWithTag:101] addSubview:self.missleMouth1];
    [[self.view viewWithTag:101] addSubview:self.missleMouth2];
    [[self.view viewWithTag:101] addSubview:self.missleMouth3];
    [[self.view viewWithTag:101] addSubview:self.missleMouth4];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    @autoreleasepool {
        
        self.missleHitArea  = CGRectMake(290, 340, 500, 110);
        
        // Do any additional setup after loading the view from its nib.
        self.missle = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:101] andPlaySound:@"lonely_page1_isolated"];
        self.missle.delegate = self;
        
        [self.missle addDetectionPath:self.missleHitArea];
        self.missle.pageNumber = 0;
        //[self.missle animateMouthOnTouch];
        
        double delayInSeconds = .25;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            self.bird1 = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:200] andPlaySound:@"bird_tweet"];
        });
        
        delayInSeconds = .45;
        popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            self.bird2 = [[SpringyView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:201] andPlaySound:@"bird_tweet"];
            [self startBlinking];
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
                       andHideAfter: NO
                       ];
        
        self.cloud2 = [[AnimateView alloc]
                       initWithUIImageView:(UIImageView*)[self.view viewWithTag:601]
                       thisAmountofSeconds:25
                       delayedFor:0
                       andToXCoor:[UIScreen mainScreen].bounds.size.width + 300
                       andToYCoor:0
                       andToOpacity:1.0
                       withOptions:(UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear)
                       andHideAfter: NO
                       ];
        
        
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
                      andHideAfter: NO
                      ];
        
        self.tear2 = [[AnimateView alloc]
                      initWithUIImageView:(UIImageView*)[self.view viewWithTag:902]
                      thisAmountofSeconds:1.5
                      delayedFor:.30
                      andToXCoor:0
                      andToYCoor:550
                      andToOpacity:0.1
                      withOptions:UIViewAnimationOptionRepeat
                      andHideAfter: NO
                      ];
        
        
    }
    //    [self drawMissleMouthParts];
    //    [self startRocketFire];
}

-(IBAction)tester:(id)sender{
    NSLog(@"Touch");
}

-(void) showMouthView: (UIView*) mouth{
    
    void (^animView) (void) = ^{
        mouth.alpha = 1.0;
    };
    
    [UIView animateWithDuration:.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:animView
                     completion:nil];
}

-(void) hideMouthView: (UIView*) mouth{
    
    void (^animView) (void) = ^{
        mouth.alpha = 0.0;
    };
    
    [UIView animateWithDuration:.05
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:animView
                     completion:nil];
}


- (void)playDialog{
    NSLog(@"Play Dialog");
    
    //1399,1401,1402,1399
    [self showMouthView:[self.view viewWithTag:1402]];
    [self hideMouthView:[self.view viewWithTag:1399]];
    
    double delayInSeconds = .25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self showMouthView:[self.view viewWithTag:1401]];
        [self.view viewWithTag:1402].alpha = 0;
        [self.view viewWithTag:1403].alpha = 0;
    });
    
    delayInSeconds = .5;
    popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.view viewWithTag:1399].alpha = 0;
        [self hideMouthView:[self.view viewWithTag:1401]];
        [self showMouthView:[self.view viewWithTag:1402]];
        [self.view viewWithTag:1403].alpha = 0;
    });
    
    delayInSeconds = .8;
    popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.view viewWithTag:1399].alpha = 0;
        [self.view viewWithTag:1401].alpha = 0;
        [self hideMouthView:[self.view viewWithTag:1402]];
        [self showMouthView:[self.view viewWithTag:1399]];
    });
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if([self isViewLoaded] && [self.view window]== nil){
        self.view = nil;
    }
}

-(void) nullifyObjects{
    NSLog(@"Destroying Objects");
    
    [self.birdBlinker invalidate];
    self.audioFile = nil;
    self.missle = nil;
    self.missleEyes = nil;
    self.bird1 = nil;
    self.bird2 = nil;
    self.cloud1 = nil;
    self.cloud2 = nil;
    self.tear1 = nil;
    self.tear2 = nil;
    self.tear3 = nil;
    self.tear4 = nil;
    self.mouthAnimation =nil;
    
    self.rocketFire = nil;
    self.animationImages = nil;
    self.bird1BlinkImages = nil;
    self.bird2BlinkImages = nil;
    self.birdBlinker = nil;
    
    self.mask = nil;
    self.maskImage = nil;
    
    self.view = nil;
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [self nullifyObjects];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    [self nullifyObjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


@end
