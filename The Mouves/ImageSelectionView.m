//
//  ImageSelectionView.m
//
//
//  Created by  on 11/06/14.
//
//

#import "ImageSelectionView.h"

@interface ImageSelectionView ()

@end

@implementation ImageSelectionView
@synthesize imageView,selectImageView,circleRadius,circleCenter,maskLayer,circleLayer,pinch,pan,backgroungImageview,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectImageView.contentMode = UIViewContentModeScaleAspectFit;
    backgroungImageview.contentMode = UIViewContentModeScaleAspectFit;
    
    selectImageView.image=imageView;
    backgroungImageview.image=imageView;
    backgroungImageview.alpha=0.2;
    // create layer mask for the image
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    CGRect firstFrame=selectImageView.frame;
    
    if (screenSize.height!=568) {
        selectImageView.frame=CGRectMake(firstFrame.origin.x, firstFrame.origin.y, firstFrame.size.width, firstFrame.size.height-87);
        backgroungImageview.frame=CGRectMake(firstFrame.origin.x, firstFrame.origin.y, firstFrame.size.width, firstFrame.size.height-87);
        
        btn_cancel.frame=CGRectMake(0, firstFrame.size.height-10, 105,52);
        btn_crop.frame=CGRectMake(155, firstFrame.size.height-10, 163,52);
        lbl_btn_bg.frame=CGRectMake(0, firstFrame.size.height-20, 320,87);
    }
    
    
    upperY=firstFrame.origin.y;
    lowerY=firstFrame.origin.y+selectImageView.frame.size.height;
    
    leftX=firstFrame.origin.x;
    rightX=firstFrame.origin.x+selectImageView.frame.size.width;
    
    maskLayer = [CAShapeLayer layer];
    
    
    self.selectImageView.layer.mask = maskLayer;
    [self.selectImageView.layer setMasksToBounds:YES];
    self.maskLayer =maskLayer;
    
    circleLayer = [CAShapeLayer layer];
    
    circleLayer.lineWidth =2.0;
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    circleLayer.strokeColor = [[UIColor blackColor] CGColor];
    [self.selectImageView.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    
    // create circle path
    
    [self updateCirclePathAtLocation:CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0) radius:self.view.bounds.size.width * 0.30];
    
    // create pan gesture
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    [self.selectImageView addGestureRecognizer:pan];
    self.selectImageView.userInteractionEnabled = YES;
    self.pan = pan;
    
    // create pan gesture
    
  pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
    self.pinch = pinch;

    // Do any additional setup after loading the view from its nib.
}

- (void)updateCirclePathAtLocation:(CGPoint)location radius:(CGFloat)radius
{
    self.circleCenter = location;
    self.circleRadius = radius;
    
    float pointX=location.x;
    float pointY=location.y;
    
    float circumferencePointLeftX=pointX-radius;
    float circumferencePointRightX=pointX+radius;
    float circumferencePointUpperY=pointY-radius;
    float circumferencePointLowerY=pointY+radius;
    
    if (circumferencePointRightX>rightX ) {
        pointX=rightX-radius;
    }
    if (circumferencePointLeftX<leftX) {
        pointX=leftX+radius;
    }
    
    if (circumferencePointLowerY>lowerY) {
        pointY=lowerY-radius;
    }
     if (circumferencePointUpperY<upperY) {
        pointY=upperY+radius;
    }
    
    pointY=pointY-upperY;
    
    location.x=pointX;
    location.y=pointY;
    self.circleCenter = location;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.circleCenter
                    radius:self.circleRadius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    self.maskLayer.path = [path CGPath];
    self.circleLayer.path = [path CGPath];
}

-(void)updatePathForPinch:(CGPoint)location radious:(CGFloat)radious{
    self.circleCenter = location;
    self.circleRadius = radious;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.circleCenter
                    radius:self.circleRadius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    self.maskLayer.path = [path CGPath];
    self.circleLayer.path = [path CGPath];
    
}

#pragma mark - Gesture recognizers

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    static CGPoint oldCenter;
    CGPoint tranlation = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        oldCenter = self.circleCenter;
    }
    
    
     CGPoint newCenter = CGPointMake(oldCenter.x + tranlation.x, oldCenter.y + tranlation.y);
   
    [self updateCirclePathAtLocation:newCenter radius:self.circleRadius];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
{
    //BOOL OKtoPinch=YES;
    static CGFloat oldRadius;
    CGFloat scale = [gesture scale];
    
    oldRadius = self.circleRadius;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        oldRadius = self.circleRadius;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self updateCirclePathAtLocation:self.circleCenter radius:oldRadius];
    }
   
    CGFloat newRadius = oldRadius * scale;
    
    NSLog(@"the scale is %f",scale);
    
    if (newRadius<30.00) {
        newRadius=30.00;
    }
    else if (newRadius>160.00){
        newRadius=160.00;
    }
    
    [self updatePathForPinch:self.circleCenter radious:newRadius];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ((gestureRecognizer == self.pan   && otherGestureRecognizer == self.pinch) ||
        (gestureRecognizer == self.pinch && otherGestureRecognizer == self.pan))
    {
        return YES;
    }
    
    return NO;
}

- (IBAction)doneButtonPressed:(id)sender {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"image.png"];
    
    CGFloat scale  = [[self.selectImageView.window screen] scale];
    CGFloat radius = self.circleRadius * scale;
    
    CGPoint center = CGPointMake(self.circleCenter.x * scale, self.circleCenter.y * scale);
    
    CGRect frame = CGRectMake(center.x - radius,
                              center.y - radius,
                              radius * 2.0,
                              radius * 2.0);
    
    // temporarily remove the circleLayer
    
   
    [self.circleLayer removeFromSuperlayer];
    
    // render the clipped image
    
    UIGraphicsBeginImageContextWithOptions(self.selectImageView.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ([self.imageView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        // if iOS 7, just draw it
        
        [self.selectImageView drawViewHierarchyInRect:self.selectImageView.bounds afterScreenUpdates:YES];
    }
    else
    {
        // if pre iOS 7, manually clip it
        
        CGContextAddArc(context, self.circleCenter.x, self.circleCenter.y, self.circleRadius, 0, M_PI * 2.0, YES);
        CGContextClip(context);
        [self.selectImageView.layer renderInContext:context];
    }
    
    // capture the image and close the context
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // add the circleLayer back
    
    [self.selectImageView.layer addSublayer:circleLayer];
    
    // crop the image
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], frame);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    [self.delegate applySelectedImageAndUpdate:croppedImage];
    
    // save the image
    
//    NSData *data = UIImagePNGRepresentation(croppedImage);
//    [data writeToFile:path atomically:YES];
    
    // tell the user we're done
    
  

}
- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate canceledImageSelection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
