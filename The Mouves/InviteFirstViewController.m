//
//  InviteFirstViewController.m
//  MOUVE
//
//  Created by SANDY on 01/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "InviteFirstViewController.h"
#import "InviteSecondViewController.h"

@interface InviteFirstViewController ()

@end

@implementation InviteFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}


-(IBAction)skipButton:(id)sender{
    
    SlideBaseViewController *view = [[SlideBaseViewController alloc] initWithNibName:@"SlideBaseViewController" bundle:nil];
    
    [self.navigationController pushViewController:view animated:NO];
    
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
            [dict setObject:[[UIDevice currentDevice] model] forKey:@"Device_Model"];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self RegisterForPush];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)gotoNext:(id)sender{
    
    if(![MFMessageComposeViewController canSendText]) {
        [Utiles showAlert:@"Error" Message:@"Your device doesn't support SMS to Invite!"];
    }else{
        
        if([[ContactsDAO sharedContactsDAO] getAccessPermission]){            
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InviteSecondViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"InviteSecondViewController"];
        view.isFrom=@"firstScreen";
            [self.navigationController pushViewController:view animated:YES];
        }else{
        [Utiles showAlert:@"Error" Message:@"You denied Address book access permission. You must enable it from device settings."];
        }
    }
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
