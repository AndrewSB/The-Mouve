//
//  InviteListViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "InviteListViewController.h"
#import "ProfileViewController.h"
#import "MouveProfileViewController.h"

@interface InviteListViewController ()

@end


@implementation InviteListViewController
@synthesize isListOf,UserData,user_Array,delagate,MouveData,isEdit;

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
  //  [self.revealController setRecognizesPanningOnFrontView:TRUE];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if(self.isEdit){
        
     [btn_done setTitle: @"Save Changes" forState: UIControlStateNormal];
    }else{
        [btn_done setTitle: @"Create The Mouve" forState: UIControlStateNormal];
    }
    
    tbl_Users.hidden=TRUE;
   
    [self getUserList:[Utiles getUserDataForKey:@"UserID"]];   
    
}

-(IBAction)done_List:(id)sender{
    
    
    NSString *WSName=API_CREATE_MOUVE;
    
    if(self.isEdit){
        WSName=API_UPDATE_MOUVE;
    }
    
    if([[self getSelectedContacts] count]>0){
    
    NSString * userList=@"";
    
    for (int i=0; i<[self.user_Array count]; i++) {
        ContactsDAO *obj= [self.user_Array objectAtIndex:i];
        if(obj.isSelected){
              userList=[userList stringByAppendingString:[NSString stringWithFormat:@"%@,",obj._id]];
        }
    }
    
    [self.delagate getInvitedPeople:userList];
    
    if ([userList length] > 0) {
        userList = [userList substringToIndex:[userList length] - 1];
    } 
       
        
    [MouveData setValue:userList forKey:@"UserList"];
    
    NSLog(@"Mouve Data:%@",[MouveData JSONRepresentation]);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppAPIClient WSsharedClient] POST:WSName
                               parameters:MouveData
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      
                                      [hud hide:YES];
                                      
                                      NSDictionary *dict_res=(NSDictionary *)responseObject;
                                      
                                      
                                      NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                      if([isSuccessNumber boolValue] == YES)
                                      {
                                         
                                          [self UploadVideoDict:dict_res];
                                          
                                          
                                      }else{
                                          if(self.isEdit){
                                              [Utiles showAlert:ERROR Message:@"Mouve update fail."];
                                          }else{
                                              [Utiles showAlert:ERROR Message:@"Mouve create fail."];
                                          }
                                      }
                                      
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [hud hide:YES];
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
    
    }else{
        [Utiles showAlert:APP_NAME Message:@"No invites for selection."];
        
    }
   
    
}

-(void)getUserList:(NSString *)UserId{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:UserId forKey:@"UserID"];
    
    [[AFAppAPIClient WSsharedClient] POST:API_FOLLOWER_LIST
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      [hud hide:YES];
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      
                                      if(result){
                                          NSLog(@"Result:%@",[responseObject objectForKey:@"Data"]);
                                          NSArray *list=[responseObject objectForKey:@"Data"];
                                          if([list count]>0){
                                              tbl_Users.hidden=FALSE;
                                              
                                              list=[[Utiles SortArray:[list mutableCopy] Key:@"UserName"] copy];
                                              
                                              [self getContacts:list];
                                          }else{
                                              tbl_Users.hidden=TRUE;
                                          }
                                          
                                      }else{
                                          [Utiles showAlert:APP_NAME Message:[responseObject objectForKey:@"Message"]];
                                          
                                      }
                                     
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [hud hide:YES];
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
}




-(void) getContacts:(NSArray *)list{
    
    self.user_Array=[[NSMutableArray alloc] init];
    
    for (int i=0; i<[list count]; i++) {
        ContactsDAO *obj=[[ContactsDAO alloc] init];
        NSDictionary *dict=[list objectAtIndex:i];
        obj._id=[dict objectForKey:@"UserID"];
        obj.name=[dict objectForKey:@"Name"];
        obj.UserName=[dict objectForKey:@"UserName"];
        [self.user_Array addObject:obj];
    }
    [tbl_Users reloadData];
    
}



