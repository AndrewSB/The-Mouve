//
//  MainViewController.m
//  MOUVE
//
//  Created by SANDY on 04/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "MainViewController.h"
#import "EventTableViewCell.h"
#import "CreateMouveViewController.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "NotificationsViewController.h"
#import "InviteSecondViewController.h"
#import "MouveDetailsViewController.h"
#import "MouveProfileViewController.h"
#import "LocationHelper.h"
#import "LoginViewController.h"


@interface MainViewController ()

@end

static NSString *cellIdentifier1 = @"EventTableViewCell";
static NSString *cellIdentifier2 = @"EventTableViewCell";

@implementation MainViewController
@synthesize event_Array_Home,event_Array_Explore,menu_badge,isLocationFound;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self.revealController setRecognizesPanningOnFrontView:TRUE];
    
    [self.navigationController setNavigationBarHidden:YES];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    [self getHomeMouveList];
    [self getNotificationList];
    
    
    
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

     [self showNotificationCount:count];
}

- (void) LocationUpdateNotification:(NSNotification *) notification
{
   // NSString *addressString=(NSString *) notification.object;
    [[LocationHelper sharedLocationHelper] stopTrackingLocation];
    
    if(!self.isLocationFound){
        self.isLocationFound=TRUE;
    [self getExploreMouveList:[LocationHelper sharedLocationHelper].currentLocation.coordinate.latitude Longitude:[LocationHelper sharedLocationHelper].currentLocation.coordinate.longitude];
    }
  }

-(void)getNotificationList{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:@"1" forKey:@"IsRead"];
    [[AFAppAPIClient WSsharedClient] POST:API_GET_NOTIFICATIONS
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      if(result){
                                          NSArray *notification_array=[responseObject objectForKey:@"Data"];
                                          
                                          int count=0;
                                          
                                          NSMutableArray *localNoti=[[NSMutableArray alloc] init];
                                        
                                          for (int i=0;i<[notification_array count]; i++) {                                              
                                              NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[notification_array objectAtIndex:i]];
                                              int status=[[dict objectForKey:@"IsRead"] intValue];
                                              if(status==0){
                                                  [dict setObject:@"N" forKey:@"IsRead"];
                                                   count=count+1;
                                              }else{
                                                  [dict setObject:@"Y" forKey:@"IsRead"];
                                              }
                                              [localNoti addObject:dict];
                                          }
                                          
                                          notification_array=[localNoti copy];
                                          
                                         
                                          if([notification_array count]>0){
                                              
                                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                              [defaults setObject:notification_array forKey:@"NotificationData"];
                                              [defaults synchronize];
                                              [self showNotificationCount:count];
                                       
                                          }else{
                                             
                                          }
                                      }
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
}

-(void)showNotificationCount:(int)  count{
    
    if(menu_badge){
        [menu_badge removeFromSuperview];
    }
    
    if(count>0){
    
    menu_badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d",count]
                                    withStringColor:[UIColor whiteColor]
                                     withInsetColor:[UIColor orangeColor]
                                     withBadgeFrame:NO
                                withBadgeFrameColor:[UIColor clearColor]
                                          withScale:1.0
                                        withShining:NO];
    menu_badge.frame=CGRectMake(btn_menu.frame.origin.x+15, btn_menu.frame.origin.y-10,  menu_badge.frame.size.width, menu_badge.frame.size.height);
    
        [self.view addSubview:menu_badge];
    }
}

-(IBAction)menu_toggle:(id)sender{
    
    if (![self.revealController isPresentationModeActive])
    {
        [self.revealController enterPresentationModeAnimated:YES completion:nil];
    }
    else
    {
        [self.revealController resignPresentationModeEntirely:NO animated:YES completion:nil];
    }
}


-(void)getExploreMouveList:(double)lat Longitude:(double)lng{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithDouble:lat] forKey:@"Latitude"];
    [dict setObject:[NSNumber numberWithDouble:lng] forKey:@"Longitude"];
    [dict setObject:[Utiles getCurrentTime] forKey:@"MyDateTime"];
    
    
    [[AFAppAPIClient WSsharedClient] POST:API_EXPLORE_MOUVE
                             parameters:dict
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    self.isLocationFound=TRUE;
                                    
                                    BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                    
                                    self.event_Array_Explore=[[NSMutableArray alloc] init];
                                    
                                    if(result){
                                        self.event_Array_Explore=[responseObject objectForKey:@"Data"];
                                        if([self.event_Array_Explore count]>0){
                                            lbl_error.hidden=TRUE;
                                            event_Table_2.hidden=FALSE;
                                        }else{
                                           lbl_error.hidden=FALSE;
                                        }
                                    }
                                    [event_Table_2 reloadData];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                    [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                    
                                }];
    
}

-(void)getHomeMouveList{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[Utiles getUserDataForKey:@"UserID"] forKey:@"UserID"];
    [dict setObject:[Utiles getCurrentTime] forKey:@"MyDateTime"];
    
    [[AFAppAPIClient WSsharedClient] POST:API_HOME_MOUVE
                             parameters:dict
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                    
                                     self.event_Array_Home=[[NSMutableArray alloc] init];
                                    if(result){
                                        NSLog(@"Home Result:%@",[responseObject objectForKey:@"Data"]);
                                    self.event_Array_Home=[responseObject objectForKey:@"Data"];
                                        if([self.event_Array_Home count]>0){
                                            event_Table_1.hidden=FALSE;
                                            lbl_error.hidden=TRUE;
                                        }else{
                                        lbl_error.hidden=FALSE;
                                        }
                                    }
                                    [event_Table_1 reloadData];
     
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                       [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                    
                                }];
    
}

