//
//  MainViewController.h
//  MOUVE
//
//  Created by SANDY on 04/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomBadge.h"
#import "SearchListViewController.h"

@interface MainViewController : BaseViewController
{
    IBOutlet UITableView *event_Table_1;
    IBOutlet UITableView *event_Table_2;
    IBOutlet UISegmentedControl *seg;
    IBOutlet UILabel *lbl_title;
    IBOutlet UIScrollView *theScrollView;
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
    
    IBOutlet UIButton *btn_menu;
    IBOutlet UILabel *lbl_error;
    
}

@property (nonatomic , retain) NSMutableArray *event_Array_Home;
@property (nonatomic , retain) NSMutableArray *event_Array_Explore;
@property(nonatomic,retain) CustomBadge *menu_badge;
@property BOOL isLocationFound;
@end
