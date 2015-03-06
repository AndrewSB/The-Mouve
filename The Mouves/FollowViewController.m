//
//  FollowViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "FollowViewController.h"
#import "ProfileViewController.h"
#import "MouveProfileViewController.h"

@interface FollowViewController ()

@end

static NSString *cellIdentifier1 = @"UserTableViewCell2";

@implementation FollowViewController
@synthesize isListOf,UserData,user_Array;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    tbl_Users.hidden=TRUE;
    
    [tbl_Users registerNib:[UINib nibWithNibName:@"UserTableViewCell"
                                              bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:cellIdentifier1];
    
   
    [self getUserList:[UserData objectForKey:@"UserID"] UserType:isListOf];
   
}

-(void)getUserList:(NSString *)UserId UserType:(NSString *)type{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:UserId forKey:@"UserID"];
    
    [[AFAppAPIClient WSsharedClient] POST:type
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      [hud hide:YES];
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      
                                      if(result){
                                          NSLog(@"Home Result:%@",[responseObject objectForKey:@"Data"]);
                                          self.user_Array=[responseObject objectForKey:@"Data"];
                                          
                                          self.user_Array=[Utiles SortArray:self.user_Array Key:@"UserName"];
                                          
                                          if([self.user_Array count]>0){
                                              tbl_Users.hidden=FALSE;
                                          }else{
                                              tbl_Users.hidden=TRUE;
                                          }
                                           [tbl_Users reloadData];
                                      }else{
                                          [Utiles showAlert:APP_NAME Message:[responseObject objectForKey:@"Message"]];
                                          
                                      }
                                     
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [hud hide:YES];
                                      [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                      
                                  }];
    
}

#pragma mark - Table View Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [user_Array count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        NSDictionary *obj= [self.user_Array objectAtIndex:indexPath.row];
        [cell setData:obj];
        return cell;
    
}

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}



#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MouveProfileViewController *view=[[MouveProfileViewController alloc] initWithNibName:@"MouveProfileViewController" bundle:nil];
    view.UserData=[self.user_Array objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:view animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
