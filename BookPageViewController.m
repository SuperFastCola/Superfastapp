//
//  BookPageViewController.m
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "BookPageViewController.h"

@interface BookPageViewController ()

@end

@implementation BookPageViewController

@synthesize pageNumber;
@synthesize leftPageNumber;
@synthesize rightPageNumber;
//@synthesize pageLabel;
@synthesize page;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        if(!self.pageNumber){
            self.pageNumber = 0;
        }
        
    }
    return self;
}

-(void) loadSelectedPage: (int)withNumber : (BOOL) onRightSide {
    //self.pageLabel.text =  [NSString stringWithFormat:@"%@ %i", @"Page Number", pageNumber];
    
    @autoreleasepool {

    //generate dynamic nib name for loading
    NSString* myNibName = [NSString stringWithFormat:@"%@%i", @"Page", withNumber];
    
    //use dynamic nibname for class name
    Class dynamicPageClass = NSClassFromString(myNibName);
    
    //laod nib for class
    self.page = [[dynamicPageClass alloc] initWithNibName:myNibName bundle:nil];
    
    //add view controller to self
    
    if(onRightSide) {
        //sets initial left point a zero
        CGFloat left = 0.0;
        
        //copies view frame to CG Rect - Not allowed to manipulate frame directly
        CGRect frame = page.view.frame;
        
        //since this is landscape format we will divide the height in half
        left = [UIScreen mainScreen].bounds.size.height/2;
        frame.origin.x =  left;
        page.view.frame = frame;
    
    }
//    This code was used when I thought there was a memeory leak in having full screen UIImageView
//    NSString *fullpath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%i", @"Page", withNumber] ofType:@"jpg"];
////    CGImageRef myimage =  [[[UIImage alloc]initWithContentsOfFile:fullpath]CGImage];
//    UIImage *loadImage = [UIImage imageWithContentsOfFile:fullpath];
//    UIImageView* pageImage = (UIImageView*) [self.page.view viewWithTag:200];
//  //  pageImage.image = [UIImage imageWithCGImage:loadImage];
//    pageImage.image = loadImage;
    
        [self addChildViewController:self.page];
        [self.view addSubview:self.page.view];
        [self.page didMoveToParentViewController:self];
        myNibName = nil;
    }

    //[self.page.view removeFromSuperview];
    
    //[self.page removeFromParentViewController];
    //self.page = nil;
    
//    if(![[soundFiles objectAtIndex:pageNumber] isEqual:[NSNull null]]){
//        [self performSelector:@selector(primeAudioPlayer) withObject:nil afterDelay:1];
//    }
}

//-(void) primeAudioPlayer{
//   [self.delegate playSound:[soundFiles objectAtIndex:pageNumber]];
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSelectedPage:pageNumber:NO];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.page willMoveToParentViewController:nil];
    [self.page.view removeFromSuperview];
    [self.page removeFromParentViewController];
    
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


@end
