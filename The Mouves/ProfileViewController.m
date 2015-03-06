//
//  ProfileViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/12/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "ProfileViewController.h"
#import "CountryListViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize selected_image,currentCountry,db_obj;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)selectedCountry:(CountryDAO *)country{
    currentCountry=country;
    
    if(currentCountry){
        [txt_code setText:[NSString stringWithFormat:@"+%@",currentCountry.phonecode]];
    }else{
        [txt_code setText:@""];
    }
}

-(IBAction)hideKeyBoard:(id)sender{
    [txt_name resignFirstResponder];
    [txt_userName resignFirstResponder];
    [txt_mobile resignFirstResponder];
    [txt_email resignFirstResponder];
    [txt_bio resignFirstResponder];
    [txt_password resignFirstResponder];
    [self SlideDownScreen];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    if(textField==txt_code){
        CountryListViewController *paViewController = [[CountryListViewController alloc]
                                                       initWithNibName:nil bundle:nil];
        paViewController.delegate=self;
        paViewController.selectedCountry=currentCountry;
        [self.navigationController pushViewController:paViewController animated:YES];
        return NO;
    }else{
    [self SlideupScreen:textField];
        return YES;
    }
}


-(void)SlideupScreen:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if ([[UIScreen mainScreen] bounds].size.height ==480)
    {
        
        if ([txt_name isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0, -30,320, self.view.frame.size.height)];
        }else if ([txt_userName isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0, -60, 320, self.view.frame.size.height)];
        }else if ([txt_bio isFirstResponder])
        {
            [self.view setFrame:CGRectMake(0,  -90,320,  self.view.frame.size.height)];
        }else if ([txt_code isEqual:textField] || [txt_mobile isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -120,320,  self.view.frame.size.height)];
        }else if ([txt_email isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -150,320,  self.view.frame.size.height)];
        }else if ([txt_password isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -180,320,  self.view.frame.size.height)];
        }
        
    }else{
        if ([txt_name isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0, -30,320, self.view.frame.size.height)];
        }else if ([txt_userName isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0, -60, 320, self.view.frame.size.height)];
        }else if ([txt_bio isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -90,320,  self.view.frame.size.height)];
        }else if ([txt_code isEqual:textField] || [txt_mobile isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -120,320,  self.view.frame.size.height)];
        }else if ([txt_email isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -150,320,  self.view.frame.size.height)];
        }else if ([txt_password isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -180,320,  self.view.frame.size.height)];
        }
    }
    
    [UIView commitAnimations];
}

-(void)SlideDownScreen{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}



-(void) setSmallBorder:(int)width{
    [profile_pic.layer setCornerRadius:(profile_pic.frame.size.width)/2];
    [profile_pic.layer setBorderWidth:0];
    [profile_pic.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [profile_pic.layer setMasksToBounds:YES];
    
    self.title=@"Create an account";
}



-(void)setUserData{
    txt_name.text=[Utiles getUserDataForKey:@"Name"];
    txt_userName.text=[Utiles getUserDataForKey:@"UserName"];
    txt_email.text=[Utiles getUserDataForKey:@"EmailID"];
    txt_bio.text=[Utiles getUserDataForKey:@"Bio"];
    txt_mobile.text=[Utiles getUserDataForKey:@"MobileNo"];
    txt_code.text=[Utiles getUserDataForKey:@"CountryCode"];    
    txt_password.text=@"";
    
    
    if([Utiles getUserDataForKey:@"UsersPhoto"]){
        NSString *relativeURL=[Utiles getUserDataForKey:@"UsersPhoto"];
        
        if(relativeURL!= (id)[NSNull null] && relativeURL.length>0){
            
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:USER_PHOTO_URL,relativeURL]];
            
            [profile_pic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"whtcrcl.png"]];
            }
    }
}

-(void)DoLogin{
    
      MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *UserName=[userDefaults objectForKey:@"UserName"];
    NSString *Password=[userDefaults objectForKey:@"Password"];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[UserName lowercaseString] forKey:@"UserName"];
    [dict setObject:[Utiles md5:Password] forKey:@"Password"];
    [[AFAppAPIClient WSsharedClient] POST:API_LOGIN
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      
                                      [hud hide:YES];
                                      
                                      NSDictionary *dict_res=(NSDictionary *)responseObject;
                                      
                                      
                                      NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                      if([isSuccessNumber boolValue] == YES)
                                      {
                                          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                          [userDefaults setObject:[dict_res objectForKey:DATA] forKey:@"MyData"];
                                          [userDefaults synchronize];
                                          
                                          [Utiles showAlert:APP_NAME Message:@"Profile Updated Successfully."];
                                          
                                      }else{
                                          
                                          [Utiles showAlert:ERROR Message:@"Profile update fails."];
                                      }
                                      
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [hud hide:YES];
                                      
                                      [Utiles showAlert:ERROR Message:[error localizedDescription]];
                                      
                                  }];
}





