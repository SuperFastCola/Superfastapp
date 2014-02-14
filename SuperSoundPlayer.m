//
//  SuperSoundPlayer.m
//  SuperFastCola
//
//  Created by Anthony Baker on 12/30/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "SuperSoundPlayer.h"

@implementation SuperSoundPlayer

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError{
    
    self = [super initWithContentsOfURL:url error:outError];
    
    if(self){
        @autoreleasepool {
        
            [self performSelector:@selector(primeAudioPlayer) withObject:nil afterDelay:1];
        }
    }
    
    return self;
}

-(void) primeAudioPlayer{
    [self prepareToPlay];
    [self play];
}


-(void) stopSoundPlayer{ 
    [self stop];
    
}

@end
