//
//  NotificationsViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/12/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "NotificationsViewController.h"
#import "MouveProfileViewController.h"


@interface NotificationsViewController ()

@end


static NSString *cellIdentifier = @"NotificationTableViewCell";

@implementation NotificationsViewController
@synthesize selected_notification,notification_array;


-(void)viewWillAppear:(BOOL)animated{
    self.title=@"Notifications";
    [self.navigationController setNavigationBarHidden:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.notification_array=  [defaults valueForKey:@"NotificationData"];
    if([self.notification_array count]>0){
        Notification_Table.hidden=FALSE;
        lbl_message.hidden=TRUE;
    }else{
        Notification_Table.hidden=TRUE;
        lbl_message.hidden=FALSE;
    }
    
    [Notification_Table reloadData];
    
    [self getNotificationList];
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Notification_Table.hidden=TRUE;
    lbl_message.hidden=FALSE;
    
    self.notification_array=[[NSMutableArray alloc] init];
    
    [Notification_Table registerNib:[UINib nibWithNibName:@"NotificationTableViewCell"
                                            bundle:[NSBundle mainBundle]]
      forCellReuseIdentifier:cellIdentifier];
    
   
}



-(void)getNotificationList{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"GetAll"];
    [[AFAppAPIClient WSsharedClient] POST:API_GET_NOTIFICATIONS
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];                                      
                                      if(result){
                                                                                    
                                           self.notification_array=[[responseObject objectForKey:@"Data"] mutableCopy];
                                          if([self.notification_array count]>0){
                                              
                                              NSMutableArray *localNoti=[[NSMutableArray alloc] init];
                                              
                                              for (int i=0;i<[self.notification_array count]; i++) {
                                                  
                                                  NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[self.notification_array objectAtIndex:i]];
                                                  int status=[[dict objectForKey:@"IsRead"] intValue];
                                                  if(status==0){
                                                      [dict setObject:@"N" forKey:@"IsRead"];
                                                  }else{
                                                      [dict setObject:@"Y" forKey:@"IsRead"];
                                                  }
                                                  [localNoti addObject:dict];
                                              }
                                              
                                              self.notification_array=[localNoti copy];
                                              
                                             
                                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                              [defaults setObject:self.notification_array forKey:@"NotificationData"];
                                              [defaults synchronize];
                                              
                                              
                                              Notification_Table.hidden=FALSE;
                                              lbl_message.hidden=TRUE;
                                               [Notification_Table reloadData];
                                          }else{
                                              Notification_Table.hidden=TRUE;
                                              lbl_message.hidden=FALSE;
                                          }
                                      }                                     
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
}



#pragma mark - Table View Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return [self.notification_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
        
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];    
    
    cell.backgroundColor=[UIColor clearColor];
    NSDictionary *obj= [self.notification_array objectAtIndex:indexPath.row];
    [cell setData:obj];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}



#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     self.selected_notification= [self.notification_array objectAtIndex:indexPath.row];
    
    [self readNotification];
    
    int type=[[self.selected_notification objectForKey:@"Type"] intValue];
    if(type==1){
    MouveProfileViewController *view=[[MouveProfileViewController alloc] initWithNibName:@"MouveProfileViewController" bundle:nil];
    view.UserData=self.selected_notification;
    [self.navigationController pushViewController:view animated:YES];
    }else{
        MouveDetailsViewController *view=[[MouveDetailsViewController alloc] initWithNibName:@"MouveDetailsViewController" bundle:nil];
        view.Mouve_Data=self.selected_notification;
        [self.navigationController pushViewController:view animated:YES];
        
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
       self.selected_notification= [self.notification_array objectAtIndex:indexPath.row];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are you sure you want to delete notification?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alertView.tag=100;
        [alertView show];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(IBAction)DeleteAllNotifications:(id)sender{
   
    [Notification_Table reloadData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
           
            [self deleteNotification];
        }
    }
    
    
}


-(void)deleteNotification{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:self.selected_notification];
    [[AFAppAPIClient WSsharedClient] POST:API_DELETE_NOTIFICATIONS
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      if(result){
                                          @try {
                                              
                                         
                                         
                                          [self.notification_array removeObject:self.selected_notification];
                                          }
                                          @catch (NSException *exception) {
                                              
                                          }
                                          [Utiles showAlert:APP_NAME Message:@"Notification deleted successfully"];
                                          }else{
                                              [Utiles showAlert:APP_NAME Message:@"Notification delete fails."];
                                          }
                                      [Notification_Table reloadData];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
}


-(void)readNotification{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:self.selected_notification];
    [[AFAppAPIClient WSsharedClient] POST:API_READ_NOTIFICATIONS
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                  }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end