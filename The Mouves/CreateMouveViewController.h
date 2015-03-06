//
//  CreateMouveViewController.h
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NMRangeSlider.h"
#import "ImageCroppingView.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Utiles.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "InviteListViewController.h"


@interface CreateMouveViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ImageCroppingViewDelegate,InviteListDelegate>
{
    IBOutlet UISegmentedControl *segment;
    IBOutlet UIButton *btn_mouve;
    IBOutlet UIImageView *img_mouve;
    IBOutlet UIButton *btn_image;
    IBOutlet UIButton *btn_fb;
    IBOutlet UIButton *btn_tw;
    IBOutlet UIButton *btn_video;
    
    IBOutlet UILabel *start_time;
    IBOutlet UILabel *end_time;
    
    IBOutlet UITextField *txt_name;
    IBOutlet UITextField *txt_info;
    IBOutlet UITextField *txt_location;
    NSMutableDictionary *mouve_dict;
    IBOutlet UIImagePickerController *cameraUI;
    IBOutlet MPMoviePlayerController *moviePlayerController;
    
    IBOutlet UIButton *btn_play;
    IBOutlet UIImageView *img_play;
    
    IBOutlet UIDatePicker *datePicker;
}

@property (weak, nonatomic) IBOutlet NMRangeSlider *standardSlider;
@property(retain,nonatomic) ImageCroppingView *rectObject;
@property (nonatomic ,retain) NSString *selected_image;
@property (nonatomic ,retain) NSString *Invite_List;
@property BOOL isImage;
@property BOOL isImagePicking;
@property (nonatomic,retain) LocationDAO *location;
@property (nonatomic ,retain) NSMutableDictionary *mouve_dict;
@property (nonatomic ,retain) NSDictionary *edit_mouve_dict;
@property (nonatomic ,retain) NSArray *edit_UserList;
@property BOOL isEdit;
@property int selectedTime;

@property long picker_start;
@property long picker_end;

- (IBAction)labelSliderChanged:(NMRangeSlider*)sender;


@end
