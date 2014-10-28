//
//  ViewController.m
//  TinderSwipeFeature
//
//  Created by Xida Zheng on 10/26/14.
//  Copyright (c) 2014 xidazheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIView *box;
@property (strong, nonatomic) UIImageView *picture;
@property (nonatomic,strong) UILabel *like;
@property (nonatomic,strong) UILabel *nope;

//@property (nonatomic,strong) UISlider *pictureRotationAngle;
@property (nonatomic) CGPoint centerOfStartingLocation;
@property (nonatomic) CGPoint startOfTouchLocationInMainView;

@property (nonatomic) CGPoint startOfTouchLocation;
@property (nonatomic) NSTimeInterval firstTouchTimestamp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat screenWidth = self.view.frame.size.width;
    
    //5 point border around the outside
    
    self.box = [[UIView alloc] initWithFrame:CGRectMake(5, 35, screenWidth - 10, screenWidth - 10)];
    UIView *box2 = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 5, 5)];
    box2.backgroundColor = [UIColor blackColor];
    
    self.box.backgroundColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
    
    UIImage *xida = [UIImage imageNamed:@"xida.jpg"];
    self.picture = [[UIImageView alloc] initWithImage:xida];
    self.picture.userInteractionEnabled = YES;
    self.picture.frame = CGRectMake(5, 25, screenWidth - 10, screenWidth - 10);
    self.picture.contentMode = UIViewContentModeTopLeft;
    self.picture.backgroundColor = [UIColor lightGrayColor];
    self.picture.clipsToBounds = YES;
    
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeSystem];
    
    reset.frame = CGRectMake(100, 400, 100, 50);
    [reset setTitle:@"Reset" forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(resetTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.like = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 50)];
    [self.like setFont:[UIFont systemFontOfSize:100]];
    self.like.text = @"L I K E";
    self.like.adjustsFontSizeToFitWidth = YES;
    [self.like setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [self.like setTextColor:[UIColor colorWithRed:47/255.0f green:156/255.0f blue:28/255.0f alpha:1]];
//    self.like.backgroundColor = [UIColor blueColor];
    self.like.transform = CGAffineTransformMakeRotation(-20* M_PI/180);
    self.like.alpha = 0;
    
    self.nope = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 10 - 20 - 130, 20, 140, 50)];
    [self.nope setFont:[UIFont systemFontOfSize:100]];
    self.nope.text = @"N O P E";
    self.nope.adjustsFontSizeToFitWidth = YES;
    [self.nope setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [self.nope setTextColor:[UIColor colorWithRed:255/255.0f green:61/255.0f blue:90/255.0f alpha:1]];
//    self.nope.backgroundColor = [UIColor blueColor];
    self.nope.transform = CGAffineTransformMakeRotation(20* M_PI/180);
    self.nope.alpha = 0;
    
    [self.view addSubview:self.box];
    [self.view addSubview:box2];
    [self.view addSubview:reset];
    [self.view addSubview:self.picture];
    
    [self.picture addSubview:self.like];
    [self.picture addSubview:self.nope];
    
    self.centerOfStartingLocation = self.picture.center;
    
    //slider
//        CGRect slideFrame = CGRectMake(100, 400, 200, 20);
//        self.pictureRotationAngle = [[UISlider alloc] initWithFrame:slideFrame];
//        [self.view addSubview:self.pictureRotationAngle];
//        self.pictureRotationAngle.minimumValue = 0;
//        self.pictureRotationAngle.maximumValue = 2*M_PI;
//        self.pictureRotationAngle.value = M_PI/2.0;
//    
//        [self.pictureRotationAngle addTarget:self action:@selector(rotateImage) forControlEvents:UIControlEventValueChanged];
//    
//        self.picture.transform = CGAffineTransformMakeRotation(self.pictureRotationAngle.value);
    
}

