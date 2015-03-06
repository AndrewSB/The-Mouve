//
//  LoginViewController.m
//  MOUVE
//
//  Created by SANDY on 27/08/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "LoginViewController.h"
#import "AFAppAPIClient.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) RegisterForPush{
    
    @try {
        
        
        NSString *deviceTokenStr=[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
        
        // NSString *deviceTokenStr=@"RNHYV98H6798749455654F7678HFGVC8GFNV8RG7TV8YR8YR8GY8RYG";
        
        if(deviceTokenStr.length>0){
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            [dict setObject:[Utiles getUserDataForKey:@"UserID"] forKey:@"UserID"];
            [dict setObject:deviceTokenStr forKey:@"DeviceToken"];
            NSString *OS_Version=[[UIDevice currentDevice] systemVersion];
            [dict setObject:OS_Version forKey:@"OS_Version"];
            [dict setObject:@"IOS" forKey:@"Device_Type"];
            [dict setObject:@"iPhone5c" forKey:@"Device_Model"];
            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"IsActive"];
            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"IsFollowerActive"];
            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"IsInviteActive"];
            
            [[AFAppAPIClient WSsharedClient] POST:API_REGISTER_FOR_PUSH
                                       parameters:dict
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              
                                              [hud hide:YES];
                                              
                                              NSDictionary *dict_res=(NSDictionary *)responseObject;
                                              
                                              NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                              if([isSuccessNumber boolValue] == YES)
                                              {
                                                  
                                                  NSArray *PushSettingID_Array=[dict_res objectForKey:DATA];
                                                  
                                                  if([PushSettingID_Array count ]>0){
                                                      
                                                      NSDictionary *PushSettingID_dict=[PushSettingID_Array objectAtIndex:0];
                                                      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                      
                                                      [userDefaults setObject:[PushSettingID_dict objectForKey:@"PushSettingID"] forKey:@"PushSettingID"];
                                                      
                                                      [userDefaults setValue:@"yes" forKey:@"set_invite"];
                                                      [userDefaults setValue:@"yes" forKey:@"set_follow"];
                                                      
                                                      [userDefaults synchronize];
                                                      
                                                  }else{
                                                      
                                                      
                                                  }
                                                  
                                              }
                                              
                                          }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [hud hide:YES];
                                              
                                          }];
            
        }
    }
    @catch (NSException *exception) {
        
    }
    
}


-(void)gotoMainPage{
    
    [self RegisterForPush];
    
    SlideBaseViewController *view = [[SlideBaseViewController alloc] initWithNibName:@"SlideBaseViewController" bundle:nil];
    
    [self.navigationController pushViewController:view animated:NO];
}



-(IBAction)hideKeyBoard:(id)sender{
    [UserName resignFirstResponder];
    [Password resignFirstResponder];
}

-(IBAction)loginClicked:(id)sender{
    
    // [self gotoMainPage];
    
    
    if(UserName.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter UserName"];
        return;
    }
    if(Password.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter Password"];
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    [UserName resignFirstResponder];
    [Password resignFirstResponder];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[UserName.text lowercaseString] forKey:@"UserName"];
    [dict setObject:[Utiles md5:Password.text] forKey:@"Password"];
    
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
                                        
                                        [userDefaults setObject:UserName.text forKey:@"UserName"];
                                        [userDefaults setObject:Password.text forKey:@"Password"];
                                        
                                        [userDefaults synchronize];
                                        
                                        
                                        [hud hide:YES];
                                        
                                        [self gotoMainPage];
                                        
                                    }else{
                                        [hud hide:YES];
                                        [Utiles showAlert:ERROR Message:[dict_res objectForKey: @"Message"]];
                                        
                                    }
                                    
                                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [hud hide:YES];
                                    [Utiles showAlert:ERROR Message:[error localizedDescription]];
                                    
                                }];
    
    
    
    
}

-(IBAction)gotoRegister:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [super.navigationController pushViewController:view animated:YES];
}

@end
