//
//  InviteSecondViewController.m
//  MOUVE
//
//  Created by SANDY on 01/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "InviteSecondViewController.h"


@interface InviteSecondViewController ()

@end

@implementation InviteSecondViewController
@synthesize recipents,mouve_dict,isFrom,contacts_array,contacts_hud;


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

- (void) contacts_Notification:(NSNotification *) notification
{
    
    [contacts_hud hide:YES];
    
    contacts_array=(NSMutableArray *) notification.object;
    
    contacts_array=[Utiles SortArray:contacts_array Key:@"name"];
    
    [table_contacts reloadData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            
            if([isFrom isEqualToString:@"firstScreen"]){
                [self DoLogin];
            }else if([isFrom isEqualToString:@"FromLeft"]){
                [self back:0];
            }            
        }
    }
}
-(IBAction)sendInvite:(id)sender{
    
    recipents = [[NSMutableArray alloc] init];
    recipents=[[self getSelectedContacts] mutableCopy];
    
    if([recipents count]==0){
        [Utiles showAlert:APP_NAME Message:@"Please select Invites."];
        return;
    }
   
    if(![MFMessageComposeViewController canSendText]) {
        
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS to Invite!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Skip",nil];
        warningAlert.tag=1;
        [warningAlert show];
        
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"This is the invitation for MOUVE!"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}


-(void)gotoMainScreen{
    
    SlideBaseViewController *view = [[SlideBaseViewController alloc] initWithNibName:@"SlideBaseViewController" bundle:nil];
    
    [self.navigationController pushViewController:view animated:NO];
}



-(NSArray *)getSelectedContacts{

    NSMutableArray *selectedList=[[NSMutableArray alloc] init];
    
    for (int i=0; i<[contacts_array count]; i++) {
        ContactsDAO *obj= [contacts_array objectAtIndex:i];
        if(obj.isSelected){
            for (int j=0;j<[obj.phones count];j++) {
                PhoneDAO *obj_phone= [obj.phones objectAtIndex:j];
                [selectedList addObject:obj_phone.number];
            }
        }
    }
    return selectedList;
}


-(void)DoLogin{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *UserName=[userDefaults objectForKey:@"UserName"];
    NSString *Password=[userDefaults objectForKey:@"Password"];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[UserName lowercaseString] forKey:@"UserName"];
    [dict setObject:[Utiles md5:Password] forKey:@"Password"];
    [[AFAppAPIClient WSsharedClient] POST:API_LOGIN
                             parameters:dict
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    [hud hide:YES];
                                    
                                    NSDictionary *dict_res=(NSDictionary *)responseObject;
                                    
                                    NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                    if([isSuccessNumber boolValue] == YES)
                                    {
                                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                        [userDefaults setObject:[dict_res objectForKey:DATA] forKey:@"MyData"];
                                        [userDefaults synchronize];
                                        
                                        [self gotoMainScreen];
                                        
                                    }else{
                                        
                                        [Utiles showAlert:ERROR Message:@"Login fail."];
                                    }
                                    
                                    
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [hud hide:YES];
                                    [Utiles showAlert:ERROR Message:[error localizedDescription]];
                                    
                                }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            
            if([isFrom isEqualToString:@"firstScreen"]){
                [self DoLogin];
            }else if([isFrom isEqualToString:@"FromLeft"]){
                [self back:0];
            }
            
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contacts_Notification:)
                                                 name:ALL_CONTACTS_SYNC
                                               object:nil];    
    
    if([[ContactsDAO sharedContactsDAO] getAccessPermission]){
        contacts_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[ContactsDAO sharedContactsDAO] syncPersonOutOfAddressBook];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [contacts_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewCell2";
    
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
    
    ContactsDAO *obj= [contacts_array objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20]; //Change this value to adjust size
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel setText:obj.name];
    
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
    ContactsDAO *obj= [contacts_array objectAtIndex:indexPath.row];
    obj.isSelected=!obj.isSelected;
    [table_contacts reloadData];
}


@end
