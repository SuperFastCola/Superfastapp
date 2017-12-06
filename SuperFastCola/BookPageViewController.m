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
@synthesize sound_data_object;

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

-(void) loadSelectedPage: (int)withNumber {
    //self.pageLabel.text =  [NSString stringWithFormat:@"%@ %i", @"Page Number", pageNumber];
    
    @autoreleasepool {

    //generate dynamic nib name for loading
    NSString* myNibName = [NSString stringWithFormat:@"%@%i", @"Page", withNumber];
    
    //use dynamic nibname for class name
    Class dynamicPageClass = NSClassFromString(myNibName);
    
    //laod nib for class
    self.page = [[dynamicPageClass alloc] initWithNibName:myNibName bundle:nil];
        
    dynamicPageClass = nil;
    
    //add view controller to self
        
        float width = [[UIScreen mainScreen] bounds].size.width;
        float height = [[UIScreen mainScreen] bounds].size.height;
        self.view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,height)];
        [self.view setUserInteractionEnabled:YES];
        
        float scale = height / 768;
        self.view.transform = CGAffineTransformMakeScale(scale, scale);
        [self addChildViewController:self.page];
        [self.view addSubview:self.page.view];
        [self.page didMoveToParentViewController:self];
        
        
        myNibName = nil;
    }

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSelectedPage:pageNumber];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnLoad{
    self.sound_data_object = nil;
    
    //@property (nonatomic, retain) IBOutlet UILabel* pageLabel;
    self.page = nil;
    self.delegate = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.page willMoveToParentViewController:nil];
    //[self.page.view removeFromSuperview];
    //[self.page removeFromParentViewController];
    
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


@end
