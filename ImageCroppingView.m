//
//  ImageCroppingView.m
//  ViteZite
//
//  Created by Kunal Darje on 26/06/14.
//
//

#import "ImageCroppingView.h"

@interface ImageCroppingView ()

@end

@implementation ImageCroppingView
@synthesize imageView,input_Image,isProfileImage;


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
   
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    self.view.frame=screenBound;
    
    if (screenSize.height!=480) {
        
        imageView.frame=CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width,screenSize.height-150);
        
        btn_cancel.frame=CGRectMake(11, screenSize.height-60, 105,52);
        btn_crop.frame=CGRectMake(147, screenSize.height-60, 163,52);
        lbl_btn_bg.frame=CGRectMake(0, screenSize.height-100, 320,150);
    }
        
    _cropImageView = [[KICropImageView alloc] initWithFrame:imageView.frame];
    if(self.isProfileImage){
        [_cropImageView setCropSize:CGSizeMake(250, 250)];
     }else{
       [_cropImageView setCropSize:CGSizeMake(285, 160)];
    }
    [_cropImageView setImage:input_Image];
    [self.view addSubview:_cropImageView];
  
}


- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate canceledCroppingImage];
}

- (IBAction)doneButtonPressed:(id)sender {
    
    UIImage *croppedImage =  [_cropImageView cropImage];
    //int height=croppedImage.size.height;
   // int width= croppedImage.size.width;
    [self.delegate imageIsDoneCropping:croppedImage];
    
    if(self.isProfileImage){
        CGSize cgsize = CGSizeMake(200,200);
        croppedImage=[self imageWithImage:croppedImage scaledToSize:cgsize];
        [self.delegate imageIsDoneCropping:croppedImage];
    }else{
        
        CGSize cgsize = CGSizeMake(568,320);
        croppedImage=[self imageWithImage:croppedImage scaledToSize:cgsize];
        
        [self.delegate imageIsDoneCropping:croppedImage];
    }
    
}


- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