-(IBAction)create_Mouve:(id)sender{
    CreateMouveViewController *view=[[CreateMouveViewController alloc] initWithNibName:@"CreateMouveViewController" bundle:nil];
    view.isEdit=FALSE;
    [self.navigationController pushViewController:view animated:YES];
}

- (void) leftMenuButtonClicked_Notification:(NSNotification *) notification
{
     [self.revealController resignPresentationModeEntirely:YES animated:YES completion:nil];
    
     NSString *btn_name=(NSString *) notification.object;
    
    
    if([btn_name isEqualToString:@"home"]){
        
        [super.navigationController popToRootViewControllerAnimated:NO];
        
    }else if([btn_name isEqualToString:@"settings"]){
    SettingsViewController *view=[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        [super.navigationController pushViewController:view animated:YES];
    }else if([btn_name isEqualToString:@"profile"]){
        
        /*
        ProfileViewController *view=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        [super.navigationController pushViewController:view animated:YES];
         */
        MouveProfileViewController *view=[[MouveProfileViewController alloc] initWithNibName:@"MouveProfileViewController" bundle:nil];
        view.isFrom=@"self";
        [super.navigationController pushViewController:view animated:YES];
        
    }else if([btn_name isEqualToString:@"notification"]){
        NotificationsViewController *view=[[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
        [super.navigationController pushViewController:view animated:YES];
        
    }else if([btn_name isEqualToString:@"invite"]){
        
        
        
        if([[ContactsDAO sharedContactsDAO] getAccessPermission]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InviteSecondViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"InviteSecondViewController"];
            view.isFrom=@"FromLeft";
            [super.navigationController pushViewController:view animated:YES];
            
        }else{
            [Utiles showAlert:@"Error" Message:@"You denied Address book access permission. You must enable it from device settings."];
        }
        
    }else if([btn_name isEqualToString:@"logout"]){
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginViewController *controller = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
        [super.navigationController pushViewController:controller animated:YES];
        
    }else{
    
        SearchListViewController *view=[[SearchListViewController alloc] initWithNibName:@"SearchListViewController" bundle:nil];
        view.SearchKey=@"";
        [super.navigationController pushViewController:view animated:YES];
    }
    
}

-(IBAction)segmentChnaged:(id)sender{

    if(seg.selectedSegmentIndex==0){
        lbl_title.text=@"Home";
    }else{
        lbl_title.text=@"Explore";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    event_Table_2.hidden=TRUE;
    event_Table_1.hidden=TRUE;
    lbl_error.hidden=FALSE;
    
    theScrollView.contentSize = CGSizeMake(320*2, theScrollView.frame.size.height);
    theScrollView.pagingEnabled = YES;
    
    seg.selectedSegmentIndex=0;
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LocationUpdateNotification:)
                                                 name:@"LocationUpdateNotification"
                                               object:nil];
    
    [[LocationHelper sharedLocationHelper] startTrackingLoocation];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leftMenuButtonClicked_Notification:)
                                                 name:@"leftMenuButtonClicked_Notification"
                                               object:nil];
    
    
    [event_Table_1 registerNib:[UINib nibWithNibName:@"EventTableViewCell"
                                            bundle:[NSBundle mainBundle]]
      forCellReuseIdentifier:cellIdentifier1];
    
    [event_Table_2 registerNib:[UINib nibWithNibName:@"EventTableViewCell"
                                              bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:cellIdentifier2];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(menu_toggle:)];
    [menu_badge addGestureRecognizer:singleFingerTap];
    
   
    
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float x = scrollView.contentOffset.x;
    
    if (x > 320/2 && x < 640/2) {
         lbl_title.text = @"Explore";
        img1.image=[UIImage imageNamed:@"un_selected_circle.png"];
        img2.image=[UIImage imageNamed:@"selected_circle.png"];
        if([self.event_Array_Explore count]>0){
            lbl_error.hidden=TRUE;
        }else{
            lbl_error.hidden=FALSE;
        }
    }
    
    if (x > 0 && x < 320/2) {
        lbl_title.text= @"Home";
        img2.image=[UIImage imageNamed:@"un_selected_circle.png"];
        img1.image=[UIImage imageNamed:@"selected_circle.png"];
        
        if([self.event_Array_Home count]>0){
           lbl_error.hidden=TRUE;
        }else{
          lbl_error.hidden=FALSE;
        }
    }
}


#pragma mark - Table View Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    //
    if (tableView.tag == 100) {
        return [event_Array_Home count];
        
    }
    if (tableView.tag == 101) {
        return [event_Array_Explore count];
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    if (tableView.tag == 100) {
        EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        NSDictionary *obj= [self.event_Array_Home objectAtIndex:indexPath.row];
        [cell setData:obj];
         return cell;
    }
    if (tableView.tag == 101) {
        EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        
         NSDictionary *obj= [self.event_Array_Explore objectAtIndex:indexPath.row];
        [cell setData:obj];
         return cell;
    }
     return nil;
   
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
    //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //  NSLog(@"Section:%d Row:%d selected and its data is %@",
    //       indexPath.section,indexPath.row,cell.textLabel.text);
    
    
    
    if (tableView.tag == 100) {
        MouveDetailsViewController *view=[[MouveDetailsViewController alloc] initWithNibName:@"MouveDetailsViewController" bundle:nil];
        view.Mouve_Data=[self.event_Array_Home objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:view animated:YES];
        
        
    }
    if (tableView.tag == 101) {
        MouveDetailsViewController *view=[[MouveDetailsViewController alloc] initWithNibName:@"MouveDetailsViewController" bundle:nil];
        view.Mouve_Data=[self.event_Array_Explore objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:view animated:YES];
        
        
    }
    
    
    
}


- (UILabel *)_simpleLabelWithFrame: (CGRect)frame andText: (NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:28.];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