- (void) resetTapped
{
    [UIView animateWithDuration:0.6 animations:^{
        self.picture.center = self.centerOfStartingLocation;
        self.picture.transform = CGAffineTransformIdentity;
        self.box.transform = CGAffineTransformIdentity;
        self.like.alpha = 0;
        self.nope.alpha = 0;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
//{
//    NSLog(@"%f %f", gestureRecognizer.view.frame.origin.x, gestureRecognizer.view.frame.origin.y );
//
//}

- (void)rotateImage
{
    self.picture.transform = CGAffineTransformMakeRotation(self.pictureRotationAngle.value);

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    UIView *viewTouched = aTouch.view;
    
    if (viewTouched == self.picture) {
        UITouch *aTouch = [touches anyObject];
        
        self.startOfTouchLocation = [aTouch locationInView:aTouch.view];
        self.startOfTouchLocationInMainView = [aTouch locationInView:self.view];
        self.firstTouchTimestamp = aTouch.timestamp;
        
        NSLog(@"%@", aTouch);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    UIView *viewTouched = aTouch.view;
    
    if (viewTouched == self.picture) {
        CGPoint currentLocation = [aTouch locationInView:aTouch.view];
        
        CGFloat differenceInTouchLocationX = currentLocation.x - self.startOfTouchLocation.x;
        CGFloat differenceInTouchLocationY = currentLocation.y - self.startOfTouchLocation.y;
        
        CGFloat newCenterX = aTouch.view.center.x + differenceInTouchLocationX;
        CGFloat newCenterY = aTouch.view.center.y + differenceInTouchLocationY;
        
        CGPoint newCenter = CGPointMake(newCenterX, newCenterY);
        
        aTouch.view.center = newCenter;
        
        
        //factor that the picture turns by
        
        CGFloat dragFactor = 0;
        CGFloat maxDifferenceInTouchLocationX = aTouch.window.frame.size.width;
        
        
        //factor = 1 when movement is width/2
        dragFactor = differenceInTouchLocationX/maxDifferenceInTouchLocationX;
        
        
        
        //angle that the picture will turn
        CGFloat maxAngle = M_PI/4.0;
        CGFloat rotationAngle = dragFactor*maxAngle;
        
        viewTouched.transform = CGAffineTransformRotate(viewTouched.transform, -rotationAngle);
        
        
        //box should move up to the next location
        
        if (differenceInTouchLocationX < 0) {
            dragFactor *= -1;
        }
        
        if (self.box.transform.ty > -10 ) {
            self.box.transform = CGAffineTransformTranslate(self.box.transform, 0, 2*dragFactor * -10);
        }
        
        CGFloat changeInX = viewTouched.center.x - self.centerOfStartingLocation.x;
        if (changeInX < -20) {
            self.nope.alpha = MIN(-changeInX/100, 1);
            self.like.alpha = 0;
        }else if (changeInX > 20) {
            self.like.alpha = MIN(changeInX/100, 1);
            self.nope.alpha = 0;
        }else {
            self.like.alpha = 0;
            self.nope.alpha = 0;
        }
            
        
        NSLog(@"%@", aTouch);
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    UIView *viewTouched = aTouch.view;
    
    if (viewTouched == self.picture) {
        
        
        CGPoint currentLocation = [aTouch locationInView:self.view];
        CGFloat differenceInTouchLocationX = currentLocation.x - self.startOfTouchLocationInMainView.x;
        CGFloat differenceInTouchLocationY = currentLocation.y - self.startOfTouchLocationInMainView.y;
        CGFloat speedY = differenceInTouchLocationY/(aTouch.timestamp - self.firstTouchTimestamp);
        
        if (differenceInTouchLocationX > aTouch.window.frame.size.width*0.2) {
            [UIView animateWithDuration:0.5 animations:^{
                viewTouched.center = CGPointMake(self.view.frame.size.width*2, currentLocation.y + 0.5 * speedY) ;
                
            }];
            NSLog(@"%@", aTouch);
        }else if (differenceInTouchLocationX < -aTouch.window.frame.size.width*0.3)
        {
            [UIView animateWithDuration:0.5 animations:^{
                viewTouched.center = CGPointMake(-self.view.frame.size.width*2, currentLocation.y + 0.5 * speedY) ;
            }];
        }
        else {
            self.like.alpha = 0;
            self.nope.alpha = 0;
            
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                aTouch.view.center = self.centerOfStartingLocation;
                viewTouched.transform = CGAffineTransformIdentity;
                self.box.transform = CGAffineTransformIdentity;
            } completion:nil];
            

        }
        
    }
}








@end
