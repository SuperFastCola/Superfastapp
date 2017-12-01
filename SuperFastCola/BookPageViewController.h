//
//  BookPageViewController.h
//  SuperFastCola
//
//  Created by Anthony Baker on 11/28/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pagePass <NSObject>
-(void) displayPage: (UIViewController*) fromController;
@end


@interface BookPageViewController : UIViewController

@property (nonatomic) int pageNumber;
@property (nonatomic) int leftPageNumber;
@property (nonatomic) int rightPageNumber;
@property (nonatomic) NSDictionary* sound_data_object;

//@property (nonatomic, retain) IBOutlet UILabel* pageLabel;
@property (nonatomic, retain) UIViewController* page;
@property (nonatomic, weak) id delegate;


@end
