//
//  MouveDetailsViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "MouveDetailsViewController.h"
#import "MouveProfileViewController.h"
#import "CreateMouveViewController.h"


@interface MouveDetailsViewController ()

@end

@implementation MouveDetailsViewController
@synthesize Mouve_Data,User_Data,isYouGoing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)gotoEditMouve:(id)sender{
    
    if([[Utiles getUserDataForKey:@"UserID"] isEqualToString:[NSString stringWithFormat:@"%@",[self.Mouve_Data objectForKey:@"UserID"]]]){
        CreateMouveViewController *view=[[CreateMouveViewController alloc] initWithNibName:@"CreateMouveViewController" bundle:nil];
        view.isEdit=TRUE;
        view.edit_mouve_dict=self.Mouve_Data;
        view.edit_UserList=self.User_Data;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        self.isYouGoing=!self.isYouGoing;
                
        if( self.isYouGoing){
            [btn_edit setBackgroundImage:[UIImage imageNamed:@"footer_green"] forState:UIControlStateNormal];
            [btn_edit setTitle: @"Going" forState: UIControlStateNormal];
            
        }else{
            [btn_edit setBackgroundImage:[UIImage imageNamed:@"footer"] forState:UIControlStateNormal];
            [btn_edit setTitle: @"Make The Mouve" forState: UIControlStateNormal];
        }
        
        [self call_WS_Going];
    }
}


-(IBAction)gotoFB:(id)sender{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [tweetSheet setInitialText:@"Wallpost from my own MOUVE app! :)"];
        [tweetSheet addImage:[UIImage imageNamed:@"Login-Screen_logo.png"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        
        [Utiles showAlert:@"Sorry" Message:@"You can't send a wallpost right now, make sure your device has an internet connection and you have at least one Facebook account setup"];
    }
}

-(IBAction)gotoTW:(id)sender{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Tweeting from my own MOUVE app! :)"];
        [tweetSheet addImage:[UIImage imageNamed:@"Login-Screen_logo.png"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        [Utiles showAlert:@"Sorry" Message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"];
        
    }
}


-(IBAction)playVideo:(id)sender{
    @try {
        
        [self.view addSubview:[mp view]];
        [mp.moviePlayer play];
        [self.view bringSubviewToFront:mp.view];
        
    }
    @catch (NSException *exception) {
        
    }
    
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    //MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:mp];
    
    [mp.view removeFromSuperview];
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [self setDefaultData];
    [self getMouveDetails];
}


-(IBAction)showProfile:(id)sender{
    
    if([self.Mouve_Data objectForKey:@"UserID"]){
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        
        MouveProfileViewController *view=[[MouveProfileViewController alloc] initWithNibName:@"MouveProfileViewController" bundle:nil];
        
        [dict setObject:[self.Mouve_Data objectForKey:@"UserID"] forKey:@"UserID"];
        [dict setObject:[self.Mouve_Data objectForKey:@"UsersPhoto"] forKey:@"UsersPhoto"];
        view.UserData=[dict copy];
        
        if([[Utiles getUserDataForKey:@"UserID"] isEqualToString:[NSString stringWithFormat:@"%@",[self.Mouve_Data objectForKey:@"UserID"]]]){
            view.isFrom=@"self";
        }
        [self.navigationController pushViewController:view animated:YES];
    }else{
        [Utiles showAlert:APP_NAME Message:@"User Data missing."];
    }
}

-(void) setDefaultData{
    
    lbl_going_Switch.hidden=TRUE;
    bnt_going.hidden=TRUE;
    btn_edit.hidden=FALSE;
    
    if([[Utiles getUserDataForKey:@"UserID"] isEqualToString:[NSString stringWithFormat:@"%@",[self.Mouve_Data objectForKey:@"UserID"]]]){
        [btn_edit setTitle: @"Edit The Mouve" forState: UIControlStateNormal];
    }else{
        
        if( self.isYouGoing){
            [btn_edit setBackgroundImage:[UIImage imageNamed:@"footer_green"] forState:UIControlStateNormal];
             [btn_edit setTitle: @"Going" forState: UIControlStateNormal];
        }else{
        [btn_edit setBackgroundImage:[UIImage imageNamed:@"footer"] forState:UIControlStateNormal];
         [btn_edit setTitle: @"Make The Mouve" forState: UIControlStateNormal];
        }
       
    }
    
    lbl_name.text=[self.Mouve_Data objectForKey:@"Name"];
    lbl_address.text=[self.Mouve_Data objectForKey:@"Location"];
    if([self.Mouve_Data objectForKey:@"StartTime"]){
        lbl_time.text=[NSString stringWithFormat:@"%@ - %@",[self.Mouve_Data objectForKey:@"StartTime"],[self.Mouve_Data objectForKey:@"EndTime"]];
    }else{
        lbl_time.text=@"";
    }
    
    int going_count=[[self.Mouve_Data objectForKey:@"Going"] intValue];
    if(going_count>0){
        lbl_going.text=[NSString stringWithFormat:@"%@ People Going",[self.Mouve_Data  objectForKey:@"Going"]];
    }else{
        lbl_going.text=@"0 People Going";
    }
    
    lbl_info.text=[self.Mouve_Data objectForKey:@"Info"];
    
    NSString *relativeURL=[self.Mouve_Data objectForKey:@"MouvesPhoto"];
    if (relativeURL!= (id)[NSNull null] && relativeURL.length>0) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:MOUVE_PHOTO_URL,relativeURL]];
        [mouve_image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hdrbg"]];
    }
    
    NSString *relativeURL1=[self.Mouve_Data objectForKey:@"UsersPhoto"];
    if (relativeURL1!= (id)[NSNull null] && relativeURL1.length>0) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:USER_PHOTO_URL,relativeURL1]];
        
        [user_image.layer setCornerRadius:(user_image.frame.size.width)/2];
        [user_image.layer setBorderWidth:1];
        [user_image.layer setBorderColor:[UIColor whiteColor].CGColor];
        [user_image.layer setMasksToBounds:YES];
        
        [user_image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"]];
    }
    
    
    btn_video.hidden=TRUE;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    btn_video.hidden=TRUE;
    self.isYouGoing=FALSE;
    bnt_going.on=FALSE;
   
}


