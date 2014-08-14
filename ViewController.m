//
//  ViewController.m
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "ViewController.h"
#import "PageNavViewController.h"
#import "BookPageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize parentViewController;
@synthesize childViewController;
@synthesize totalPages;
@synthesize audioSession;
@synthesize pageNavigation;
@synthesize viewControllers;
@synthesize comicPages;
@synthesize mainMenu;
@synthesize pageNavigationLoaded;
@synthesize pages_data;
@synthesize soundPlayer;
@synthesize soundFileURL;
@synthesize mainPageNumber;
@synthesize sound_data_object;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mainPageNumber = 0;
        @autoreleasepool {
            NSURL* jsonFile = [[NSBundle mainBundle] URLForResource:@"sounds_files" withExtension:@"json"];
            NSData* data = [NSData dataWithContentsOfURL:jsonFile];
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data //1
                                  options:kNilOptions
                                  error:nil];
            self.pages_data = [json objectForKey:@"pages"]; //2
        
            
            // set variables to nil to be released.
            jsonFile = nil;
            data = nil;
            json = nil;
        }
    
        self.sound_data_object = [[NSDictionary alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageNavigationLoaded = NO;
    
    //need to set width to 1024 and height to 768 on initial load
    //initial load is in portrait format
    self.view.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    
    self.mainMenu = [[UIButton alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.width - 80, 152, 65)];
    
    [self.mainMenu setBackgroundImage:[UIImage imageNamed:@"page_nav_menu.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.mainMenu];
    [self.mainMenu addTarget:self action:@selector(showPageNavigation:) forControlEvents:UIControlEventTouchDown];

    //adds the initial page view controller
    [self addChildViewController:self.pageController];
    [self.view insertSubview:[self.pageController view] belowSubview:self.mainMenu];
    [self.pageController didMoveToParentViewController:self];
    
    [self changePage:0];

    
    for (UIGestureRecognizer* g in self.pageController.gestureRecognizers){
        g.delegate = (id) self; // give me a chance to veto navigation
    }
    
    //not including 0
    self.totalPages = 5;
    
    self.comicPages = [[NSMutableArray alloc] init];
    for(int count =0; count<=self.totalPages; count++){
        [self.comicPages addObject:[NSString stringWithFormat:@"%@%i%@", @"page_", count,@"-thumb.jpg"]];
    }

    
    //initialize the audio session
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
    
    //[self performSelector:@selector(showPageNavigation) withObject:nil afterDelay:1];
}

-(void) checkForSoundAndPlay{
    
    NSLog(@"---%@",[self.pages_data objectForKey:[NSString stringWithFormat:@"%@%i", @"page",self.childViewController.pageNumber]]);
    NSLog(@"%i",self.childViewController.pageNumber);
    
    if([self.pages_data objectForKey:[NSString stringWithFormat:@"%@%i", @"page",self.childViewController.pageNumber]]){
        self.sound_data_object = [self.pages_data objectForKey:[NSString stringWithFormat:@"%@%i", @"page",self.childViewController.pageNumber]];
    
    self.soundFileURL = [[NSBundle mainBundle] URLForResource:[self.sound_data_object objectForKey:@"soundfile"] withExtension:[self.sound_data_object objectForKey:@"audiotype"]];
        
    self.soundPlayer = [[SuperSoundPlayer alloc] initWithContentsOfURL:self.soundFileURL forView:self.childViewController.view  andAnimateLabels:[self.sound_data_object objectForKey:@"tags"] withTimeCues:[self.sound_data_object objectForKey:@"cues"] error:nil];
    }
}

-(void) changePage: (int) toSelected{
    
   // UIViewController* remove = childViewController;
    

    //This command seems to be causing memory warnings
    //[[[self.viewControllers objectAtIndex:0] view] removeFromSuperview];
    
    @autoreleasepool {
        self.pageController.dataSource = self;
        [[self.pageController view] setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
        self.viewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:toSelected]];
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    
    [(PageNavViewController*) self.pageNavigation animatePageNavViewOutOfFrame];
    
    
//    [remove willMoveToParentViewController:nil];
//    [remove.view removeFromSuperview];
//    [remove removeFromParentViewController];
    
    //[self stopSoundPlayer];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    @autoreleasepool {
        
    self.mainPageNumber = [(BookPageViewController *)viewController pageNumber];
        
//    [viewController willMoveToParentViewController:nil];
//    [viewController.view removeFromSuperview];
//    [viewController removeFromParentViewController];
        
    
    if (self.mainPageNumber == 0) {
        self.mainPageNumber = self.totalPages;
        return [self viewControllerAtIndex:self.mainPageNumber];
    }
    
    self.mainPageNumber--;
    
    return [self viewControllerAtIndex:self.mainPageNumber];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    @autoreleasepool {

    self.mainPageNumber = [(BookPageViewController *)viewController pageNumber];
        
//    [viewController willMoveToParentViewController:nil];
//    [viewController.view removeFromSuperview];
//    [viewController removeFromParentViewController];
    
    if (self.mainPageNumber == self.totalPages) {
        self.mainPageNumber = 0;
        return [self viewControllerAtIndex:self.mainPageNumber];
    }
    
    self.mainPageNumber++;
    
    return [self viewControllerAtIndex:self.mainPageNumber];
        
    }
    
}


- (BookPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    [self.soundPlayer stopSoundPlayer];
    
    //BookPageViewController *childViewController = [[BookPageViewController alloc] initWithNibName:@"BookPageViewController" bundle:nil];

    //@autoreleasepool {
        self.childViewController = [[BookPageViewController alloc] init];
        self.childViewController.pageNumber = index;
        self.childViewController.delegate = self;
    
        [self checkForSoundAndPlay];

    //}
    
    return childViewController;
}

//this funciton was to test delegation to the top-level viewcontroller
//-(void)displayPage: (UIViewController*) fromController{
//    NSLog(@"%@",[fromController description]);
//}

#pragma mark Audio Player Delgation Function

- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
    NSLog(@"Begin Interruption %@", [player description]);
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    NSLog(@"End Interruption %@", [player description]);
      NSLog(@"Flags %i", flags);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Finished %@", [player description]);
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
         NSLog(@"Error on Player %@", [player description]);
         NSLog(@"Error %@", [error description]);
}

-(IBAction)tester:(id)sender{
    NSLog(@"--Touch");
}

#pragma mark - Audio Playing Events



-(void) showPageNavigation: (UIButton*) sender{
    
    @autoreleasepool {
        
    if(!self.pageNavigationLoaded){
        self.pageNavigation = [[PageNavViewController alloc] initWithNibName:@"PageNavViewController" bundle:nil usingPages:self.comicPages];
        [self addChildViewController:self.pageNavigation];
        [self.view addSubview:self.pageNavigation.view];
        self.pageNavigationLoaded = YES;
        
    }
        
        NSLog(@"%i", [(PageNavViewController*) self.pageNavigation backedUpVar]);
        
    }

    //[self presentViewController:pageNavigation animated:YES completion:nil];

//    
//    NSLog(@"%f",pageNavigation.view.bounds.size.width);
//    NSLog(@"%f",pageNavigation.view.bounds.size.height);
}

-(void) deletePageNavController: (UIViewController*) navigation{
    self.pageNavigationLoaded = NO;
    [self.pageNavigation removeFromParentViewController];
    self.pageNavigation = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    CGPoint loc = [gestureRecognizer locationInView:self.view];
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    } else {

        if(loc.x<75 || loc.x> [UIScreen mainScreen].bounds.size.height - 75){
            return YES;
        }
        else{
            return NO;
        }

    }
    
     return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    if ((interfaceOrientation==UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation==UIInterfaceOrientationLandscapeRight)) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
