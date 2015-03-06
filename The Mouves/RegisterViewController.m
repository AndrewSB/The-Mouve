//
//  RegisterViewController.m
//  MOUVE
//
//  Created by SANDY on 28/08/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "RegisterViewController.h"
#import "ImageSelectionView.h"
#import "AFAppAPIClient.h"
#import "InviteFirstViewController.h"



@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize crop_imageView,selected_image,currentCountry,db_obj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}


-(void) setSmallBorder:(int)width{
    [profile_pic.layer setCornerRadius:(profile_pic.frame.size.width)/2];
    [profile_pic.layer setBorderWidth:0];
    [profile_pic.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [profile_pic.layer setMasksToBounds:YES];
    
    self.title=@"Create an account";
}

-(void)selectedCountry:(CountryDAO *)country{
    currentCountry=country;
    
    if(currentCountry){
        [txt_code setText:[NSString stringWithFormat:@" +%@",currentCountry.phonecode]];
    }else{
        [txt_code setText:@""];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentCountry=[[CountryDAO alloc] init];
    db_obj=[[CountryDAO alloc] init];
    currentCountry=[db_obj getMyCountry];
    
    if(currentCountry){
        [txt_code setText:[NSString stringWithFormat:@" +%@",currentCountry.phonecode]];
    }else{
        [txt_code setText:@""];
    }

    
    _isImage=FALSE;
    
    [self setSmallBorder:1];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self SlideDownScreen];
    [textField resignFirstResponder];
    return YES;
}


-(IBAction)hideKeyBoard:(id)sender{
    [txt_name resignFirstResponder];
    [txt_userName resignFirstResponder];
    [txt_mobile resignFirstResponder];
    [txt_email resignFirstResponder];
    [txt_password resignFirstResponder];
    [self SlideDownScreen];
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
        }else if ([txt_mobile isFirstResponder])
        {
            [self.view setFrame:CGRectMake(0,  -90,320,  self.view.frame.size.height)];
        }else if ([txt_email isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -120,320,  self.view.frame.size.height)];
        }else if ([txt_password isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -150,320,  self.view.frame.size.height)];
        }else if ([txt_cf_password isEqual:textField])
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
        }else if ([txt_mobile isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -90,320,  self.view.frame.size.height)];
        }else if ([txt_email isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -120,320,  self.view.frame.size.height)];
        }else if ([txt_password isEqual:textField])
        {
            [self.view setFrame:CGRectMake(0,  -150,320,  self.view.frame.size.height)];
        }else if ([txt_cf_password isEqual:textField])
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

#pragma mark Keyboard Delegates Methods

- (void)keyboardDidShow:(NSNotification *)notification
{
   //[self SlideupScreen];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
   [self SlideDownScreen];
}


-(void)DoLogin{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[txt_userName.text lowercaseString] forKey:@"UserName"];
    [dict setObject:[Utiles md5:txt_password.text] forKey:@"Password"];
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
                                        
                                         [userDefaults setObject:txt_userName.text forKey:@"UserName"];
                                        [userDefaults setObject:txt_password.text forKey:@"Password"];
                                        
                                        [userDefaults synchronize];
                                        
                                         [hud hide:YES];
                                        
                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        InviteFirstViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"InviteFirstViewController"];
                                        
                                        [self.navigationController pushViewController:view animated:YES];
                                        
                                    }else{
                                        [hud hide:YES];
                                        [Utiles showAlert:APP_NAME Message:@"Login fail."];
                                    }
                                    
                                    
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [hud hide:YES];
                                    [Utiles showAlert:ERROR Message:[error localizedDescription]];
                                    
                                }];
}

-(NSString *)errorMessage:(NSDictionary *)dict{
    NSString *error=@"";

    NSArray *data=[dict objectForKey:DATA];
    
    NSMutableArray *message_array=[[NSMutableArray alloc] init];
   
    if([data count]>0){
    
        NSDictionary *data_dict=[data objectAtIndex:0];
        
        if([[data_dict objectForKey:@"EmailID"] intValue]>0){
            [message_array addObject:@"EmailID"];
        }
        if([[data_dict objectForKey:@"MobileNo"] intValue]>0){
            [message_array addObject:@"MobileNo"];
        }
        if([[data_dict objectForKey:@"UserName"] intValue]>0){
            [message_array addObject:@"UserName"];
        }
        
        for (int i=0;i<[message_array count];  i++) {
            
            if([message_array count]==1 || [message_array count]==(i+1)){
                error = [error stringByAppendingString:[message_array objectAtIndex:i]];
            }else{
                error = [error stringByAppendingString:[NSString stringWithFormat:@"%@, ",[message_array objectAtIndex:i]]];
            }
        }
        
        if(error.length>0 && [message_array count]>1){
         error = [error stringByAppendingString:@" combination already exits."];
        }else  if(error.length>0 && [message_array count]==1){
         error = [error stringByAppendingString:@" already exits."];
        }
    }
    
    return error;
}



