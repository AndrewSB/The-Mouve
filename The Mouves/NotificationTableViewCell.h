//
//  NotificationTableViewCell.h
//  MOUVE
//
//  Created by Sandeep on 9/27/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "Constant.h"

@interface NotificationTableViewCell : UITableViewCell
{

}

-(void)setData:(NSDictionary *)dict;

@property (nonatomic,retain)  IBOutlet UIImageView *profile_img;
@property (nonatomic,retain)  IBOutlet UILabel *lbl_Name;
@property (nonatomic,retain)  IBOutlet UILabel *lbl_time;
@property (nonatomic,retain)  IBOutlet UIImageView *img_read;
@end
