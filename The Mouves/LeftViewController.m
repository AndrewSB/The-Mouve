//
//  LeftViewController.m
//  MOUVE
//
//  Created by SANDY on 04/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "LeftViewController.h"
#import "SettingsViewController.h"
#import "InviteSecondViewController.h"
#import "LoginViewController.h"


@interface LeftViewController ()

@end

@implementation LeftViewController
@synthesize noti_badge;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)goto_settings:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"leftMenuButtonClicked_Notification"
     object:@"settings"];
    
}

-(IBAction)goto_profile:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"leftMenuButtonClicked_Notification"
     object:@"profile"];
}

-(IBAction)goto_notification:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"leftMenuButtonClicked_Notification"
     object:@"notification"];
}

-(IBAction)goto_home:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"leftMenuButtonClicked_Notification"
     object:@"home"];
}


- (IBAction)goToSearch:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"leftMenuButtonClicked_Notification"
     object:@"search"];
    
}


-(IBAction)signout_app:(id)sender{
    UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Do you want to Logout" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No, Thanks",nil];
    warningAlert.tag=1;
    [warningAlert show];
}

-(IBAction)invite_friends:(id)sender{
   
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS to Invite!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];       
        
    }else{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"leftMenuButtonClicked_Notification"
     object:@"invite"];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==1) {
        if (buttonIndex==0) {
           
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"" forKey:@"UserName"];
            [userDefaults setObject:@"" forKey:@"Password"];
            
            [userDefaults synchronize];
          //  exit(0);
            
                    
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"leftMenuButtonClicked_Notification"
             object:@"logout"];
        }
    }
}


-(void)updateNotificationCount:(int) count{
    
    if(noti_badge){
        [noti_badge removeFromSuperview];
    }
    
    if(count>0){
        
    noti_badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d",count]
                                    withStringColor:[UIColor whiteColor]
                                     withInsetColor:[UIColor orangeColor]
                                     withBadgeFrame:NO
                                withBadgeFrameColor:[UIColor clearColor]
                                          withScale:1.0
                                        withShining:NO];
    noti_badge.frame=CGRectMake(btn_notification.frame.origin.x+25, btn_notification.frame.origin.y+20,  noti_badge.frame.size.width, noti_badge.frame.size.height);
    
    [self.view addSubview:noti_badge];
    }
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    

UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(dismissKeyboard)];

[self.view addGestureRecognizer:tap];
}


-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *notification= [defaults objectForKey:@"NotificationData"];
    
    int count=0;
    
    for (int i=0;i<[notification count]; i++) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[notification objectAtIndex:i]];
        NSString *status=[dict objectForKey:@"IsRead"];
        if([status isEqualToString:@"N"]){
            count=count+1;
        }
    }
    [self updateNotificationCount:count];
}

- (void) dismissKeyboard
{
    // add self
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
