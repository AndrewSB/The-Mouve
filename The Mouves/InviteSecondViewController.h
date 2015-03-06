//
//  InviteSecondViewController.h
//  MOUVE
//
//  Created by SANDY on 01/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "ContactsDAO.h"
#import <MessageUI/MessageUI.h>
#import "SlideBaseViewController.h"
#import "BaseViewController.h"

@interface InviteSecondViewController : BaseViewController<MFMessageComposeViewControllerDelegate>
{

    IBOutlet UITableView *table_contacts;
    
}
@property(nonatomic,retain) MBProgressHUD *contacts_hud;
@property(nonatomic ,retain) NSMutableArray *contacts_array;
@property (nonatomic ,retain) NSString *isFrom;
@property(nonatomic ,retain) NSDictionary *mouve_dict;
@property(nonatomic ,retain) NSMutableArray *recipents;
@end
