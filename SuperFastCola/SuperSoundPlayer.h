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

@property (nonatomic) NSArray* mouthCues;
@property (nonatomic) NSInteger defaultMouthTag;
@property (nonatomic) NSMutableArray* mouthTags;

@property (nonatomic) NSMutableArray* mouthsToAnimate;
@property (nonatomic) NSMutableArray* mouthsAnimated;

@property (nonatomic) UIView* holderView;

@property (nonatomic) NSNumberFormatter* formatter;
@property (nonatomic) NSNumber* now;
@property (nonatomic) float currentMillisecond;
@property (nonatomic) NSDictionary* animationData;

@property (nonatomic) BOOL mouths;


//- (id)initWithContentsOfURL:(NSURL *)url forView:(UIView*) holder andAnimateLabels:(NSString*)labels withTimeCues:(NSString*)cues error:(NSError **)outError;

- (id)initWithContentsOfURL:(NSURL *)url forView:(UIView*) holder withDataObject:(NSDictionary*)jsonData error:(NSError **)outError;
-(void) primeAudioPlayer;
-(void) stopSoundPlayer;

@end
