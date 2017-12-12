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
@synthesize totalPages = _totalPages;
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
@synthesize initialPageNumber;
@synthesize sound_data_object;
@synthesize arrow_next;
@synthesize arrow_prev;
@synthesize _pageIsAnimating;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mainPageNumber = 0;
        self.totalPages = 5;
        
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

    
    self.pageController.view.bounds = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    self.pageNavigationLoaded = NO;
    
    //need to set width to 1024 and height to 768 on initial load
    //initial load is in portrait format
    self.view.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    self.mainMenu = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 152, 65)];
    [self.mainMenu setBackgroundImage:[UIImage imageNamed:@"page_nav_menu.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.mainMenu];
    [self.mainMenu addTarget:self action:@selector(showPageNavigation:) forControlEvents:UIControlEventTouchDown];
    
    int arrow_width = 40;
    int arrow_side_space = 10;
    float left_side = [[UIScreen mainScreen] bounds].size.width - (arrow_width + arrow_side_space);
    float mid_point = ([[UIScreen mainScreen] bounds].size.height/2) - (arrow_width/2);
    
    self.arrow_prev = [[UIButton alloc] initWithFrame:CGRectMake(arrow_side_space, mid_point, arrow_width, arrow_width)];
    [self.arrow_prev setBackgroundImage:[UIImage imageNamed:@"arrows-02.png"] forState:UIControlStateNormal];
    self.arrow_prev.alpha = .2;
    self.arrow_prev.tag = 22;
    [self.view addSubview:self.arrow_prev];
    [self.arrow_prev addTarget:self action:@selector(movePageWithArrow:) forControlEvents:UIControlEventTouchDown];
    
    self.arrow_next = [[UIButton alloc] initWithFrame:CGRectMake(left_side, mid_point, arrow_width, arrow_width)];
    [self.arrow_next setBackgroundImage:[UIImage imageNamed:@"arrows-01.png"] forState:UIControlStateNormal];
    self.arrow_next.alpha = .2;
    self.arrow_next.tag = 33;
    [self.view addSubview:self.arrow_next];
    [self.arrow_next addTarget:self action:@selector(movePageWithArrow:) forControlEvents:UIControlEventTouchDown];
    
    //adds the initial page view controller
    [self addChildViewController:self.pageController];
    [self.view insertSubview:[self.pageController view] belowSubview:self.mainMenu];
    [self.pageController didMoveToParentViewController:self];
    [self changePage: (int)self.mainPageNumber];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    for (UIGestureRecognizer* g in self.pageController.gestureRecognizers){
        g.delegate = (id) self; // give me a chance to veto navigation
    }
    
    
    self.comicPages = [[NSMutableArray alloc] init];
    for(int count =0; count<=self.totalPages; count++){
        [self.comicPages addObject:[NSString stringWithFormat:@"%@%i%@", @"page_", count,@"-thumb.jpg"]];
    }
    
    
//    NSLog(@"%f %f", self.mainMenu.frame.origin.x, self.mainMenu.frame.origin.y);
    
    //initialize the audio session
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
    
    //[self performSelector:@selector(showPageNavigation) withObject:nil afterDelay:1];
}

-(void) checkForSoundAndPlay{
    
    //NSLog(@"---%@",[self.pages_data objectForKey:[NSString stringWithFormat:@"%@%i", @"page",self.childViewController.pageNumber]]);
    //NSLog(@"%i",self.childViewController.pageNumber);
    
    if([self.pages_data objectForKey:[NSString stringWithFormat:@"%@%i", @"page",self.childViewController.pageNumber]]){
        self.sound_data_object = [self.pages_data objectForKey:[NSString stringWithFormat:@"%@%i", @"page",self.childViewController.pageNumber]];
    
    self.soundFileURL = [[NSBundle mainBundle] URLForResource:[self.sound_data_object objectForKey:@"soundfile"] withExtension:[self.sound_data_object objectForKey:@"audiotype"]];
                
        if(self.soundFileURL!=nil){
            self.soundPlayer = [[SuperSoundPlayer alloc] initWithContentsOfURL:self.soundFileURL forView:self.childViewController.view withDataObject: self.sound_data_object error:nil];
        }
        else{
            [self.soundPlayer stop];
            [self.soundPlayer stopSoundPlayer];
            self.soundPlayer = nil;
        }
        
        self.sound_data_object = nil;
    }
}

-(void) movePageWithArrow: (UIButton*) sender{
    
    long int goingToPage = 0;
    
    if(sender.tag == 22){
        goingToPage = self.mainPageNumber - 1;
    }
    else{
        goingToPage = self.mainPageNumber + 1;
    }
    
    if(goingToPage < 0){
        goingToPage = self.totalPages;
    }
    
    if(goingToPage > self.totalPages){
        goingToPage = 0;
    }
    
    sender = nil;
    [self changePage: (int) goingToPage];
    
}

-(void) changePage: (int) toSelected{

    Boolean forward = YES;
    
    NSLog(@"%ld %d", (long)self.mainPageNumber, toSelected);

    if(self.mainPageNumber > toSelected){
        forward = NO;
    }
    
    NSLog(@"%i",forward);

    self.mainPageNumber = (NSUInteger) toSelected;

    @autoreleasepool {
        self.pageController.dataSource = self;
        [[self.pageController view] setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
        self.viewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:toSelected]];
        
        if(forward){
            [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        else{
            [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
        
    }
    
    
    [self.soundPlayer stopSoundPlayer];
    self.soundPlayer = nil;
    [self checkForSoundAndPlay];
    
    [(PageNavViewController*) self.pageNavigation animatePageNavViewOutOfFrame];
    
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    @autoreleasepool {
        
    self.mainPageNumber = [(BookPageViewController *)viewController pageNumber];
    
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

    
    if (self.mainPageNumber == self.totalPages) {
        self.mainPageNumber = 0;
        return [self viewControllerAtIndex:self.mainPageNumber];
    }
    
    self.mainPageNumber++;
    
    return [self viewControllerAtIndex:self.mainPageNumber];
        
    }
    
}


- (BookPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    //@autoreleasepool {
        self.childViewController = nil;
        self.childViewController = [[BookPageViewController alloc] init];
        self.childViewController.pageNumber = (int)index;
        self.childViewController.delegate = self;
    
        float width = [[UIScreen mainScreen] bounds].size.width;
        float height = [[UIScreen mainScreen] bounds].size.height;
    
        float scale = height / 768;
        float new_width = self.childViewController.view.bounds.size.width * scale;
        float new_x = ((width-new_width)/2) * -1;

    
        self.childViewController.view.bounds = CGRectMake(new_x, 0, self.childViewController.view.frame.size.width, self.childViewController.view.frame.size.height);

    //}
    
    return self.childViewController;
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
    
    NSLog(@"%i", [(PageNavViewController*) self.pageNavigation backedUpVar]);

    
    @autoreleasepool {
        
    if(!self.pageNavigationLoaded){
        self.pageNavigation = [[PageNavViewController alloc] initWithNibName:@"PageNavViewController" bundle:nil usingPages:self.comicPages];
        [self addChildViewController:self.pageNavigation];
        [self.view addSubview:self.pageNavigation.view];
        self.pageNavigationLoaded = YES;
        
    }
        
        
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
    NSLog(@"gestureRecognizerShouldBegin");
    CGPoint loc = [gestureRecognizer locationInView:self.view];
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    } else {
        
        NSLog(@"%f",loc.x);
        if(loc.x<75 || loc.x> [UIScreen mainScreen].bounds.size.width - 75){
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