-(void)UploadVideoDict:(NSDictionary *)responseObject{
    NSArray *_array=[responseObject objectForKey:@"Data"];
    NSDictionary *MouveID_Dict=[_array objectAtIndex:0];
    NSString *mouveID=[NSString stringWithFormat:@"%@",[MouveID_Dict objectForKey:@"MouvesID"]];
    [self uploadVideo:mouveID];
    
}



-(void)uploadVideo:(NSString *)mouveID{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"mouveVideo.mov"];
    
    // NSString *myPathDocs =  [[NSBundle mainBundle] pathForResource:@"video_test" ofType:@"mp4" inDirectory:@""];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])	{	//Does
        
        __block int _completed=0;
        
        MBProgressHUD  *_HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Set determinate bar mode
        _HUD.labelText=@"Video Uploding...";
        
        _HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:myPathDocs];
        
        float factor=(float)data.length/100;
        
        NSInputStream *stream = [[NSInputStream alloc]initWithData:data];
        
        NSString *baseURL = [NSString stringWithFormat:API_VIDEO_UPLOAD,mouveID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:baseURL parameters:nil error:nil];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
            _completed=[[NSString stringWithFormat:@"%.0f", (float)totalBytesWritten/factor] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                _HUD.progress = _completed/100.0;
                
            });
            
        }];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_HUD hide:YES];
            
            if(self.isEdit){
                [Utiles showAlert:APP_NAME Message:@"Mouve updated successfully."];
            }else{
                [Utiles showAlert:APP_NAME Message:@"Mouve created successfully."];                                                                                }
            NSArray *viewsArray = [self.navigationController viewControllers];
            UIViewController *chosenView = [viewsArray objectAtIndex:0];
            [self.navigationController popToViewController:chosenView animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", error.localizedDescription);
            NSLog(@"error: %@", error.localizedFailureReason);
            [_HUD hide:YES];
        }];
        
        operation.inputStream = stream;
        
        [[[NSOperationQueue alloc] init] addOperation:operation];
        
    }else{
        if(self.isEdit){
            [Utiles showAlert:APP_NAME Message:@"Mouve updated successfully."];
        }else{
            [Utiles showAlert:APP_NAME Message:@"Mouve created successfully."];                                                                                }
        NSArray *viewsArray = [self.navigationController viewControllers];
        UIViewController *chosenView = [viewsArray objectAtIndex:0];
        [self.navigationController popToViewController:chosenView animated:YES];
    }
    
}


#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [self.user_Array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewCell1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIImageView *selection_image=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40,10, 20,20)];
        selection_image.tag=100;
        [cell.contentView addSubview:selection_image];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    ContactsDAO *obj= [self.user_Array objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20]; //Change this value to adjust size
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel setText:obj.name];
    [cell.detailTextLabel setText:obj.UserName];
        
    for (UIView *subview in [cell.contentView subviews])
    {
        if ([subview isKindOfClass:[UIImageView class]])
        {
            UIImageView *selection_image=(UIImageView *)subview;
            
            if(obj.isSelected){
                // cell.accessoryType = UITableViewCellAccessoryCheckmark;
                selection_image.image=[UIImage imageNamed:@"bluebox.png"];
                
            } else {
                selection_image.image=[UIImage imageNamed:@"whitebox.png"];
                
                //cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%d Row:%d selected and its data is %@",
          indexPath.section,indexPath.row,cell.textLabel.text);
    ContactsDAO *obj= [self.user_Array objectAtIndex:indexPath.row];
    obj.isSelected=!obj.isSelected;
    [tbl_Users reloadData];
}

-(NSArray *)getSelectedContacts{
    NSMutableArray *selectedList=[[NSMutableArray alloc] init];    
    for (int i=0; i<[self.user_Array count]; i++) {
        ContactsDAO *obj= [self.user_Array objectAtIndex:i];
        if(obj.isSelected){
            [selectedList addObject:obj];
        }
    }
    return selectedList;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