-(IBAction)updateProfile:(id)sender{
    
    if(txt_name.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter Name"];
        return;
    }
    if(txt_userName.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter UserName"];
        return;
    }
    
    if(txt_mobile.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter Mobile No."];
        return;
    }else  if(txt_mobile.text.length>10){
        [Utiles showAlert:APP_NAME Message:@"Enter 10 digit mobile number."];
        return;
    }

    
    if(txt_email.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter Email"];
        return;
    }else if (![Utiles validEmail:[txt_email.text lowercaseString]] ) {
        [Utiles showAlert:APP_NAME Message:@"Enter valid email"];
        return;
    }
    
    if(txt_password.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter Password"];
        return;
    }
    
    if(txt_code.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Select country code"];
        return;
    }
    
    [txt_name resignFirstResponder];
    [txt_userName resignFirstResponder];
    [txt_email resignFirstResponder];
    [txt_mobile resignFirstResponder];
    [txt_password resignFirstResponder];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[Utiles getUserDataForKey:@"UserID"] forKey:@"UserID"];
    [dict setObject:txt_name.text forKey:@"Name"];
    [dict setObject:txt_userName.text forKey:@"UserName"];
    [dict setObject:txt_email.text forKey:@"EmailID"];
    [dict setObject:[Utiles md5:txt_password.text] forKey:@"Password"];
    [dict setObject:txt_bio.text forKey:@"Bio"];
    [dict setObject:@"Male" forKey:@"Gender"];
    [dict setObject:txt_mobile.text forKey:@"MobileNo"];
    [dict setObject:txt_code.text forKey:@"CountryCode"];
    
    if(self.selected_image.length>0){
        [dict setObject:self.selected_image forKey:@"UsersPhoto"];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppAPIClient WSsharedClient] POST:API_USER_UPDATE
                             parameters:dict
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    
                                    [hud hide:YES];
                                    
                                    NSDictionary *dict_res=(NSDictionary *)responseObject;                                    
                                    
                                    NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: @"Result"];
                                    if([isSuccessNumber boolValue] == YES)
                                    {
                                        
                                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                        
                                        [userDefaults setObject:txt_userName.text forKey:@"UserName"];
                                        [userDefaults setObject:txt_password.text forKey:@"Password"];
                                        
                                        [userDefaults synchronize];
                                        
                                        [self DoLogin];
                                        
                                    }else{
                                        [Utiles showAlert:APP_NAME Message:@"Profile Update fail."];
                                    }
                                    
                                    
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                    [hud hide:YES];

                                    [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                    
                                }];
    
    
    
}





-(void)viewWillAppear:(BOOL)animated{
    self.title=@"Profile";
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _isImage=FALSE;
    
    [self setUserData];
    [self setSmallBorder:1];
}

-(IBAction)btn_Image_Clicked:(id)sender{
    
    BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    NSString *actionSheetTitle = @"Profile photo";
    NSString *other1 = @"Camera";
    NSString *other2 = @"Gallery";
    NSString *other3 = @"Remove";
    NSString *cancelTitle = @"Cancel";
    
    if(isCamera){
        
        
        if (_isImage) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:actionSheetTitle
                                          delegate:self
                                          cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:other1, other2,other3, nil];
            
            [actionSheet showInView:self.view];
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:actionSheetTitle
                                          delegate:self
                                          cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:other1, other2, nil];
            
            [actionSheet showInView:self.view];
            
        }
        
        
    }else{
        
        
        if (_isImage) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:actionSheetTitle
                                          delegate:self
                                          cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:other2,other3, nil];
            
            [actionSheet showInView:self.view];
            
        }else{
            _isImagePicking=TRUE;
            UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController presentViewController:picker animated:YES completion:^{}];
        }
        
        
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int i = buttonIndex;
    
    switch(i)
    {
        case 0:
        {
            
            BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if(isCamera){
                 _isImagePicking=TRUE;
                UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
                [self.navigationController presentViewController:picker animated:YES completion:^{}];
            }else{
                _isImagePicking=TRUE;
                UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController presentViewController:picker animated:YES completion:^{}];
            }
        }
            break;
        case 1:
        {
            BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if(isCamera){
                 _isImagePicking=TRUE;
                UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController presentViewController:picker animated:YES completion:^{}];
            }else{
                profile_pic.image=[UIImage imageNamed:@"whtcrcl.png"];
                _isImage=FALSE;
            }
        }
            
        case 2:
        {
            profile_pic.image=[UIImage imageNamed:@"whtcrcl.png"];
            _isImage=FALSE;
        }
            break;
        default:
            
            break;
    }
    
}

#pragma - mark Selecting Image from Camera and Library

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _isImage=TRUE;
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
   
    UIImage *resize=[self processImage:selectedImage];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.crop_imageView=[[ImageCroppingView alloc] initWithNibName:@"ImageCroppingView" bundle:nil];
    
    self.crop_imageView.delegate=self;
    self.crop_imageView.isProfileImage=TRUE;
    self.crop_imageView.input_Image=resize;
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    [appDelegate.window addSubview:self.crop_imageView.view];
    [self addChildViewController:self.crop_imageView];
    
     _isImagePicking=FALSE;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

-(UIImage *) processImage:(UIImage *)org_img{
    
    @try {
        
        
        UIImage *rotatedImage;
        
        if (org_img.imageOrientation != UIImageOrientationUp)
        {
            UIGraphicsBeginImageContextWithOptions(org_img.size, NO, org_img.scale);
            
            [org_img drawInRect:(CGRect){0, 0, org_img.size}];
            
            rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
        }
        else
        {
            rotatedImage = org_img;
        }
        
        
        
        return rotatedImage;
    }
    @catch (NSException *exception) {
        
        
    }
}

-(void)imageIsDoneCropping:(UIImage *)image{
    profile_pic.image=image;
    self.selected_image=[Utiles encodeToBase64String:image];
    
    //[self updatePhoto:0];
    [self canceledCroppingImage];
}
-(void)canceledCroppingImage{
    [self.crop_imageView.view removeFromSuperview];
    [self.crop_imageView removeFromParentViewController];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
