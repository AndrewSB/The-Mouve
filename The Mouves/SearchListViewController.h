//
//  SearchListViewController.h
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MouveDetailsViewController.h"
#import "ContactsDAO.h"



@interface SearchListViewController : BaseViewController
{
    IBOutlet UITableView *tbl_Users;
    IBOutlet UITextField *txt_search;
    IBOutlet UISegmentedControl *seg;
}
@property (nonatomic , retain) NSMutableArray *user_Array;
@property(nonatomic,retain) NSString *SearchKey;
@property (nonatomic,retain) NSDictionary *UserData;
@property (nonatomic,retain) NSDictionary *MouveData;

@end
