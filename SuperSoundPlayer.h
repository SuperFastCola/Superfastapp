//
//  SuperSoundPlayer.h
//  SuperFastCola
//
//  Created by Anthony Baker on 12/30/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface SuperSoundPlayer : AVAudioPlayer <AVAudioPlayerDelegate>

@property (nonatomic, retain) AVAudioPlayer* soundPlayer;

-(void) primeAudioPlayer;
-(void) stopSoundPlayer;

@end
