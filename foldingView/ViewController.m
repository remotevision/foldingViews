//
//  ViewController.m
//  foldingView
//
//  Created by Ryan Kelly on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>    

const float degrees = 55.0f;

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
    
    //[self animate];
}

// fold view
-(void)foldView {
    
    // rotate right-to-left
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = 1.0 / -700;
    CATransform3D rotateRightToLeft = CATransform3DRotate(perspective, degrees * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    
    // rotate left-to-right
    CATransform3D rotateLeftToRight = CATransform3DRotate(perspective, -degrees * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    
    CABasicAnimation *shadowAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [shadowAnim setDuration:2];
    [shadowAnim setAutoreverses:YES];
    [shadowAnim setRepeatCount:INFINITY];
    [shadowAnim setFromValue:[NSNumber numberWithDouble:0]];
    
    // cycle through subviews
    for (UIView *view in [self.view subviews]) {
        //NSLog(@"view : %@", [view debugDescription]);
        
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        CALayer *layer = view.layer;
        layer.shouldRasterize = YES;
        layer.masksToBounds = YES;
        
        
        // shadow
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = layer.bounds;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor clearColor].CGColor,
                           (id)[UIColor blackColor].CGColor,
                           nil];
        [layer addSublayer:gradient];
        gradient.opacity = 0;
        shadowAnim.toValue = [NSNumber numberWithDouble:0.3];
        
        // rotate
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
        if (view.tag %2) {
            rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(layer.transform, rotateRightToLeft)];
            [gradient setStartPoint:CGPointMake(0.0, 0.5)];
            [gradient setEndPoint:CGPointMake(1.0, 0.5)];
        } else {
            rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(layer.transform, rotateLeftToRight)];
            [gradient setStartPoint:CGPointMake(1.0, 0.5)];
            [gradient setEndPoint:CGPointMake(0.0, 0.5)];
        }
        [array addObject:rotate];
        
        // move
        if (view.tag !=0) {
            CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.x"];
            move.fromValue = [NSValue valueWithCGPoint:layer.position];
            //move.byValue = [NSValue valueWithCGPoint:CGPointMake(view.center.x-16, view.center.y)];
            //move.byValue = [NSValue valueWithCGPoint:CGPointMake(view.center.x-((degrees/2)*view.tag), view.center.y)];
            move.toValue = [NSValue valueWithCGPoint:CGPointMake(view.center.x-((degrees/2)*view.tag), view.center.y)];
            
            
            [array addObject:move];
        } else {
            //layer.anchorPoint = CGPointMake(0, .5); //layer.position;
        }
        
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = [NSArray arrayWithArray:array];
        group.duration = 2.;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        group.autoreverses = YES;
        group.repeatCount = INFINITY;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:2.];
            [layer addAnimation:group forKey:nil];
            [gradient addAnimation:shadowAnim forKey:nil];
        [CATransaction commit];
        
        group =nil;
        array =nil;
    }
}

- (void)animate
{
    CATransform3D transform = CATransform3DIdentity;
    CALayer *topSleeve;
    CALayer *middleSleeve;
    CALayer *bottomSleeve;
    CALayer *topShadow;
    CALayer *middleShadow;
    UIView *mainView;
    CGFloat width = 300;
    CGFloat height = 150;
    CALayer *firstJointLayer;
    CALayer *secondJointLayer;
    CALayer *perspectiveLayer;
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, width, height*3)];
    //mainView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:mainView];
    
    perspectiveLayer = [CALayer layer];
    perspectiveLayer.frame = CGRectMake(0, 0, width, height*2);
    [mainView.layer addSublayer:perspectiveLayer];
    
    firstJointLayer = [CATransformLayer layer];
    firstJointLayer.frame = mainView.bounds;
    firstJointLayer.backgroundColor = [UIColor cyanColor].CGColor;
    [perspectiveLayer addSublayer:firstJointLayer];
    
    topSleeve = [CALayer layer];
    topSleeve.frame = CGRectMake(0, 0, width, height);
    topSleeve.anchorPoint = CGPointMake(0.5, 0);
    topSleeve.backgroundColor = [UIColor redColor].CGColor;
    topSleeve.position = CGPointMake(width/2, 0);
    [firstJointLayer addSublayer:topSleeve];
    topSleeve.masksToBounds = YES;
    
    secondJointLayer = [CATransformLayer layer];
    secondJointLayer.frame = mainView.bounds;
    secondJointLayer.frame = CGRectMake(0, 0, width, height*2);
    secondJointLayer.anchorPoint = CGPointMake(0.5, 0);
    secondJointLayer.position = CGPointMake(width/2, height);
    [firstJointLayer addSublayer:secondJointLayer];
    
    middleSleeve = [CALayer layer];
    middleSleeve.frame = CGRectMake(0, 0, width, height);
    middleSleeve.anchorPoint = CGPointMake(0.5, 0);
    middleSleeve.backgroundColor = [UIColor blueColor].CGColor;
    middleSleeve.position = CGPointMake(width/2, 0);
    [secondJointLayer addSublayer:middleSleeve];
    middleSleeve.masksToBounds = YES;
    
    bottomSleeve = [CALayer layer];
    bottomSleeve.frame = CGRectMake(0, height, width, height);
    bottomSleeve.anchorPoint = CGPointMake(0.5, 0);
    bottomSleeve.backgroundColor = [UIColor grayColor].CGColor;
    bottomSleeve.position = CGPointMake(width/2, height);
    [secondJointLayer addSublayer:bottomSleeve];
    
    firstJointLayer.anchorPoint = CGPointMake(0.5, 0);
    firstJointLayer.position = CGPointMake(width/2, 0);
    
    topShadow = [CALayer layer];
    [topSleeve addSublayer:topShadow];
    topShadow.frame = topSleeve.bounds;
    topShadow.backgroundColor = [UIColor blackColor].CGColor;
    topShadow.opacity = 0;
    
    middleShadow = [CALayer layer];
    [middleSleeve addSublayer:middleShadow];
    middleShadow.frame = middleSleeve.bounds;
    middleShadow.backgroundColor = [UIColor blackColor].CGColor;
    middleShadow.opacity = 0;
    
    transform.m34 = -1.0/700.0;
    perspectiveLayer.sublayerTransform = transform;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:0]];
    [animation setToValue:[NSNumber numberWithDouble:-90*M_PI/180]];
    [firstJointLayer addAnimation:animation forKey:nil];
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:0]];
    [animation setToValue:[NSNumber numberWithDouble:180*M_PI/180]];
    [secondJointLayer addAnimation:animation forKey:nil];
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:0]];
    [animation setToValue:[NSNumber numberWithDouble:-90*M_PI/180]];
    [bottomSleeve addAnimation:animation forKey:nil];
    
    animation = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:perspectiveLayer.bounds.size.height]];
    [animation setToValue:[NSNumber numberWithDouble:0]];
    [perspectiveLayer addAnimation:animation forKey:nil];
    
    animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:perspectiveLayer.position.y]];
    [animation setToValue:[NSNumber numberWithDouble:0]];
    [perspectiveLayer addAnimation:animation forKey:nil];
    
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:0]];
    [animation setToValue:[NSNumber numberWithDouble:0.5]];
    [topShadow addAnimation:animation forKey:nil];
    
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:0]];
    [animation setToValue:[NSNumber numberWithDouble:0.5]];
    [middleShadow addAnimation:animation forKey:nil];
}


@end
