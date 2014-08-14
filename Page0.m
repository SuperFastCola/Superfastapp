//
//  Page0.m
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "Page0.h"
#import "SuperSoundPlayer.h"
#import "AnimateView.h"

@interface Page0 ()

@end

@implementation Page0

@synthesize audioFile;
@synthesize missle;
@synthesize bird1;
@synthesize bird2;
@synthesize rocketFire;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"Touch");
    }
    return self;
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
    self.missle = [[AnimateView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:101]];
    
    double delayInSeconds = .25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);

    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        self.bird1 = [[AnimateView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:200]];
    });
    
    delayInSeconds = .45;
    popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        self.bird2 = [[AnimateView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:201]];
    });
    
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
