//
//  pageNavThumbnail.m
//  SuperFastCola
//
//  Created by Anthony Baker on 12/2/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "PageNavThumbnail.h"

@implementation PageNavThumbnail

@synthesize thumbNail;
@synthesize thumbImage;
@synthesize pageNumber;
@synthesize delegate;


- (id) initWithImageSource:(NSString *)imageSource AndPageNumber: (int)page PassingDelegate: (UIViewController*) theDelegate {
    if (self = [self init]) {
        // handle or store 'myParam' somewhere for use later
        [self createThumbnailwithSource:imageSource];
        
        imageSource = nil;
        
        self.pageNumber = page;
        self.userInteractionEnabled = YES;
        
        CGRect newFrame = self.frame;
        newFrame.size = CGSizeMake(150, 113);
        self.frame = newFrame;
        
        self.delegate = theDelegate;
        
        theDelegate = nil;
    }
    
    return self;
}

//
//- (id)initWithFrame:(CGRect)frame usingImageSource: (NSString*) imageSource
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self createThumbnailwithSource:imageSource];
//    }
//    return self;
//}

-(void) turnPageOnMainViewController{
    [self.delegate changePage:pageNumber];
}


-(void) createThumbnailwithSource:(NSString*)source{
   
    @autoreleasepool {
        

    self.thumbImage = [UIImage imageNamed:source];
    
   // thumbImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:source ofType:nil]];
    
    self.thumbNail = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.thumbImage.size.width, self.thumbImage.size.height)];
    [self.thumbNail setBackgroundImage:self.thumbImage forState:UIControlStateNormal];

    source = nil;

    
    self.thumbNail.userInteractionEnabled = YES;
    [self.thumbNail addTarget: self action: @selector(turnPageOnMainViewController) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview:self.thumbNail];
        
        }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
