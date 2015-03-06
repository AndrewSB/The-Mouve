//
//  NotificationsViewController.h
//  MOUVE
//
//  Created by Sandeep on 9/12/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationTableViewCell.h"
#import "BaseViewController.h"
@interface NotificationsViewController : UIViewController
{
    IBOutlet UITableView *Notification_Table;
    IBOutlet UILabel *lbl_message;
}

@property (nonatomic , retain) NSMutableArray *notification_array;
@property (nonatomic , retain) NSDictionary *selected_notification;
@end