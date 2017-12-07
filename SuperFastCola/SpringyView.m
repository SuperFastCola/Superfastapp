//
//  AnimateView.m
//  SuperFastCola
//
//  Created by Anthony Baker on 1/1/14.
//  Copyright (c) 2014 com.anthony.baker. All rights reserved.
//

#import "SpringyView.h"
#import "BookPageViewController.h"

@implementation SpringyView

@synthesize animateThisImage;
@synthesize tapAction;
@synthesize viewCenter;
@synthesize dragObject;
@synthesize snapping;
@synthesize dragging;
@synthesize animating;
@synthesize inBounds;
@synthesize outOfBoundsAt;
@synthesize snapBackAt;
@synthesize anim1;
@synthesize detectionPath;
@synthesize useDetectionPath;
@synthesize soundPlayer;
@synthesize soundFileUrl;
//@synthesize animateTagsOnTouch;
//@synthesize animateTagsWithCues;
@synthesize pageNumber;
@synthesize delegate;

- (id)initWithImageView:(UIImageView*) imageView andPlaySound: (NSString*) soundfile
{
    self = [super initWithFrame:imageView.frame];
    
    if (self && self != nil) {
        
        if(soundfile != NULL){
            self.soundFileUrl = [[NSBundle mainBundle] URLForResource:soundfile withExtension:@"mp3"];
            self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundFileUrl error:nil];
            [self.soundPlayer prepareToPlay];
        }
        
        // Initialization code
        self.animateThisImage = (UIView*) imageView;
        self.viewCenter = self.animateThisImage.center;
        [self floatingInSpace:self.animateThisImage];

       
        [self addTapRecognizer];
        
        self.userInteractionEnabled = YES;
        self.animateThisImage.userInteractionEnabled = YES;
        [self setUserInteractionEnabled:YES];
        [self.animateThisImage setUserInteractionEnabled:YES];
        
        //snap animation distance
        self.snapBackAt = 60;
        self.animating = NO;
        self.useDetectionPath = NO;
        self.dragging = NO;
        
        self.dragObject = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(panning:)];
        
        [self.animateThisImage addGestureRecognizer:self.dragObject];
        
    }
    return self;
}

-(void)animateMouthOnTouch{

    NSURL* jsonFile = [[NSBundle mainBundle] URLForResource:@"sounds_files" withExtension:@"json"];
    NSData* data = [NSData dataWithContentsOfURL:jsonFile];
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data //1
                          options:kNilOptions
                          error:nil];
        
    json = [json objectForKey:@"pages"]; //2
    json = [json objectForKey:[NSString stringWithFormat:@"%@%i", @"page",self.pageNumber ]]; //2
    
    self.animateTagsOnTouch = [[json objectForKey:@"mouthparts"] componentsSeparatedByString:@","];
    self.animateTagsWithCues = [[json objectForKey:@"mouthcues"] componentsSeparatedByString:@","];

    jsonFile = nil;
    data = nil;
    json = nil;
    
}

-(void) animateViews{
    for (int i=0; i<[self.animateTagsOnTouch count];i++){
        long tag = [[self.animateTagsOnTouch objectAtIndex:i] integerValue];
        float delay = [[self.animateTagsWithCues objectAtIndex:i] integerValue];
        
        [self showAndHide:[self.animateThisImage viewWithTag:tag] withDelay:delay];
    }
}

-(void) showAndHide: (UIView*) part withDelay:(float) delayAmount{
    
    void (^animView) (void) = ^{
        part.alpha =1;
    };
    
    void (^completeView) (BOOL) = ^(BOOL success){
        //part.alpha = 0;
        NSLog(@"------%@ %f", [part description], delayAmount);
    };
    
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:animView
                     completion:completeView];
}

-(void) addDetectionPath: (CGRect) path{
    self.detectionPath = path;
    self.useDetectionPath = YES;
}

-(void) addTapRecognizer{
    
    self.tapAction = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(jiggle:)];
    
    self.tapAction.numberOfTapsRequired = 1;
    
    [self.animateThisImage addGestureRecognizer:self.tapAction];
}

-(void) floatingInSpace: (UIView*) floater{
    
    CGPoint v = floater.center;
    
    void (^animView) (void) = ^{
        CGPoint n2 = CGPointMake(v.x, v.y-5);
        floater.center = n2;
    };

    [UIView animateWithDuration:.5
                    delay:.25
                    options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction
                    animations:animView
                    completion:nil];
    
}

