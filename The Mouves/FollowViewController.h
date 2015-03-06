//
//  FollowViewController.h
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MouveDetailsViewController.h"

@interface FollowViewController : BaseViewController
{
    IBOutlet UITableView *tbl_Users;
}
@property (nonatomic , retain) NSMutableArray *user_Array;
@property(nonatomic,retain) NSString *isListOf;
@property (nonatomic,retain) NSDictionary *UserData;
@end
