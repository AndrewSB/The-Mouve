//
//  MouveDetailsViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "MouveProfileViewController.h"
#import "ProfileViewController.h"

@interface MouveProfileViewController ()

@end

static NSString *cellIdentifier1 = @"EventTableViewCell";

@implementation MouveProfileViewController
@synthesize isFrom,UserData,event_Array_Home,IsFollowing;

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
    [self.navigationController setNavigationBarHidden:YES];
    
}


-(IBAction)following:(id)sender{
    FollowViewController *view=[[FollowViewController alloc] initWithNibName:@"FollowViewController" bundle:nil];
    view.UserData=self.UserData;
    view.isListOf=API_FOLLOWING_LIST;
    [self.navigationController pushViewController:view animated:YES];
    
}

-(IBAction)follower:(id)sender{
    FollowViewController *view=[[FollowViewController alloc] initWithNibName:@"FollowViewController" bundle:nil];
    view.UserData=self.UserData;
    view.isListOf=API_FOLLOWER_LIST;
    [self.navigationController pushViewController:view animated:YES];
    
}

-(IBAction)gotoProfileEdit:(id)sender{
    if([isFrom isEqualToString:@"self"]){
        ProfileViewController *view=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        [self.navigationController pushViewController:view animated:YES];
    }else{
        
        [self follow:0];
    }
   
}


-(void) setSmallBorder:(int)width{
    [user_image.layer setCornerRadius:(user_image.frame.size.width)/2];
    [user_image.layer setBorderWidth:0];
    [user_image.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [user_image.layer setMasksToBounds:YES];
   
}

-(void)getFollow:(NSString *)UserID Type:(NSString *)type{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:UserID forKey:@"UserID"];
    
    
    if([type isEqualToString:@"Yes"]){
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"IsFollow"];
    }else{
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"IsFollow"];
    }
    
    [[AFAppAPIClient WSsharedClient] POST:API_FOLLOW_USER
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      [hud hide:YES];
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      
                                      if(result){
                                          
                                          if(self.IsFollowing){
                                              self.IsFollowing=FALSE;
                                              
                                              NSMutableDictionary *user_Data=[[NSMutableDictionary alloc] initWithDictionary:self.UserData];
                                              
                                              [user_Data setValue:[NSNumber numberWithBool:FALSE] forKey:@"IsFollowing"];
                                              self.UserData=[user_Data copy];
                                               [Utiles showAlert:APP_NAME Message:@"User Unfollow Successfully."];
                                              
                                          }else{
                                              self.IsFollowing=TRUE;
                                                NSMutableDictionary *user_Data=[[NSMutableDictionary alloc] initWithDictionary:self.UserData];
                                              
                                              [user_Data setValue:[NSNumber numberWithBool:TRUE] forKey:@"IsFollowing"];
                                              [Utiles showAlert:APP_NAME Message:@"User follow Successfully."];
                                              self.UserData=[user_Data copy];
                                          }
                                      
                                          [self setUserData];
                                      }
                                      
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [hud hide:YES];
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
    
}



-(IBAction)follow:(id)sender{
    if(![isFrom isEqualToString:@"self"]){
    if(self.IsFollowing){
            [self getFollow:[self.UserData objectForKey:@"UserID"] Type:@"No"];
    }else{
            [self getFollow:[self.UserData objectForKey:@"UserID"] Type:@"Yes"];
    }
    }
}