-(void)checkValidUser:(NSDictionary *)dict{
    
    NSMutableDictionary *valid_dict=[[NSMutableDictionary alloc] init];
    [valid_dict setObject:txt_email.text forKey:@"EmailID"];
    [valid_dict setObject:[txt_userName.text lowercaseString] forKey:@"UserName"];
    [valid_dict setObject:[dict objectForKey:@"MobileNo"] forKey:@"MobileNo"];
    [valid_dict setObject:[dict objectForKey:@"CountryCode"] forKey:@"CountryCode"];
        
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppAPIClient WSsharedClient] POST:API_VALID_USER
                               parameters:valid_dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      [hud hide:YES];
                                      
                                      NSDictionary *dict_res=(NSDictionary *)responseObject;
                                      
                                      NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                      if([isSuccessNumber boolValue] == YES)
                                      {
                                          [self registerUser:dict];
                                          
                                      }else{
                                          
                                          NSString *error_message=[self errorMessage:dict_res];
                                          if(error_message.length>0){
                                              [Utiles showAlert:ERROR Message:error_message];
                                          }else{
                                            [Utiles showAlert:ERROR Message:[dict_res objectForKey: @"Message"]];
                                          }
                                      }
                                      
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [hud hide:YES];
                                      [Utiles showAlert:ERROR Message:[error localizedDescription]];
                                      
                                  }];
    
}

-(void)registerUser:(NSDictionary *)dict{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppAPIClient WSsharedClient] POST:API_REGISTER
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      [hud hide:YES];
                                      
                                      NSDictionary *dict_res=(NSDictionary *)responseObject;
                                      
                                      NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                      if([isSuccessNumber boolValue] == YES)
                                      {
                                          [self DoLogin];
                                          
                                      }else{
                                          
                                          [Utiles showAlert:ERROR Message:@"Register fail."];
                                      }
                                      
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [hud hide:YES];
                                      [Utiles showAlert:ERROR Message:[error localizedDescription]];
                                      
                                  }];
    

}

-(IBAction)doRegister:(id)sender{
    
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
    
    if(txt_cf_password.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter Confirm Password"];
        return;
    }
    
    
    if(txt_password.text.length>0 && txt_cf_password.text.length>0){
        if(![txt_password.text isEqualToString:txt_cf_password.text]){
            [Utiles showAlert:APP_NAME Message:@"Confirm Password does not match with Password."];
            return;
        }
    }else if(txt_password.text.length!= txt_cf_password.text.length){
        [Utiles showAlert:APP_NAME Message:@"Confirm Password does not match with Password."];
        return;
    }
    
    if(txt_code.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Select country code"];
        return;
    }
    
    //if(self.selected_image.length==0){
      //  [Utiles showAlert:APP_NAME Message:@"Set Profile Photo"];
      //  return;
    //}
    
    [txt_name resignFirstResponder];
    [txt_userName resignFirstResponder];
    [txt_email resignFirstResponder];
    [txt_mobile resignFirstResponder];
    [txt_password resignFirstResponder];    
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:txt_name.text forKey:@"Name"];
    [dict setObject:[txt_userName.text lowercaseString] forKey:@"UserName"];
    [dict setObject:txt_email.text forKey:@"EmailID"];
    [dict setObject:[Utiles md5:txt_password.text] forKey:@"Password"];
    [dict setObject:@"" forKey:@"Bio"];
    [dict setObject:@"Male" forKey:@"Gender"];
    [dict setObject:txt_mobile.text forKey:@"MobileNo"];
    [dict setObject:[txt_code.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"CountryCode"];
    
    if(self.selected_image.length>0){
      [dict setObject:self.selected_image forKey:@"UsersPhoto"];
    }
    
    [self checkValidUser:dict];

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
                UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
                [self.navigationController presentViewController:picker animated:YES completion:^{}];
            }else{
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
                
            UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController presentViewController:picker animated:YES completion:^{}];
            }else{
                profile_pic.image=[UIImage imageNamed:@"whtcrcl.png"];
                self.selected_image=@"";
                _isImage=FALSE;
            }
        }
            
        case 2:
        {
            profile_pic.image=[UIImage imageNamed:@"whtcrcl.png"];
            self.selected_image=@"";
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
    
    self.crop_imageView.input_Image=resize;
    
    self.crop_imageView.isProfileImage=TRUE;
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    [appDelegate.window addSubview:self.crop_imageView.view];
    [self addChildViewController:self.crop_imageView];
    
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
    [self canceledCroppingImage];
}
-(void)canceledCroppingImage{
    [self.crop_imageView.view removeFromSuperview];
    [self.crop_imageView removeFromParentViewController];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
