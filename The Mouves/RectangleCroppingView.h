//
//  RectangleCroppingView.h
//  MOUVE
//
//  Created by  on 26/06/14.
//
//

#import <UIKit/UIKit.h>

@protocol RectangleCroppingDelegate <NSObject>

-(void)imageIsDoneCropping:(UIImage *)image;
-(void)canceledCroppingImage;

@end

@interface RectangleCroppingView : UIViewController<UIGestureRecognizerDelegate>{
    CGFloat upperY;
    CGFloat lowerY;
    CGFloat rightX;
    CGFloat  leftX;
    
    IBOutlet UIButton *btn_cancel;
    IBOutlet UIButton *btn_crop;
    IBOutlet UILabel *lbl_btn_bg;
}
@property (nonatomic) id<RectangleCroppingDelegate> delegate;
@property (nonatomic, strong) UIImage *imageView;

@property (nonatomic) CGFloat circleRadius;
@property (nonatomic) CGFloat rectWidth;
@property (nonatomic) CGFloat rectHeight;
@property (nonatomic) CGPoint circleCenter;

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinch;
@property (nonatomic, strong) UIPanGestureRecognizer   *pan;
@end