- (void)playSound{
    [self.soundPlayer stop];
    [self.soundPlayer play];
}

- (void)jiggle:(UITapGestureRecognizer *)sender{
    
    bool move = true;
    
    CGPoint loc  = [sender locationInView:[self.animateThisImage superview]];
    
    NSLog(@"%f", loc.x);
    
    if(!CGRectContainsPoint(self.detectionPath, loc) && self.useDetectionPath)
    {
        move = false;
    }
    
//    if(self.animateTagsOnTouch != nil){
//        [self animateViews];
//    }
    
    if(move){
        if([self.delegate respondsToSelector:@selector(playDialog)]){
            [self.delegate playDialog];
        }

        float disX = 0;
        float disY = 0;
        
        if((rand()% 2)==1){
            disX = self.viewCenter.x + (rand() % 50);
        }
        else{
            disX = self.viewCenter.x - (rand() % 50);
        }
        
        if((rand()% 2)==1){
            disY = self.viewCenter.y + (rand() % 50);
        }
        else{
            disX = self.viewCenter.x - (rand() % 50);
            disY = self.viewCenter.y - (rand() % 50);
        }
        
        float distance = (rand() % 100);
        
        [self snapBackAnimation:disX:disY:distance];
    }
    


}

-(float)returnRadians:(float)usingPercentage :(float)ofRadians{
    return ofRadians + (ofRadians * usingPercentage);
}

-(CGPoint)returnPoint:(float)usingDistance :(float)withX :(float)withY :(float)andRadians{
    float xCoor = withX - (usingDistance * sinf(andRadians));
    float yCoor = withY - (usingDistance * cosf(andRadians));
    
    return CGPointMake(xCoor, yCoor);
}


-(void) snapBackAnimation:(float)currentX :(float)currentY :(float)distance{
    self->snapping = YES;
    self->animating = YES;
    [self playSound];
    
    if([self.delegate respondsToSelector:@selector(playDialog)]){

        [self.delegate playDialog];
    }
    
    [self.animateThisImage.layer removeAllAnimations];
    
    //current uiview pixel coordinates
    float cx = currentX;
    float cy = currentY;
    
    //percentages to grab for distance
    float pDist1 = .5;
    float pDist2 = .25;
    float pDist3 = .17;
    
    
    float deltaX = 0;
    float deltaY = 0;
    float deg_inverse = 0;
    CGPoint opposite;
    float rad25 = 0;
    float rad75 = 0;
    CGPoint opposite25;
    CGPoint opposite75;
    
    //create path fr animation

    CGMutablePathRef path = CGPathCreateMutable();

    
    if(self->dragging == NO){
        

        if(currentX>0 && currentY>0 && distance>0){
            
            CGPathMoveToPoint(path, NULL, cx, cy);

            for(int i = 0; i<4; i++){
                
                int alternate = i%2;
                
                if(alternate==1){
                    cx = opposite.x;
                    cy = opposite.y;
                    distance = distance/2;
                }
                else{
                    cx = currentX;
                    cy = currentY;
                    distance = distance/2;
                }
                
                //calculate angle from two points
                deltaX = (cx - self.viewCenter.x)/2;
                deltaY = (cy - self.viewCenter.y)/2;
                deg_inverse = atan2f(deltaX,deltaY);

                //get opposite coordinates for bounce back
                opposite = [self returnPoint:distance*pDist1 :self.viewCenter.x :self.viewCenter.y :deg_inverse];
                
                //calculate percentages of radians
                rad25 = [self returnRadians:.15 : deg_inverse];
                rad75 = [self returnRadians:.5 : deg_inverse];
                
                //get control points for curve
                opposite25 = [self returnPoint:distance*pDist2 :self.viewCenter.x :self.viewCenter.y :rad25];
                opposite75 = [self returnPoint:distance*pDist3 :self.viewCenter.x :self.viewCenter.y :rad75];
                
                //add a curve with two control points
                CGPathAddCurveToPoint(path, NULL, opposite25.x, opposite25.y, opposite75.x, opposite75.y, opposite.x, opposite.y);
                
    //            NSLog(@"init %f %f %f",currentX,currentY, distance);
    //            NSLog(@"p %i %f %f %f %f",i,cx,cy,distance,deg_inverse);
    //            NSLog(@"X %i %f %f %f",i,opposite25.x,opposite75.x,opposite.x);
    //            NSLog(@"Y %i %f %f %f",i,opposite25.y,opposite75.y,opposite.y);
    //            NSLog(@"--");
                
            }
        }
        else{
            CGPathMoveToPoint(path, NULL, self.viewCenter.x, self.viewCenter.y);
        }

        CGPathAddLineToPoint(path, NULL, self.viewCenter.x, self.viewCenter.y);
        
        
        //play animation
        anim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        anim1.path = path;
        anim1.duration = .35;
        anim1.calculationMode = kCAAnimationPaced;
        anim1.fillMode = kCAFillModeForwards;
        anim1.removedOnCompletion = YES;
        anim1.delegate = self;
         
        [self.animateThisImage.layer addAnimation:anim1 forKey:@"position"];
    
    }
    
    CGPathRelease(path);

}


