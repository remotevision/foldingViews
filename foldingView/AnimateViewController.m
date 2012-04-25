//
//  AnimateViewController.m
//  foldingView
//
//  Created by Ryan Kelly on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimateViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimateViewController ()

@end

@implementation AnimateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
