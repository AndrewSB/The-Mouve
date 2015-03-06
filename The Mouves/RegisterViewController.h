//
//  RegisterViewController.h
//  MOUVE
//
//  Created by SANDY on 28/08/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCroppingView.h"
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "Constant.h"
#import "CountryListViewController.h"

@interface RegisterViewController : BaseViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ImageCroppingViewDelegate,UITextFieldDelegate,PACountryListDelegate>
{
    IBOutlet UIButton *btn_image;
    IBOutlet UIImageView *profile_pic;
    IBOutlet UITextField *txt_name;
    IBOutlet UITextField *txt_userName;
    IBOutlet UITextField *txt_email;
    IBOutlet UITextField *txt_password;
    IBOutlet UITextField *txt_cf_password;
    IBOutlet UITextField *txt_mobile;
    IBOutlet UITextField *txt_code;
    IBOutlet UIButton *btn_register;
    
}
@property (nonatomic,retain) ImageCroppingView *crop_imageView;
@property BOOL isImage;
@property(nonatomic,retain) NSString *selected_image;

@property (nonatomic,strong) CountryDAO *currentCountry;
@property (nonatomic,strong) CountryDAO *db_obj;

@end
