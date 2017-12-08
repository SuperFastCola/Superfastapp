//
//  SuperSoundPlayer.m
//  SuperFastCola
//
//  Created by Anthony Baker on 12/30/13.
//  Copyright (c) 2013 com.anthony.baker. All rights reserved.
//

#import "SuperSoundPlayer.h"

@implementation SuperSoundPlayer

@synthesize audioTime;
@synthesize labelsToAnimate;
@synthesize labelsAnimated;
@synthesize holderView;
@synthesize labelsStringSplit;
@synthesize timeCues;
@synthesize mouthCues;
@synthesize mouthTags;
@synthesize mouthsToAnimate;
@synthesize mouthsAnimated;
@synthesize formatter;
@synthesize now;
@synthesize currentMillisecond;
@synthesize animationData;
@synthesize mouths;
@synthesize defaultMouthTag;


//- (id)initWithContentsOfURL:(NSURL *)url forView:(UIView*) holder andAnimateLabels:(NSString*)labels withTimeCues:(NSString*)cues error:(NSError **)outError{
    
- (id)initWithContentsOfURL:(NSURL *)url forView:(UIView*) holder withDataObject:(NSDictionary*)jsonData error:(NSError **)outError{
    
    self = [super initWithContentsOfURL:url error:outError];
    
    if(self){
        
        @autoreleasepool {
            
            //[self performSelector:@selector(primeAudioPlayer) withObject:nil afterDelay:2];

            //if(holder != nil && labels != nil && cues != nil){
            if(holder != nil && jsonData != nil){
                
                self.holderView = holder;
                self.animationData = jsonData;
                
                self.labelsStringSplit = [[NSMutableArray alloc] initWithArray:[[self.animationData objectForKey:@"tags"] componentsSeparatedByString:@","]];
                self.timeCues = [[self.animationData objectForKey:@"cues"] componentsSeparatedByString:@","];
                
                self.mouthCues = [[self.animationData objectForKey:@"mouthcues"] componentsSeparatedByString:@","];
                self.mouthTags = [[NSMutableArray alloc] initWithArray:[[self.animationData objectForKey:@"mouthparts"] componentsSeparatedByString:@","]];
                
                self.defaultMouthTag = (NSInteger) [[self.animationData objectForKey:@"defaultmouth"] integerValue];
                
                //[self performSelector:@selector(createLabels) withObject:nil afterDelay:.5];
                [self createLabels];

                jsonData = nil;
            }
            
            [self primeAudioPlayer];

            
        }
    }
    return self;
}

-(void) createLabels{
    
        @autoreleasepool {
        //have allocate mutable array to be able to use it.
        self.labelsAnimated = [[NSMutableArray alloc] init];
        self.labelsToAnimate = [[NSMutableArray alloc] init];
            
        self.mouths = NO;
            
        if(self.mouthCues!=nil){
            self.mouths = YES;
        }
            
        for(int i=0;i<[self.labelsStringSplit count];i++){
            //convert view tag to nsinteger
            NSInteger tag = [[self.labelsStringSplit objectAtIndex:(NSUInteger) i] intValue];
            
            UIView* temp = [self.holderView viewWithTag:tag];
            temp.transform = CGAffineTransformScale(temp.transform, 0.01, 0.01);
            [self.labelsToAnimate addObject:temp];
            [self.labelsAnimated addObject:[NSNumber numberWithInt:0]];
            temp= nil;
            //tag = nil;
        }
            
        if(self.mouths){
            
            self.mouthsToAnimate = [[NSMutableArray alloc] init];
            self.mouthsAnimated = [[NSMutableArray alloc] init];
            
            for(int i=0;i<[self.mouthCues count];i++){
                //convert view tag to nsinteger
                NSInteger tag = [[self.mouthTags objectAtIndex:(NSUInteger) i] intValue];
                
                UIView* temp = [self.holderView viewWithTag:tag];
                
                if(tag !=self.defaultMouthTag){
                    temp.alpha = 0;
                }
                [self.mouthsToAnimate addObject:(id)temp];
                
                [self.mouthsAnimated addObject:[NSNumber numberWithInt:0]];
                temp= nil;
                //tag = 0;
            }
            
            
        }
            
        
//        formatter = [[NSNumberFormatter alloc] init];
//        [formatter setMaximumFractionDigits:1];
            
        }
    
}