-(void)setUserData{
    if([self.UserData objectForKey:@"Name"]){
         lbl_name.text=[self.UserData objectForKey:@"Name"];
    }else{
        lbl_name.text=@"";
    }
    
    if([self.UserData objectForKey:@"UserName"]){
        lbl_UserName.text=[NSString stringWithFormat:@"@%@",[self.UserData objectForKey:@"UserName"]];
    }else{
        lbl_UserName.text=@"";
    }
    
    if([self.UserData objectForKey:@"Followers"]){
        lbl_follower.text=[NSString stringWithFormat:@"%@",[self.UserData objectForKey:@"Followers"]];
    }
    if([self.UserData objectForKey:@"Followings"]){
     lbl_following.text=[NSString stringWithFormat:@"%@",[self.UserData objectForKey:@"Followings"]];
    }
    
    if(![isFrom isEqualToString:@"self"]){
    if([self.UserData objectForKey:@"IsFollowing"]){
        if([[self.UserData objectForKey:@"IsFollowing"] boolValue]){
            [btn_profile setTitle: @"Following" forState: UIControlStateNormal];
            self.IsFollowing=TRUE;
        }else{
            self.IsFollowing=FALSE;
         [btn_profile setTitle: @"Follow" forState: UIControlStateNormal];
        }
    }
    }
    if([self.UserData objectForKey:@"UsersPhoto"]){
    NSString *relativeURL=[self.UserData objectForKey:@"UsersPhoto"];
    
    if(relativeURL!= (id)[NSNull null] && relativeURL.length>0){
                 
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:USER_PHOTO_URL,relativeURL]];
        
    
     [user_image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"man.png"]];
     [back_image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"setting_txtbox.png"]];
        
      back_image.contentMode = UIViewContentModeScaleAspectFill;
      [back_image setClipsToBounds:YES];
    }
    }
}

-(void)getUserDetails:(NSString *)UserID{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:UserID forKey:@"UserID"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [[AFAppAPIClient WSsharedClient] POST:API_USER_DETAILS
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      
                                      if(result){
                                        
                                          
                                          NSArray *userData=[responseObject objectForKey:@"Data"];
                                          
                                           NSArray *MouveData=[responseObject objectForKey:@"MouveData"];
                                          if([userData count]>0){
                                              self.UserData=[userData objectAtIndex:0];
                                              [self setUserData];
                                          }
                                          
                                          if([MouveData count]>0){
                                              
                                            self.event_Array_Home =[[NSMutableArray alloc] init];
                                              
                                              for (int i=0; i<[MouveData count];i++ ) {
                                                  NSMutableDictionary *_dict=[[NSMutableDictionary alloc] initWithDictionary:[MouveData objectAtIndex:i]];
                                                  
                                                  [_dict setObject:[self.UserData objectForKey:@"UsersPhoto"] forKey:@"UsersPhoto"];
                                                  
                                                  [_dict setObject:[self.UserData objectForKey:@"UserID"] forKey:@"UserID"];
                                                  [self.event_Array_Home addObject:_dict];
                                              }
                                              
                                              
                                              if([self.event_Array_Home count]>0){
                                                  tbl_mouves.hidden=FALSE;                                                 
                                              }
                                          }
                                           [tbl_mouves reloadData];
                                      }
                                      
                                       [hud hide:YES];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [hud hide:YES];
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.IsFollowing=FALSE;
    
    tbl_mouves.hidden=TRUE;
    
    [tbl_mouves registerNib:[UINib nibWithNibName:@"EventTableViewCell"
                                              bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:cellIdentifier1];
    
    [self setSmallBorder:1];
    
    [self setUserData];
    
    if([isFrom isEqualToString:@"self"]){
        self.UserData=[Utiles getUser];
        [self getUserDetails:[Utiles getUserDataForKey:@"UserID"]];
         [btn_profile setTitle: @"Edit" forState: UIControlStateNormal];
    }else{
        [self getUserDetails:[UserData objectForKey:@"UserID"]];
    }

 
}


#pragma mark - Table View Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [self.event_Array_Home count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
        EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        NSDictionary *obj= [self.event_Array_Home objectAtIndex:indexPath.row];
        [cell setProfileMouveData:obj];
        return cell;
    
}

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
}



#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
        MouveDetailsViewController *view=[[MouveDetailsViewController alloc] initWithNibName:@"MouveDetailsViewController" bundle:nil];
        view.Mouve_Data=[self.event_Array_Home objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:view animated:YES];
        
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
