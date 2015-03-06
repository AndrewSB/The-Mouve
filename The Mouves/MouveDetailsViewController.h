//
//  MouveDetailsViewController.h
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <Social/Social.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MouveDetailsViewController : BaseViewController
{
    IBOutlet UILabel *lbl_name;
    IBOutlet UILabel *lbl_address;
    IBOutlet UILabel *lbl_time;
    IBOutlet UILabel *lbl_going;
    IBOutlet UITextView *lbl_info;
    IBOutlet UIImageView *user_image;
    IBOutlet UIImageView *mouve_image;
    IBOutlet UIScrollView *invitessScroll;
    IBOutlet UISwitch *bnt_going;
    IBOutlet UIButton *btn_edit;
    IBOutlet UILabel *lbl_going_Switch;
    IBOutlet MPMoviePlayerViewController *mp;
    
    IBOutlet UIButton *btn_video;
}

@property(nonatomic,retain) NSDictionary *Mouve_Data;
@property(nonatomic,retain) NSMutableArray *User_Data;
@property BOOL isYouGoing;
@end
