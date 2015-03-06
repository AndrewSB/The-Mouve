//
//  MouveProfileViewController.h
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MouveDetailsViewController.h"
#import "FollowViewController.h"

@interface MouveProfileViewController : BaseViewController
{
    IBOutlet UIImageView *back_image;
    IBOutlet UIImageView *user_image;
    IBOutlet UIButton *btn_profile;
    IBOutlet UILabel *lbl_name;
    IBOutlet UILabel *lbl_UserName;
    IBOutlet UILabel *lbl_following;
    IBOutlet UILabel *lbl_follower;
    
    IBOutlet UITableView *tbl_mouves;
}
@property (nonatomic , retain) NSMutableArray *event_Array_Home;
@property(nonatomic,retain) NSString *isFrom;
@property (nonatomic,retain) NSDictionary *UserData;
@property (nonatomic , retain)MBProgressHUD *hud;
@property BOOL IsFollowing;
@end
