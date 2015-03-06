//
//  SearchListViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "SearchListViewController.h"
#import "ProfileViewController.h"
#import "MouveProfileViewController.h"

@interface SearchListViewController ()

@end

static NSString *cellIdentifier1 = @"UserTableViewCell2";

@implementation SearchListViewController
@synthesize SearchKey,UserData,user_Array,MouveData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)segmentValueChnaged:(id)sender{
    if(user_Array){
        [user_Array removeAllObjects];
    }
    txt_search.text=@"";
    [tbl_Users reloadData];
}


-(void)defineSegmentControlStyle
{
    //normal segment
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont systemFontOfSize:16.0],UITextAttributeFont,
                                      [UIColor colorWithRed:75.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                      [UIColor clearColor], UITextAttributeTextShadowColor,
                                      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                      nil];//[NSDictionary dictionaryWithObject:  [UIColor redColor]forKey:UITextAttributeTextColor];
    [seg setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:16.0],UITextAttributeFont,
                                        [UIColor whiteColor], UITextAttributeTextColor,
                                        [UIColor clearColor], UITextAttributeTextShadowColor,
                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                        nil] ;//[NSDictionary dictionaryWithObject:  [UIColor redColor]forKey:UITextAttributeTextColor];
    [seg setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    CGRect frame= seg.frame;
    [seg setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+5)];
    
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
    
    [self defineSegmentControlStyle];
    
    [tbl_Users registerNib:[UINib nibWithNibName:@"UserTableViewCell"
                                          bundle:[NSBundle mainBundle]]
    forCellReuseIdentifier:cellIdentifier1];
    
    tbl_Users.hidden=TRUE;
    if(self.SearchKey.length>0){
        txt_search.text=self.SearchKey;
         [self searchUser:SearchKey];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [txt_search resignFirstResponder];
    
    self.SearchKey=textField.text;
    
    if(self.SearchKey.length>0){
        if(seg.selectedSegmentIndex==0){
            [self searchUser:SearchKey];
        }else{
            [self searchMouve:SearchKey];
        }
    }
    return NO;
}


-(void)searchUser:(NSString *)key{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    
    [dict setObject:key forKey:@"FreeText"];
    
    [[AFAppAPIClient WSsharedClient] POST:API_USER_SEARCH
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      [hud hide:YES];
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      
                                      if(result){
                                          NSLog(@"Result:%@",[responseObject objectForKey:@"Data"]);
                                          NSArray *list=[responseObject objectForKey:@"Data"];
                                          if([list count]>0){
                                              tbl_Users.hidden=FALSE;
                                              user_Array=[[NSMutableArray alloc] init];
                                              user_Array=[list mutableCopy];
                                              user_Array=[Utiles SortArray:user_Array Key:@"UserName"];
                                              
                                               [tbl_Users reloadData];
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


-(void)searchMouve:(NSString *)key{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    
    [dict setObject:key forKey:@"FreeText"];
    
    [[AFAppAPIClient WSsharedClient] POST:API_MOUVE_SEARCH
                               parameters:dict
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      [hud hide:YES];
                                      
                                      BOOL result=[[responseObject objectForKey:@"Result"] boolValue];
                                      
                                      if(result){
                                          NSLog(@"Result:%@",[responseObject objectForKey:@"Data"]);
                                          NSArray *list=[responseObject objectForKey:@"Data"];
                                          if([list count]>0){
                                              tbl_Users.hidden=FALSE;
                                              user_Array=[[NSMutableArray alloc] init];
                                              user_Array=[list mutableCopy];
                                              
                                              if(seg.selectedSegmentIndex==0){
                                                  user_Array=[Utiles SortArray:user_Array Key:@"UserName"];
                                              }else{
                                                  user_Array=[Utiles SortArray:user_Array Key:@"Name"];
                                              }
                                              
                                              [tbl_Users reloadData];
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
    user_Array=[[NSMutableArray alloc] init];
    for (int i=0; i<[list count]; i++) {
        ContactsDAO *obj=[[ContactsDAO alloc] init];
        NSDictionary *dict=[list objectAtIndex:i];
        obj._id=[dict objectForKey:@"UserID"];
        obj.name=[dict objectForKey:@"Name"];
        obj.UserName=[dict objectForKey:@"UserName"];
        obj.imageURL=[dict objectForKey:@"UsersPhoto"];
        [user_Array addObject:obj];
    }
    [tbl_Users reloadData];
    
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
    if(seg.selectedSegmentIndex==0){
        [cell setData:obj];
    }else{
        [cell setMouveData:obj];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
    if(seg.selectedSegmentIndex==0){        
    MouveProfileViewController *view=[[MouveProfileViewController alloc] initWithNibName:@"MouveProfileViewController" bundle:nil];
    view.UserData=[user_Array objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:view animated:YES];
    }else{
        MouveDetailsViewController *view=[[MouveDetailsViewController alloc] initWithNibName:@"MouveDetailsViewController" bundle:nil];
        view.Mouve_Data=[user_Array objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:view animated:YES];
        
    }
}

-(NSArray *)getSelectedContacts{
    NSMutableArray *selectedList=[[NSMutableArray alloc] init];    
    for (int i=0; i<[user_Array count]; i++) {
        ContactsDAO *obj= [user_Array objectAtIndex:i];
        if(obj.isSelected){
            for (int j=0;j<[obj.phones count];j++) {
                PhoneDAO *obj_phone= [obj.phones objectAtIndex:j];
                [selectedList addObject:obj_phone.number];
            }
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