- (void) panning: (UIPanGestureRecognizer*) gesture {
    
    float newX = 0;
    float newY = 0;
    float disX = 0;
    float disY = 0;
    float distance = 0;
    CGPoint loc;
    CGPoint touchedAt;
    
    loc = [gesture translationInView:[self.animateThisImage superview]];
    touchedAt = [gesture locationInView:[self.animateThisImage superview]];
    
    NSLog(@"%f",touchedAt.x);
    
    gesture.delaysTouchesEnded = NO;  
    
    newX =self.viewCenter.x+loc.x;
    newY =self.viewCenter.y+loc.y;
    
    disX = self.viewCenter.x - newX;
    disY = self.viewCenter.y - newY;
    
    distance = sqrt((disX * disX) + (disY * disY));
    
    Boolean canProceed = NO;
    
    if((self->useDetectionPath && CGRectContainsPoint(self.detectionPath, touchedAt)) || !self->useDetectionPath){
        canProceed = YES;
    }

    
    if(canProceed){
        
    if(self->animating==NO){
        if(gesture.state == UIGestureRecognizerStateBegan){
            self->dragging = YES;
            [self.animateThisImage.layer removeAllAnimations];
        }

        if(gesture.state == UIGestureRecognizerStateChanged && self->animating==NO){

            //if in range - set floater to touch coordinates
            if(distance<self.snapBackAt && self->animating==NO){
                self->inBounds = YES;
                self.outOfBoundsAt = CGPointMake(newX, newY);
                self.animateThisImage.center = CGPointMake(newX,newY);
            }
            else{
                //if out of range - set floater to original center
                self->inBounds = NO;
                
                if(self->animating==NO){
                    self->dragging = NO;
                    gesture.enabled = NO;
                    self.outOfBoundsAt = CGPointMake(newX, newY);
                    [self snapBackAnimation:newX:newY:distance];
                    self.animateThisImage.center = self.viewCenter;
                }
            }
        }//snapping
    }
    
    }
    
    if(gesture.state == UIGestureRecognizerStateEnded){
        
        self->snapping=NO;
        
        if(canProceed || (self->dragging && !canProceed)){
            self->dragging = NO;

            if(self->animating==NO){
                    [self snapBackAnimation:self.outOfBoundsAt.x:self.outOfBoundsAt.y:distance];
                    self.animateThisImage.center = self.viewCenter;
            }
            
            [gesture setTranslation:CGPointMake(0, 0) inView:[self.animateThisImage superview]];
        }
        
    }
        
    
    
    if(gesture.state == UIGestureRecognizerStateCancelled){
        NSLog(@"Cancelled");
        gesture.enabled = YES;
    }


}

-(void)animationDidStart:(CAAnimation *)theAnimation{
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    self.animateThisImage.center = self.viewCenter;
    [self floatingInSpace:self.animateThisImage];
    self->animating = NO;
    self.anim1 = nil;
}

-(void) viewDidUnload{
    [self.soundPlayer stop];
    NSLog(@"Stopping Sound");
    self.animateThisImage = nil;
    self.tapAction = nil;
    self.dragObject = nil;
    self.delegate = nil;
    self.anim1 = nil;
    self.soundPlayer = nil;
    self.soundFileUrl = nil;

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
