//
//  InviteListViewController.h
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MouveDetailsViewController.h"
#import "ContactsDAO.h"


@protocol InviteListDelegate <NSObject>

-(void)getInvitedPeople:(NSString *)list;

@end


@interface InviteListViewController : UIViewController
{
    IBOutlet UITableView *tbl_Users;
    IBOutlet UIButton *btn_done;
}
@property(strong) id<InviteListDelegate> delagate;
@property (nonatomic , retain) NSMutableArray *user_Array;
@property(nonatomic,retain) NSString *isListOf;
@property (nonatomic,retain) NSDictionary *UserData;
@property (nonatomic,retain) NSDictionary *MouveData;
@property BOOL isEdit;

@end
