//
//  ImageCroppingView.h
//  ViteZite
//
//  Created by Kunal Darje on 26/06/14.
//
//

#import <UIKit/UIKit.h>
#import "KICropImageView.h"

@protocol ImageCroppingViewDelegate <NSObject>

-(void)imageIsDoneCropping:(UIImage *)image;
-(void)canceledCroppingImage;

@end

@interface ImageCroppingView : UIViewController{
    
    IBOutlet UIButton *btn_cancel;
    IBOutlet UIButton *btn_crop;
    IBOutlet UILabel *lbl_btn_bg;
    KICropImageView *_cropImageView;
    IBOutlet UIImageView *imageView;
}
@property (nonatomic) id<ImageCroppingViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *input_Image;

@property BOOL isProfileImage;

@end
