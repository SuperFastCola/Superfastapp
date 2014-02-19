//
//  SuperSoundPlayer.h
//  SuperFastCola
//
//  Created by Anthony Baker on 12/30/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface SuperSoundPlayer : AVAudioPlayer <AVAudioPlayerDelegate>

@property (nonatomic) AVAudioPlayer* soundPlayer;
@property (nonatomic) CADisplayLink* audioTime;
@property (nonatomic) NSMutableArray* labelsToAnimate;
@property (nonatomic) NSMutableArray* labelsAnimated;

@property (nonatomic) NSArray* timeCues;
@property (nonatomic) NSMutableArray* labelsStringSplit;

@property (nonatomic) UIView* holderView;

@property (nonatomic) NSNumberFormatter* formatter;
@property (nonatomic) NSNumber* now;

- (id)initWithContentsOfURL:(NSURL *)url forView:(UIView*) holder andAnimateLabels:(NSString*)labels withTimeCues:(NSString*)cues error:(NSError **)outError;


-(void) primeAudioPlayer;
-(void) stopSoundPlayer;

@end
