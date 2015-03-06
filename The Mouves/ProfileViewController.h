//
//  ProfileViewController.h
//  MOUVE
//
//  Created by Sandeep on 9/12/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCroppingView.h"
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "CountryDAO.h"
#import "CountryListViewController.h"

@interface ProfileViewController : BaseViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ImageCroppingViewDelegate,UITextFieldDelegate,PACountryListDelegate>
{

    IBOutlet UIButton *btn_image;
    IBOutlet UIImageView *profile_pic;   
    
    IBOutlet UITextField *txt_name;
    IBOutlet UITextField *txt_userName;
    IBOutlet UITextField *txt_email;
    IBOutlet UITextField *txt_password;
    IBOutlet UITextField *txt_mobile;
    IBOutlet UITextField *txt_code;
    IBOutlet UITextField *txt_bio;
    IBOutlet UIButton *btn_update;
    
}
@property (nonatomic,retain) ImageCroppingView *crop_imageView;
@property BOOL isImage;
@property BOOL isImagePicking;
@property(nonatomic,retain) NSString *selected_image;
@property (nonatomic,strong) CountryDAO *currentCountry;
@property (nonatomic,strong) CountryDAO *db_obj;

@end
