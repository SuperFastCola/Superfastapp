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
         
         self.sign.transform = CGAffineTransformMakeRotation( DegreesToRadians(-180));
         
         [self rotateSign];

     }
    
}

-(void) rotateSign{

    [UIView animateWithDuration:0.25f delay:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.sign.transform = CGAffineTransformMakeRotation( DegreesToRadians(0));
    } completion:^(BOOL finished) {
        
    }];
    
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
