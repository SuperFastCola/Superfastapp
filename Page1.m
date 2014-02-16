//
//  Page1.m
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "Page1.h"
#import "SuperSoundPlayer.h"
#import "AnimateView.h"

@interface Page1 ()

@end

@implementation Page1

@synthesize soundPlayer;
@synthesize soundFile;
@synthesize sun;
@synthesize asteroid1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        @autoreleasepool {
          self.soundFile = [[NSBundle mainBundle] URLForResource:@"suki_intro_v1" withExtension:@"mp3"];
          self.soundPlayer = [[SuperSoundPlayer alloc] initWithContentsOfURL:self.soundFile forView:self.view andAnimateLabels:@"401,402,403,404" withTimeCues:@"0.5,3,6,8.5" error:nil];
    }

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sun = [[AnimateView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:302]];
    
    double delayInSeconds = .25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        self.asteroid1 = [[AnimateView alloc] initWithImageView: (UIImageView*)[self.view viewWithTag:304]];
    });
    
}

- (void)viewDidUnload{
    [self.soundPlayer stopSoundPlayer];
    self.soundPlayer = nil;
    self.soundFile = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.soundPlayer stopSoundPlayer];
    self.soundPlayer = nil;
    self.soundFile = nil;
    // Do any additional setup after loading the view from its nib.
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
