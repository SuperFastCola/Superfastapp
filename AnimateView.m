//
//  AnimateView.m
//  SuperFastCola
//
//  Created by Anthony Baker on 1/1/14.
//  Copyright (c) 2014 com.anthony.baker. All rights reserved.
//

#import "AnimateView.h"

@implementation AnimateView

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

- (id)initWithImageView:(UIImageView*) imageView
{
    self = [super initWithFrame:imageView.frame];
    if (self) {
        // Initialization code
        self.animateThisImage = (UIView*) imageView;
        self.viewCenter = self.animateThisImage.center;
        [self floatingInSpace:self.animateThisImage];
       
        [self addTapRecognizer];
        
        self.userInteractionEnabled = true;
        self.animateThisImage.userInteractionEnabled = true;
        
        //snap animation distance
        self.snapBackAt = 60;
        self.animating = NO;
        self.dragging = NO;
        
        self.dragObject = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(panning:)];
        
        [self.animateThisImage addGestureRecognizer:self.dragObject];
        
    }
    return self;
}

-(void) addTapRecognizer{
    
    tapAction = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(jiggle:)];
    tapAction.numberOfTapsRequired = 1;
    
    [self.animateThisImage addGestureRecognizer:tapAction];
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

- (void)jiggle:(UITapGestureRecognizer *)sender{
    
    NSLog(@"Tap");
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
    
    if(self.dragging == NO){
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
        CAKeyframeAnimation* anim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        anim1.path = path;
        anim1.duration = .35;
        anim1.calculationMode = kCAAnimationPaced;
        anim1.fillMode = kCAFillModeForwards;
        anim1.removedOnCompletion = YES;
        anim1.delegate = self;
         
        [self.animateThisImage.layer addAnimation:anim1 forKey:@"position"];
    }
   
}

- (void) panning: (UIPanGestureRecognizer*) gesture {
    
    float newX = 0;
    float newY = 0;
    float disX = 0;
    float disY = 0;
    float distance = 0;
    CGPoint loc;
    
    loc = [gesture translationInView:[self.animateThisImage superview]];
    
    newX =self.viewCenter.x+loc.x;
    newY =self.viewCenter.y+loc.y;
    
    disX = self.viewCenter.x - newX;
    disY = self.viewCenter.y - newY;
    
    distance = sqrt((disX * disX) + (disY * disY));
    
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
    
    if(gesture.state == UIGestureRecognizerStateEnded){
        self->snapping=NO;
        self->dragging = NO;
        
        if(self->animating==NO){
            [self snapBackAnimation:self.outOfBoundsAt.x:self.outOfBoundsAt.y:distance];
            self.animateThisImage.center = self.viewCenter;
        }
        
        [gesture setTranslation:CGPointMake(0, 0) inView:[self.animateThisImage superview]];
    }
    
    if(gesture.state == UIGestureRecognizerStateCancelled){
        gesture.enabled = YES;
    }

}

-(void)animationDidStart:(CAAnimation *)theAnimation{
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    NSLog(@"Ani finished");
    self.animateThisImage.center = self.viewCenter;
    [self floatingInSpace:self.animateThisImage];
    self->animating = NO;
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
