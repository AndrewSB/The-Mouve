//
//  ImageSelectionView.h
//
//
//  Created by  on 11/06/14.
//
//

#import <UIKit/UIKit.h>
@class ImageSelectionView;
@protocol SelectionImageSelegate <NSObject>

-(void)applySelectedImageAndUpdate:(UIImage *)cropedImage;
-(void)canceledImageSelection;

@end
@interface ImageSelectionView : UIViewController<UIGestureRecognizerDelegate>{
    float upperY;
    float lowerY;
    float rightX;
    float leftX;
    float oldScale;
    IBOutlet UIButton *btn_cancel;
    IBOutlet UIButton *btn_crop;
    IBOutlet UILabel *lbl_btn_bg;
}
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (nonatomic, strong) UIImage *imageView;

@property (nonatomic) CGFloat circleRadius;
@property (nonatomic) CGPoint circleCenter;

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinch;
@property (weak, nonatomic) IBOutlet UIImageView *backgroungImageview;
@property (nonatomic, strong) UIPanGestureRecognizer   *pan;
@property (nonatomic, strong) id<SelectionImageSelegate> delegate;
@end
