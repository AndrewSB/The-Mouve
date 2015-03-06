//
//  SettingsViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/12/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.title=@"Settings";    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSString *set_follow= [[NSUserDefaults standardUserDefaults] stringForKey:@"set_follow"];
    
    if([set_follow isEqualToString:@"yes"]){
        follow.on=TRUE;
    }else{
        follow.on=FALSE;
    }    
    
    NSString *set_invite= [[NSUserDefaults standardUserDefaults] stringForKey:@"set_invite"];
    
    if([set_invite isEqualToString:@"yes"]){
        invite.on=TRUE;
    }else{
        invite.on=FALSE;
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)btn_follow:(id)sender{
    
    if(follow.on){
        [self followerONOFF:YES];
    }else{
        [self followerONOFF:NO];
    }

}

-(IBAction)btn_invite:(id)sender{
    if(invite.on){
        [self inviteONOFF:YES];
    }else{
        [self inviteONOFF:NO];
    }
    
}


-(IBAction)signout_app:(id)sender{
    UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Do you want to Logout" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No, Thanks",nil];
    warningAlert.tag=1;
    [warningAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (buttonIndex==0) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];            
            [userDefaults setObject:@"" forKey:@"UserName"];
            [userDefaults setObject:@"" forKey:@"Password"];
            
            [userDefaults synchronize];
            
            
            NSArray* tempVCA = [self.navigationController viewControllers];
            
            for(UIViewController *tempVC in tempVCA)
            {
               
                [tempVC removeFromParentViewController];
                
            }
        
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            LoginViewController *controller = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
    }
}


-(void) inviteONOFF:(BOOL) flag{
    
    @try {
        
         NSString *PushSettingID= [[NSUserDefaults standardUserDefaults] stringForKey:@"PushSettingID"];
        if(PushSettingID.length>0){
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            [dict setObject:PushSettingID forKey:@"PushSettingID"];
            [dict setObject:[NSNumber numberWithBool:flag] forKey:@"IsInviteActive"];
            
            [[AFAppAPIClient WSsharedClient] POST:API_INVITE_PUSH
                                       parameters:dict
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             
                                              NSDictionary *dict_res=(NSDictionary *)responseObject;
                                              
                                              NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                              if([isSuccessNumber boolValue] == YES)
                                              {
                                              if(flag){
                                                  invite.on=TRUE;
                                                 [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"set_invite"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                  
                                              }else{
                                                  [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"set_invite"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];                                                                                               invite.on=FALSE;
                                              }
                                              }else{
                                                  if(!flag){
                                                      invite.on=FALSE;
                                                  }else{
                                                      invite.on=TRUE;
                                                  }
                                              }
                                              
                                          }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              if(!flag){
                                                  invite.on=FALSE;
                                              }else{
                                                  invite.on=TRUE;
                                              }
                                          }];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    
}

-(void) followerONOFF:(BOOL) flag{
    
    @try {
        
        NSString *PushSettingID= [[NSUserDefaults standardUserDefaults] stringForKey:@"PushSettingID"];
        
        if(PushSettingID.length>0){
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setObject:PushSettingID forKey:@"PushSettingID"];
        [dict setObject:[NSNumber numberWithBool:flag] forKey:@"IsFollowerActive"];
        
        [[AFAppAPIClient WSsharedClient] POST:API_FOLLOWER_PUSH
                                   parameters:dict
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          
                                          NSDictionary *dict_res=(NSDictionary *)responseObject;
                                          
                                          NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                          if([isSuccessNumber boolValue] == YES)
                                          {

                                          if(flag){
                                              follow.on=TRUE;
                                                 [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"set_follow"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                              
                                              }else{
                                                  [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"set_follow"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                   follow.on=FALSE;
                                              }

                                          
                                          }else{
                                              if(!flag){
                                                  follow.on=FALSE;
                                              }else{
                                                  follow.on=TRUE;
                                              }
                                          }
                                          
                                      }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          if(!flag){
                                              follow.on=FALSE;
                                          }else{
                                              follow.on=TRUE;
                                          }
                                      }];
        
        }
    }
    @catch (NSException *exception) {
        
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