-(void) initializeTimer{
     @autoreleasepool {
        self.audioTime = [CADisplayLink displayLinkWithTarget:self  selector:@selector(checkTimeOFAudio:)];
        [self.audioTime addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
     }
}

-(void) zoomInView: (UIView*) label{
    
    void (^animView) (void) = ^{
        label.transform=CGAffineTransformScale(label.transform, 100, 100);
        label.alpha = 1.0;
    };
    
    [UIView animateWithDuration:.15
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:animView
                     completion:nil];
}

-(void) showMouthView: (UIView*) mouth{
    
    void (^animView) (void) = ^{
        mouth.alpha = 1.0;
    };
    
    [UIView animateWithDuration:.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:animView
                     completion:nil];
}

-(void) hideMouthView: (UIView*) mouth{
    
    void (^animView) (void) = ^{
        mouth.alpha = 0.0;
    };
    
    [UIView animateWithDuration:.05
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:animView
                     completion:nil];
}


- (void)checkTimeOFAudio:(CADisplayLink*)displayLink {
    
    self.currentMillisecond = (round(self.currentTime*100)) / 100.0;

    //http://stackoverflow.com/questions/497018/is-there-a-function-to-round-a-float-in-c-or-do-i-need-to-write-my-own
    self.currentMillisecond = self.currentMillisecond*10.0f;
    self.currentMillisecond = (self.currentMillisecond > (floor(self.currentMillisecond)+0.5f)) ? ceil(self.currentMillisecond) : floor(self.currentMillisecond);
    self.currentMillisecond = self.currentMillisecond/10.0f;
    
    float nowtest;
    
    for(int i=0;i<[self.timeCues count];i++){
        
        self.now = [self.timeCues objectAtIndex: (NSUInteger)i];
        
        nowtest = (round(self.now.floatValue*100)) / 100.0;
        
        int usedAlready = [[self.labelsAnimated objectAtIndex: (NSUInteger)i] intValue];
        
        //float cur = [(NSNumber*) [self.formatter stringFromNumber:[NSNumber numberWithDouble:self.currentTime]] floatValue];
        //float cur = self.currentTime;
        
        //NSLog(@"%f %f",nowtest,  self.currentMillisecond);
        
        if( self.currentMillisecond == nowtest && usedAlready==0){
            
            [self.labelsAnimated replaceObjectAtIndex:(NSUInteger)i withObject:[NSNumber numberWithInt:1]];
            [self zoomInView:[self.labelsToAnimate objectAtIndex: (NSUInteger)i]];
        }
    }
    
    if(self.mouths){
        
        for(int i=0;i<[self.mouthCues count];i++){
        
        self.now = [self.mouthCues objectAtIndex: (NSUInteger)i];
        nowtest = (round(self.now.floatValue*100)) / 100.0;
            
        int mouthUsedAlready = [[self.mouthsAnimated objectAtIndex: (NSUInteger)i] intValue];
        
            if( self.currentMillisecond == nowtest && mouthUsedAlready==0){
                
                for(id item in self.mouthsToAnimate){
                    [self hideMouthView: (UIImageView*)item];
                }
                
                [self.mouthsAnimated replaceObjectAtIndex:(NSUInteger)i withObject:[NSNumber numberWithInt:1]];
                
                //NSLog(@"%@ %i",[[self.mouthsToAnimate objectAtIndex: (NSUInteger)i] description],(NSUInteger)i);
                
                //add mouth objects to XIB
                [self showMouthView:[self.mouthsToAnimate objectAtIndex: (NSUInteger)i]];
            }
        }//end for
    }//end if self.mouths

}

-(void) playAudio{
    [self play];
    [self initializeTimer];
}

-(void) primeAudioPlayer{
    [self prepareToPlay];
    [self performSelector:@selector(playAudio) withObject:nil afterDelay:0];

}


-(void) stopSoundPlayer{
    //NSLog(@"Stopping");
    [self stop];
    [self.audioTime invalidate];
    [self clearObjects];
}

-(void) clearObjects{
    self.audioTime = nil;
    self.labelsToAnimate = nil;
    self.labelsAnimated = nil;
    
    self.audioTime = nil;
    
    for(int i=0;i<[self.labelsStringSplit count];i++){
        [self.labelsStringSplit removeObjectAtIndex:(NSUInteger) i];
        [self.labelsAnimated removeObjectAtIndex:(NSUInteger) i];
        [self.labelsToAnimate removeObjectAtIndex:(NSUInteger) i];
    }
    
    self.labelsStringSplit = nil;
    self.timeCues = nil;
    self.formatter = nil;
    self.now = nil;
 
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self clearObjects];
}

@end