-(void) setData{
    
    lbl_name.text=[self.Mouve_Data objectForKey:@"Name"];
    lbl_address.text=[self.Mouve_Data objectForKey:@"Location"];
    lbl_time.text=[NSString stringWithFormat:@"%@ - %@",[self.Mouve_Data objectForKey:@"StartTime"],[self.Mouve_Data objectForKey:@"EndTime"]];
    
    bnt_going.on=FALSE;
    
    int IsGoing=[[self.Mouve_Data objectForKey:@"IsGoing"] intValue];
    
    if(IsGoing==1){
        bnt_going.on=TRUE;
    }
    
    int going_count=[[self.Mouve_Data objectForKey:@"Going"] intValue];
    if(going_count>0){
        lbl_going.text=[NSString stringWithFormat:@"%@ People Going",[self.Mouve_Data  objectForKey:@"Going"]];
    }else{
        lbl_going.text=@"0 People Going";
    }
    
    lbl_info.text=[self.Mouve_Data objectForKey:@"Info"];
    
    
    NSString *relativeURL=[self.Mouve_Data objectForKey:@"MouvesPhoto"];
    if ( relativeURL!= (id)[NSNull null] && relativeURL.length>0) {
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:MOUVE_PHOTO_URL,relativeURL]];
        [mouve_image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hdrbg"]];
        //[mouve_image setClipsToBounds:YES];
    }
    
    NSString *relativeURL1=[self.Mouve_Data objectForKey:@"UsersPhoto"];
    if (relativeURL1!= (id)[NSNull null] && relativeURL1.length>0) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:USER_PHOTO_URL,relativeURL1]];
        
        [user_image.layer setCornerRadius:(user_image.frame.size.width)/2];
        [user_image.layer setBorderWidth:1];
        [user_image.layer setBorderColor:[UIColor whiteColor].CGColor];
        [user_image.layer setMasksToBounds:YES];
        [user_image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"]];
    }
    
    @try {
        
        NSString *videoName=[self.Mouve_Data objectForKey:@"Video"];
        
        if(videoName.length>0){
            
            btn_video.hidden=FALSE;
            
            NSURL *mediaURL = [NSURL URLWithString:[NSString stringWithFormat:API_VIDEO_PLAY,videoName]];
            
            mp = [[MPMoviePlayerViewController alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlayBackDidFinish:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:nil];
            [mp.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
            [mp.moviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
            [mp.moviePlayer setContentURL:mediaURL];
            [mp.moviePlayer setFullscreen:YES];
            [mp.moviePlayer prepareToPlay];
            
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

-(void)getMouveDetails{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[self.Mouve_Data objectForKey:@"MouvesID"] forKey:@"MouvesID"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppAPIClient WSsharedClient] POST:API_MOUVE_DETAILS
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      
                                      if(result){
                                          NSLog(@"Mouve Details:%@",[responseObject objectForKey:@"Data"]);
                                          self.User_Data=[[NSMutableArray alloc] init];
                                          
                                          NSArray *Data=(NSArray *)[responseObject objectForKey:@"Data"];
                                          
                                          self.User_Data=(NSMutableArray *)[responseObject objectForKey:@"UserData"];
                                          
                                          if([Data count]>0){
                                              self.Mouve_Data= (NSDictionary *)[Data objectAtIndex:0];
                                              [self setData];
                                          }
                                          
                                          if([self.User_Data count]>0){
                                              [self showInvitess];
                                          }
                                      }
                                      
                                      [hud hide:YES];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [hud hide:YES];
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
}


-(IBAction)isGoingChanged:(id)sender
{
    if(bnt_going.on){
        self.isYouGoing=TRUE;
        [self call_WS_Going];
    }else{
        self.isYouGoing=FALSE;
        [self call_WS_Going];
    }
    
}


-(void)call_WS_Going{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    
    [dict setObject:[self.Mouve_Data objectForKey:@"MouvesID"] forKey:@"MouvesID"];
    [dict setObject:[NSNumber numberWithBool:self.isYouGoing] forKey:@"IsGoing"];
    
    [[AFAppAPIClient WSsharedClient] POST:API_GOING_MOUVES
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      [hud hide:YES];
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      
                                      if(result){
                                          
                                          if(self.isYouGoing){
                                              
                                              NSMutableArray *All_user_dict=[[NSMutableArray alloc] init];
                                              All_user_dict=[self.User_Data mutableCopy];
                                              for (int i=0; i<[All_user_dict count]; i++) {
                                                  NSDictionary *dict=[self.User_Data objectAtIndex:i];
                                                  if([[Utiles getUserDataForKey:@"UserID"] isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"UserID"]]]){
                                                      [All_user_dict removeObjectAtIndex:i];
                                                      break;
                                                  }
                                              }
                                              
                                              NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                                              [dict setObject:[Utiles getUserDataForKey:@"UserID"] forKey:@"UserID"];
                                              [dict setObject:[NSString stringWithFormat:@"%@.jpeg",[Utiles getUserDataForKey:@"UserID"]] forKey:@"UsersPhoto"];
                                              [All_user_dict addObject:dict];
                                              
                                              self.User_Data =[All_user_dict mutableCopy];
                                          }else{
                                              NSMutableArray *All_user_dict=[[NSMutableArray alloc] init];
                                              All_user_dict=[self.User_Data mutableCopy];
                                              for (int i=0; i<[All_user_dict count]; i++) {
                                                  NSDictionary *dict=[self.User_Data objectAtIndex:i];
                                                  if([[Utiles getUserDataForKey:@"UserID"] isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"UserID"]]]){
                                                      [All_user_dict removeObjectAtIndex:i];
                                                      break;
                                                  }
                                              }
                                              self.User_Data =[All_user_dict mutableCopy];
                                          }
                                          [self showInvitess];
                                      }else{
                                          self.isYouGoing=!self.isYouGoing;
                                      }
                                      
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [hud hide:YES];
                                      
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
}

-(void) showInvitess{
    
    int count=[self.User_Data count];
    invitessScroll.contentSize = CGSizeMake(count *65 , 60);
    
    NSArray *subViews=invitessScroll.subviews;
    for (int i=0; i<[subViews count]; i++) {
        [[subViews objectAtIndex:i] removeFromSuperview];
    }
    
    for (int i=0; i<count; i++) {
        NSDictionary *dict=[self.User_Data objectAtIndex:i];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_img.png"]];
        imgView.frame = CGRectMake(i*65, 0, 60, 60);
        
        [imgView.layer setCornerRadius:(imgView.frame.size.width)/2];
        [imgView.layer setBorderWidth:1];
        [imgView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [imgView.layer setMasksToBounds:YES];
        
        
        NSString *relativeURL=[dict objectForKey:@"UsersPhoto"];
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:USER_PHOTO_URL,relativeURL]];
        [imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"]];
        
        if([[Utiles getUserDataForKey:@"UserID"] isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"UserID"]]]){
            self.isYouGoing=TRUE;
            bnt_going.on=TRUE;
        }
        
        [invitessScroll addSubview:imgView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(aMethod:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"" forState:UIControlStateNormal];
        button.frame = CGRectMake(i*65, 0, 60, 60);
        button.tag=i;
        [invitessScroll addSubview:button];
        
    }
    
    
    if(count>0){
        lbl_going.text=[NSString stringWithFormat:@"%d People Going",count];
    }else{
        lbl_going.text=@"0 People Going";
    }
    
    
    if( self.isYouGoing){
        [btn_edit setBackgroundImage:[UIImage imageNamed:@"footer_green"] forState:UIControlStateNormal];
        [btn_edit setTitle: @"Going" forState: UIControlStateNormal];
        
    }else{
        [btn_edit setBackgroundImage:[UIImage imageNamed:@"footer"] forState:UIControlStateNormal];
         [btn_edit setTitle: @"Make The Mouve" forState: UIControlStateNormal];
    }
   
    
}

-(IBAction)aMethod:(id)sender{
    int tag=(int)[sender tag];
    NSLog(@"Tag:%d",tag);
    
    MouveProfileViewController *view=[[MouveProfileViewController alloc] initWithNibName:@"MouveProfileViewController" bundle:nil];
    NSDictionary *dict=[self.User_Data objectAtIndex:tag];
    view.UserData=dict;
    
    if([[Utiles getUserDataForKey:@"UserID"] isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"UserID"]]]){
        view.isFrom=@"self";
    }
    
    [self.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
