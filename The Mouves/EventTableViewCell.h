//
//  EventTableViewCell.h
//  MOUVE
//
//  Created by SANDY on 04/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "Constant.h"

@interface EventTableViewCell : UITableViewCell
{
    
}

-(void)setData:(NSDictionary *)dict;
-(void)setProfileMouveData:(NSDictionary *)dict;

@property (nonatomic,retain)  IBOutlet UIImageView *profile_img;
@property (nonatomic,retain)  IBOutlet UILabel *lbl_Name;
@property (nonatomic,retain)  IBOutlet UILabel *lbl_time;
@property (nonatomic,retain)  IBOutlet UILabel *lbl_attendCount;

@end
