//
//  RectangleCroppingView.m
//  MOUVE
//
//  Created by  on 26/06/14.
//
//

#import "RectangleCroppingView.h"

@interface RectangleCroppingView ()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroungImageview;

@end

@implementation RectangleCroppingView
@synthesize imageView;
@synthesize selectImageView;
@synthesize backgroungImageview;
 @synthesize circleRadius,circleCenter,maskLayer,circleLayer,pinch,pan,rectHeight,rectWidth,delegate;

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
    // Do any additional setup after loading the view from its nib.
    selectImageView.contentMode = UIViewContentModeScaleAspectFit;
    backgroungImageview.contentMode = UIViewContentModeScaleAspectFit;
    selectImageView.image=imageView;
    backgroungImageview.image=imageView;
    backgroungImageview.alpha=0.2;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    CGRect firstFrame=selectImageView.frame;
    
    if (screenSize.height!=568) {
        selectImageView.frame=CGRectMake(firstFrame.origin.x, firstFrame.origin.y, firstFrame.size.width, firstFrame.size.height-87);
        backgroungImageview.frame=CGRectMake(firstFrame.origin.x, firstFrame.origin.y, firstFrame.size.width, firstFrame.size.height-87);
        
        btn_cancel.frame=CGRectMake(11, firstFrame.size.height-10, 105,52);
        btn_crop.frame=CGRectMake(147, firstFrame.size.height-10, 163,52);
        lbl_btn_bg.frame=CGRectMake(0, firstFrame.size.height-20, 320,87);
    }
    
    upperY=0;
    lowerY=selectImageView.frame.size.height;
    
    leftX=firstFrame.origin.x;
    rightX=firstFrame.origin.x+selectImageView.frame.size.width;
    
    maskLayer = [CAShapeLayer layer];
    
    self.rectWidth=200;
    self.rectHeight=85;
    
    self.selectImageView.layer.mask = maskLayer;
    [self.selectImageView.layer setMasksToBounds:YES];
    self.maskLayer =maskLayer;
    
    circleLayer = [CAShapeLayer layer];
    
    circleLayer.lineWidth =2.0;
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    circleLayer.strokeColor = [[UIColor blackColor] CGColor];
    [self.selectImageView.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
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

}
- (void)updateCirclePathAtLocation:(CGPoint)location radius:(CGFloat)radius
{
    
    self.circleRadius = radius;
    
    if (location.x+(self.rectWidth/2)>rightX) {
        location.x=(rightX-(self.rectWidth/2));
    }
    
    CGFloat value=location.x-(self.rectWidth/2);
    if (value<0) {
        location.x =(self.rectWidth/2);
    }
    
    if (location.y+(self.rectHeight/2)>lowerY) {
        location.y  = lowerY-(self.rectHeight/2);
    }
    
    if (location.y-(self.rectHeight/2)<upperY) {
        location.y=upperY+(self.rectHeight/2);
    }
    
    
    self.circleCenter = location;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(location.x-(self.rectWidth/2), location.y-(self.rectHeight/2), self.rectWidth, self.rectHeight)];
    
    self.maskLayer.path = [path CGPath];
    self.circleLayer.path = [path CGPath];
}

-(void)updatePathForPinch:(CGPoint)location radious:(CGFloat)radious{
    self.circleCenter = location;
    self.circleRadius = radious;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(location.x-(self.rectWidth/2), location.y-(self.rectHeight/2), self.rectWidth, self.rectHeight)];
    
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
    self.rectHeight=self.rectHeight*scale;
    self.rectWidth=self.rectWidth*scale;
    
    if (self.rectWidth<100) {
        self.rectWidth=100;
    }
    else if (self.rectWidth>320){
        self.rectWidth=320;
    }
    
    if (self.rectHeight<63) {
        self.rectHeight=63;
    }
    else if (self.rectHeight>136){
        self.rectHeight=136;
    }
    
    
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

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate canceledCroppingImage];
}

- (IBAction)doneButtonPressed:(id)sender {
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"image.png"];
    
    CGFloat scale  = [[self.selectImageView.window screen] scale];
    CGFloat radius = self.circleRadius * scale;
    CGPoint center = CGPointMake(self.circleCenter.x * scale, self.circleCenter.y * scale);
    
    CGRect frame = CGRectMake((self.circleCenter.x-(self.rectWidth/2))*scale, (self.circleCenter.y-(self.rectHeight/2))*scale,
                              self.rectWidth*scale,
                              self.rectHeight*scale);
    
    // temporarily remove the circleLayer
    
    
   // [self.circleLayer removeFromSuperlayer];
    
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
        
        //CGContextAddArc(context, self.circleCenter.x, self.circleCenter.y, self.circleRadius, 0, M_PI * 2.0, YES);
        CGContextAddRect(context, CGRectMake(self.circleCenter.x-(self.rectWidth/2), self.circleCenter.y-(self.rectHeight/2), self.rectWidth, self.rectHeight));
        CGContextClip(context);
        [self.selectImageView.layer renderInContext:context];
    }
    
    // capture the image and close the context
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // add the circleLayer back
    
   // [self.selectImageView.layer addSublayer:circleLayer];
    
    // crop the image
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], frame);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    [self.delegate imageIsDoneCropping:croppedImage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
