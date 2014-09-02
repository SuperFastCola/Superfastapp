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
@synthesize formatter;
@synthesize now;
@synthesize currentMillisecond;
@synthesize animationData;


//- (id)initWithContentsOfURL:(NSURL *)url forView:(UIView*) holder andAnimateLabels:(NSString*)labels withTimeCues:(NSString*)cues error:(NSError **)outError{
    
- (id)initWithContentsOfURL:(NSURL *)url forView:(UIView*) holder withDataObject:(NSDictionary*)jsonData error:(NSError **)outError{
    
    self = [super initWithContentsOfURL:url error:outError];
    
    if(self){
        
        //[self stopSoundPlayer];
        @autoreleasepool {
            
            //[self performSelector:@selector(primeAudioPlayer) withObject:nil afterDelay:2];

            //if(holder != nil && labels != nil && cues != nil){
            if(holder != nil && jsonData != nil){
                
                self.holderView = holder;
                self.animationData = jsonData;
                
                self.labelsStringSplit = [[NSMutableArray alloc] initWithArray:[[self.animationData objectForKey:@"tags"] componentsSeparatedByString:@","]];
                self.timeCues = [[self.animationData objectForKey:@"cues"] componentsSeparatedByString:@","];
                
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

    
        for(int i=0;i<[self.labelsStringSplit count];i++){
            
            //convert view tag to nsinteger
            NSInteger tag = [[self.labelsStringSplit objectAtIndex:(NSUInteger) i] intValue];
            
            UIView* temp = [self.holderView viewWithTag:tag];
            temp.transform = CGAffineTransformScale(temp.transform, 0.01, 0.01);
            
            [self.labelsToAnimate addObject:temp];
            [self.labelsAnimated addObject:[NSNumber numberWithInt:0]];
            
            temp= nil;
        }
        
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:1];
            
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


- (void)checkTimeOFAudio:(CADisplayLink*)displayLink {
    
    self.currentMillisecond = (round(self.currentTime*100)) / 100.0;

    //http://stackoverflow.com/questions/497018/is-there-a-function-to-round-a-float-in-c-or-do-i-need-to-write-my-own
    self.currentMillisecond = self.currentMillisecond*10.0f;
    self.currentMillisecond = (self.currentMillisecond > (floor(self.currentMillisecond)+0.5f)) ? ceil(self.currentMillisecond) : floor(self.currentMillisecond);
    self.currentMillisecond = self.currentMillisecond/10.0f;
            
    for(int i=0;i<[self.timeCues count];i++){
        
        self.now = [self.timeCues objectAtIndex: (NSUInteger)i];
        
        int usedAlready = [[self.labelsAnimated objectAtIndex: (NSUInteger)i] intValue];
        
        //float cur = [(NSNumber*) [self.formatter stringFromNumber:[NSNumber numberWithDouble:self.currentTime]] floatValue];
        //float cur = self.currentTime;
        
        float nowtest = (round(self.now.floatValue*100)) / 100.0;

        
        //NSLog(@"%f %f",nowtest,  self.currentMillisecond);

        
        if( self.currentMillisecond == nowtest && usedAlready==0){
            
            [self.labelsAnimated replaceObjectAtIndex:(NSUInteger)i withObject:[NSNumber numberWithInt:1]];
            [self zoomInView:[self.labelsToAnimate objectAtIndex: (NSUInteger)i]];
        }
    }
}

-(void) playAudio{
    [self play];
    [self initializeTimer];
}

-(void) primeAudioPlayer{
    [self prepareToPlay];
    [self performSelector:@selector(playAudio) withObject:nil afterDelay:1];

}


-(void) stopSoundPlayer{
    NSLog(@"Stopping");
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
