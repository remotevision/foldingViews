//
//  ViewController.m
//  foldingView
//
//  Created by Ryan Kelly on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>    

@interface ViewController ()

@end

@implementation ViewController
@synthesize viewToFold;
@synthesize blueView;
@synthesize greenView;
@synthesize tealView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidUnload
{
    [self setViewToFold:nil];
    [self setBlueView:nil];
    [self setGreenView:nil];
    [self setTealView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self foldView];
}

// fold view
-(void)foldView {
    
    // rotate right-to-left
    CATransform3D rotateRightToLeft = CATransform3DIdentity;
    rotateRightToLeft.m34 = 1.0 / -2000;
    rotateRightToLeft = CATransform3DRotate(rotateRightToLeft, 55.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    
    // rotate left-to-right
    CATransform3D rotateLeftToRight = CATransform3DIdentity;
    rotateLeftToRight.m34 = 1.0 / -2000;
    rotateLeftToRight = CATransform3DRotate(rotateLeftToRight, -45.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    
    
    // cycle through sublayers
    for (UIView *view in [self.view subviews]) {
        //NSLog(@"view : %@", [view debugDescription]);
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        CALayer *layer = view.layer;
        layer.shouldRasterize = YES;
        layer.masksToBounds = NO;
        
        // rotate
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
        if (view.tag %2) {
            rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(layer.transform, rotateRightToLeft)];
        } else {
            rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(layer.transform, rotateLeftToRight)];
        }
        [array addObject:rotate];
        
        // move
        if (view.tag !=0) {
            CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
            move.beginTime = 0.07f;
            move.toValue = [NSValue valueWithCGPoint:CGPointMake(view.center.x-(21.1*view.tag), view.center.y)];
            [array addObject:move];
        } else {
            //layer.anchorPoint = CGPointMake(0, .5);; //layer.position;
        }
        
        // shadow
        CABasicAnimation *shadowGrow = [CABasicAnimation animationWithKeyPath:@"shadowRadius" ];
        [shadowGrow setFromValue:[NSNumber numberWithFloat:3.0]];
        [shadowGrow setToValue:[NSNumber numberWithFloat:20.0]];
        shadowGrow.autoreverses = YES;
        [array addObject:shadowGrow];
        
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = [NSArray arrayWithArray:array];
        group.duration = 2.;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        group.autoreverses = YES;
        group.repeatCount = 100;
        
        [layer addAnimation:group forKey:nil];
        
        group =nil;
        array =nil;

        
    }
    


    
    
    /*[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    
    // red view
    
    
    layer.transform = rotationAndPerspectiveTransform;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [layer valueForKey:@"position"];
    
    
    // iOS
    animation.toValue = [NSValue valueWithCGPoint:point];
    animation.duration = duration;
    
    // Update the layer's position so that the layer doesn't snap back when the animation completes.
    layer.position = point;

    
    // Add the animation, overriding the implicit animation.
    [view.layer addAnimation:animation forKey:@"position"];
    
    // blue view
    CALayer *layer_blue = self.blueView.layer;
    CATransform3D rotationAndPerspectiveTransform_blue = CATransform3DIdentity;
    rotationAndPerspectiveTransform_blue.m34 = 1.0 / -500;
    rotationAndPerspectiveTransform_blue = CATransform3DRotate(rotationAndPerspectiveTransform_blue, -45.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    layer_blue.transform = rotationAndPerspectiveTransform_blue;
    
    
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
     */
}


@end
