//
//  pageNavThumbnail.h
//  SuperFastCola
//
//  Created by Anthony Baker on 12/2/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pageTurner <NSObject>
-(void) changePage: (int) toSelected;
@end

@interface PageNavThumbnail : UIView

@property (nonatomic, retain) UIButton* thumbNail;
@property (nonatomic, weak) UIImage* thumbImage;
@property (nonatomic, weak) id delegate;
@property (nonatomic) int pageNumber;

- (id) initWithImageSource:(NSString *)imageSource AndPageNumber: (int)page PassingDelegate: (UIViewController*) theDelegate;
-(void) createThumbnailwithSource:(NSString*)source;

@end
