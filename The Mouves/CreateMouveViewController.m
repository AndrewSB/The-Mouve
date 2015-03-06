//
//  CreateMouveViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "CreateMouveViewController.h"
#import "InviteSecondViewController.h"
#import "InviteListViewController.h"
#import "AFHTTPRequestOperation.h"
#import "LocationHelper.h"



#define InterVal 10
@interface CreateMouveViewController ()

@end

@implementation CreateMouveViewController
@synthesize mouve_dict,edit_UserList,edit_mouve_dict,isEdit,selected_image,rectObject,isImage,isImagePicking,Invite_List,picker_start,picker_end;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)back:(id)sender{
    [self hideKeyBoard:0];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentSwitch:(id)sender {
    
    NSInteger selectedSegment = segment.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        if(self.isEdit){
            [btn_mouve setTitle: @"Save Changes" forState: UIControlStateNormal];
        }else{
            [btn_mouve setTitle: @"Create The Mouve" forState: UIControlStateNormal];
        }
    }else{
      [btn_mouve setTitle: @"Invite >" forState: UIControlStateNormal];
    }
}



-(void)UploadVideoDict:(NSDictionary *)responseObject{
    NSArray *_array=[responseObject objectForKey:@"Data"];
    NSDictionary *MouveID_Dict=[_array objectAtIndex:0];
    NSString *mouveID=[NSString stringWithFormat:@"%@",[MouveID_Dict objectForKey:@"MouvesID"]];
    [self uploadVideo:mouveID];
    
}


-(void)doWScall{
    
   // NSLog(@"Mouve Data:%@",[self.mouve_dict JSONRepresentation]);
    NSString *WSName=API_CREATE_MOUVE;
    
    if(self.isEdit){
        WSName=API_UPDATE_MOUVE;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppAPIClient WSsharedClient] POST:WSName
                             parameters:self.mouve_dict
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    
                                    [hud hide:YES];
                                    
                                    NSDictionary *dict_res=(NSDictionary *)responseObject;
                                    
                                    
                                    NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                    if([isSuccessNumber boolValue] == YES)
                                    {
                                        
                                        [self UploadVideoDict:dict_res];
                                        
                                        
                                    }else{
                                        if(self.isEdit){
                                            [Utiles showAlert:ERROR Message:@"Mouve update fail."];
                                        }else{
                                            [Utiles showAlert:ERROR Message:@"Mouve create fail."];
                                        }
                                    }                                    
                                    
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [hud hide:YES];
                                    [Utiles showAlert:APP_NAME Message:[error localizedDescription]];
                                    
                                }];   
    
    
    
    
}


-(IBAction)hideKeyBoard:(id)sender{
    [txt_name resignFirstResponder];
    [txt_info resignFirstResponder];
    [txt_location resignFirstResponder];
    datePicker.hidden=TRUE;
}


-(IBAction)btn_done:(id)sender{
    
    
    if(txt_name.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter Name"];
        return;
    }
    if(txt_info.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter information"];
        return;
    }
    
    if(txt_location.text.length==0){
        [Utiles showAlert:APP_NAME Message:@"Enter location"];
        return;
    }
    
    
    [txt_name resignFirstResponder];
    [txt_info resignFirstResponder];
    [txt_location resignFirstResponder];
    datePicker.hidden=TRUE;
    
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:txt_name.text forKey:@"Name"];
    [dict setObject:txt_info.text forKey:@"Info"];
    [dict setObject:txt_location.text forKey:@"Location"];
    
    long lowerValue=[self getCurrentTime]+(int)self.standardSlider.lowerValue;
    long upperValue=[self getCurrentTime]+(int)self.standardSlider.upperValue;
    
    
    NSLog(@"Start Date:%@ Time: %@",[self getDateString:lowerValue],[self getTimeString:lowerValue]);
    NSLog(@"End Date:%@ Time: %@",[self getDateString:upperValue],[self getTimeString:upperValue]);
    
    [dict setObject:[self getDateString:lowerValue] forKey:@"StartDate"];
    [dict setObject:[self getDateString:upperValue] forKey:@"EndDate"];
    
    [dict setObject:[self getTimeString:lowerValue] forKey:@"StartTime"];
    [dict setObject:[self getTimeString:upperValue] forKey:@"EndTime"];
    
    [dict setObject:[NSString stringWithFormat:@"%f",_location.location.latitude] forKey:@"Latitude"];
    [dict setObject:[NSString stringWithFormat:@"%f",_location.location.longitude] forKey:@"Longitude"];
    
    [dict setObject:@"" forKey:@"Video"];
    [dict setObject:@"" forKey:@"UserList"];
    
    self.selected_image=  [Utiles encodeToBase64String:[img_mouve image]];
    
    if(self.selected_image.length>0){
        [dict setObject:self.selected_image forKey:@"MouvesPhoto"];
    }
    
    if(self.isEdit){
     [dict setObject:[self.mouve_dict objectForKey:@"MouvesID"] forKey:@"MouvesID"];
    }
    
    if(segment.selectedSegmentIndex==1){
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"IsPublic"];
                
        self.mouve_dict =dict;
    
        
        InviteListViewController *view=[[InviteListViewController alloc] initWithNibName:@"InviteListViewController" bundle:nil];
        view.delagate=self;
        view.MouveData=dict;
        view.isEdit=self.isEdit;
        [self.navigationController pushViewController:view animated:YES];       
        
    }else{
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"IsPublic"];

        self.mouve_dict =dict;
        
        [self doWScall];
    }
}
-(void)getInvitedPeople:(NSString *)list{
    self.Invite_List=list;    
}



-(IBAction)btn_video_clicked:(id)sender{
    
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)) {
         [Utiles showAlert:@"Sorry" Message:@"Device does not support video recording."];
        return ;
    }
    // 2 - Get image picker
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.videoMaximumDuration = 10.0f;
    cameraUI.delegate = self;
    // 3 - Display image picker
    [self.navigationController presentViewController:cameraUI animated:YES completion:^{}];
}





-(IBAction)btn_Image_Clicked:(id)sender{
    
    BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    NSString *actionSheetTitle = @"Mouve photo";
    NSString *other1 = @"Camera";
    NSString *other2 = @"Gallery";
    NSString *other3 = @"Remove";
    NSString *cancelTitle = @"Cancel";
    
    if(isCamera){
        
        
        if (isImage) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:actionSheetTitle
                                          delegate:self
                                          cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:other1, other2,other3, nil];
            
            [actionSheet showInView:self.view];
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:actionSheetTitle
                                          delegate:self
                                          cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:other1, other2, nil];
            
            [actionSheet showInView:self.view];
            
        }
        
        
    }else{
        
        
        if (isImage) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:actionSheetTitle
                                          delegate:self
                                          cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:other2,other3, nil];
            
            [actionSheet showInView:self.view];
            
        }else{
            isImagePicking=TRUE;
            UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController presentViewController:picker animated:YES completion:^{}];
        }
        
        
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int i = buttonIndex;
    
    switch(i)
    {
        case 0:
        {
            
            BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if(isCamera){
                isImagePicking=TRUE;
                UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
                [self.navigationController presentViewController:picker animated:YES completion:^{}];
            }else{
                isImagePicking=TRUE;
                UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController presentViewController:picker animated:YES completion:^{}];
            }
        }
            break;
        case 1:
        {
            BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if(isCamera){
                isImagePicking=TRUE;
                UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController presentViewController:picker animated:YES completion:^{}];
            }else{
                img_mouve.image=[UIImage imageNamed:@"camera.png"];
                isImage=FALSE;
            }
        }
            
        case 2:
        {
            self.selected_image=@"";
            img_mouve.image=[UIImage imageNamed:@"camera.png"];
            isImage=FALSE;
        }
            break;
        default:
            
            break;
    }
    
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
   
}




-(void)uploadVideo:(NSString *)mouveID{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"mouveVideo.mov"];
    
   // NSString *myPathDocs =  [[NSBundle mainBundle] pathForResource:@"video_test" ofType:@"mp4" inDirectory:@""];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])	{	//Does
        
       __block int _completed=0;
        
        MBProgressHUD  *_HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Set determinate bar mode
        _HUD.labelText=@"Video Uploding...";
        
        _HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:myPathDocs];
        
        float factor=(float)data.length/100;
        
        NSInputStream *stream = [[NSInputStream alloc]initWithData:data];
        
        NSString *baseURL = [NSString stringWithFormat:API_VIDEO_UPLOAD,mouveID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:baseURL parameters:nil error:nil];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
            _completed=[[NSString stringWithFormat:@"%.0f", (float)totalBytesWritten/factor] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                _HUD.progress = _completed/100.0;
                
            });
            
        }];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_HUD hide:YES];
            
            if(self.isEdit){
                [Utiles showAlert:APP_NAME Message:@"Mouve updated successfully."];
            }else{
                [Utiles showAlert:APP_NAME Message:@"Mouve created successfully."];
            }
            
            [self.navigationController popViewControllerAnimated:TRUE];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", error.localizedDescription);
            NSLog(@"error: %@", error.localizedFailureReason);
            [_HUD hide:YES];
        }];
        
        operation.inputStream = stream;
        
        [[[NSOperationQueue alloc] init] addOperation:operation];
        
    }else{
        if(self.isEdit){
            [Utiles showAlert:APP_NAME Message:@"Mouve updated successfully."];
        }else{
            [Utiles showAlert:APP_NAME Message:@"Mouve created successfully."];
        }
        [self.navigationController popViewControllerAnimated:TRUE];
    }

}


-(IBAction)playVideo:(id)sender{
    
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"mouveVideo.mov"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])		//Does file exist?
            {
                if(moviePlayerController){
                    moviePlayerController=nil;
                }
                moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:myPathDocs]];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(moviePlaybackComplete:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:moviePlayerController];
                
                [self.view addSubview:moviePlayerController.view];
                moviePlayerController.fullscreen = YES;
                [moviePlayerController play];
            }
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
    //MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    
    [moviePlayerController.view removeFromSuperview];
}


-(UIImage *) processImage:(UIImage *)org_img{
    
    @try {
        
        
        UIImage *rotatedImage;
        
        if (org_img.imageOrientation != UIImageOrientationUp)
        {
            UIGraphicsBeginImageContextWithOptions(org_img.size, NO, org_img.scale);
            
            [org_img drawInRect:(CGRect){0, 0, org_img.size}];
            
            rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
        }
        else
        {
            rotatedImage = org_img;
        }
        
        
        
        return rotatedImage;
    }
    @catch (NSException *exception) {
        
       return org_img;
    }
}

#pragma - mark Selecting Image from Camera and Library

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
     [picker dismissViewControllerAnimated:YES completion:^{}];
       // 3 - Handle video selection
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSLog(@"Video One  Loaded");
        AVAsset * firstAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
                
        // 4 - Get path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"mouveVideo.mov"];
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        // 5 - Create exporter
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:firstAsset presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                btn_play.hidden=FALSE;
               //[self exportDidFinish:exporter];
            });
        }];
       
    }else{
        
        
     isImage=TRUE;
    
        UIImage *selectedImage =[self processImage: [info objectForKey:@"UIImagePickerControllerOriginalImage"]];
        
    
    self.rectObject=[[ImageCroppingView alloc]initWithNibName:@"ImageCroppingView" bundle:nil];
    self.rectObject.delegate=self;
    self.rectObject.input_Image=selectedImage;
        self.rectObject.isProfileImage=NO;
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    [appDelegate.window addSubview:self.rectObject.view];
    [self addChildViewController:self.rectObject];
    
        isImagePicking=FALSE;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

-(void)imageIsDoneCropping:(UIImage *)image{
    img_mouve.image=image;
    [self canceledCroppingImage];
}

-(void)canceledCroppingImage{
    [self.rectObject.view removeFromSuperview];
    [self.rectObject removeFromParentViewController];
}



-(void)viewWillAppear:(BOOL)animated{
     [self.revealController setRecognizesPanningOnFrontView:FALSE];
    
    txt_name.attributedPlaceholder= [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
     txt_info.attributedPlaceholder= [[NSAttributedString alloc] initWithString:@"Info" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
     txt_location.attributedPlaceholder= [[NSAttributedString alloc] initWithString:@"Location" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [self defineSegmentControlStyle];
    
    if(self.isEdit){
        self.title=@"UPDATE MOUVE";
    }else{
        self.title=@"NEW MOUVE";
    }
   
}

-(void)defineSegmentControlStyle
{
    //normal segment
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont systemFontOfSize:16.0],UITextAttributeFont,
                                      [UIColor colorWithRed:75.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                      [UIColor clearColor], UITextAttributeTextShadowColor,
                                      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                      nil];//[NSDictionary dictionaryWithObject:  [UIColor redColor]forKey:UITextAttributeTextColor];
    [segment setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:16.0],UITextAttributeFont,
                                        [UIColor whiteColor], UITextAttributeTextColor,
                                        [UIColor clearColor], UITextAttributeTextShadowColor,
                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                        nil] ;//[NSDictionary dictionaryWithObject:  [UIColor redColor]forKey:UITextAttributeTextColor];
    [segment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    CGRect frame= segment.frame;
    [segment setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+5)];
    
}


- (void) updateSliderLabels
{
    
    
    
    long lowerValue=[self getCurrentTime]+(int)self.standardSlider.lowerValue;
    long upperValue=[self getCurrentTime]+(int)self.standardSlider.upperValue;
    
    NSLog(@"Start Date:%@ Time: %@",[self getDateString:lowerValue],[self getTimeString:lowerValue]);
    NSLog(@"End Date:%@ Time: %@",[self getDateString:upperValue],[self getTimeString:upperValue]);
   start_time.text = [NSString stringWithFormat:@"%@",[self getTimeString:lowerValue]];
    end_time.text=[NSString stringWithFormat:@"%@", [self getTimeString:upperValue]];
    
}



// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
   //
    
    int lowerValue=self.standardSlider.lowerValue;
    
    int upperValue=self.standardSlider.upperValue;
    
    NSLog(@"lowerValue:%d, upperValue:%d",lowerValue,upperValue);
    [self updateSliderLabels];
    
    
    
    
}


- (void) configureMetalThemeForSlider:(NMRangeSlider*) slider
{
   
    
    self.standardSlider.minimumValue = 0;
    self.standardSlider.maximumValue = 86400;
    self.standardSlider.lowerValue = 0;
    self.standardSlider.upperValue = 86400;
   
    self.standardSlider.continuous=YES;
    
    [self labelSliderChanged:self.standardSlider];
}


-(long )getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM dd, yyyy h:mm a"];
    NSTimeZone *gmt = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:gmt];
    NSDate *dt =[NSDate date];
    return[dt timeIntervalSince1970];
}

-(NSString *) getDaysFromCurrentTimeString:(long ) timestamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yyyy hh:mm a";
    return  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: date]];
}

-(NSString *) getDateString:(long )timestamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    return  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: date]];
}

-(NSString *) getTimeString:(long )timestamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"hh:mm a";
    return  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: date]];
}



-(void)setMouveEditData{
    self.mouve_dict=[self.edit_mouve_dict mutableCopy];
    txt_name.text=[self.mouve_dict objectForKey:@"Name"];
    txt_info.text=[self.mouve_dict objectForKey:@"Info"];
    txt_location.text=[self.mouve_dict objectForKey:@"Location"];
    
    start_time.text=[self.mouve_dict objectForKey:@"StartTime"] ;
    end_time.text=[self.mouve_dict objectForKey:@"EndTime"];
    
    NSString *relativeURL=[self.mouve_dict objectForKey:@"MouvesPhoto"];
    if (relativeURL.length>0) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:MOUVE_PHOTO_URL,relativeURL]];
        [img_mouve setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hdrbg"]];
    }
    
}

-(IBAction)TimePickerSelected_1:(id)sender{
    _selectedTime=1;
    datePicker.hidden=FALSE;
}

-(IBAction)TimePickerSelected_2:(id)sender{
    _selectedTime=2;
    datePicker.hidden=FALSE;
}


- (void) LocationUpdateNotification:(NSNotification *) notification
{
    NSString *addressString=(NSString *) notification.object;
    txt_location.text=addressString;
    
    _location=[[LocationDAO alloc] init];
    _location.address=addressString;
    _location.location=[LocationHelper sharedLocationHelper].currentLocation.coordinate;
    
    [[LocationHelper sharedLocationHelper] stopTrackingLocation];
    
}

-(void) dateTextField:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = datePicker.date;
    [dateFormat setDateFormat:@"hh:mm a"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    
    dateString=[dateString stringByReplacingOccurrencesOfString:@"am" withString:@"AM"];
    dateString=[dateString stringByReplacingOccurrencesOfString:@"pm" withString:@"PM"];
    if(_selectedTime==1){
        start_time.text = [NSString stringWithFormat:@"%@",dateString];
        
        picker_start= [eventDate timeIntervalSince1970];
        
        self.standardSlider.lowerValue=picker_start-[self getCurrentTime];
        
    }else{
        picker_end=[eventDate timeIntervalSince1970];

        self.standardSlider.upperValue=picker_end-[self getCurrentTime];
        
        end_time.text = [NSString stringWithFormat:@"%@",dateString];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    datePicker.hidden=TRUE;
    
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor = [UIColor lightGrayColor];
    
    
    NSDate *date_min = [NSDate dateWithTimeIntervalSince1970:[self getCurrentTime]];
    
    NSDate *date_max = [NSDate dateWithTimeIntervalSince1970:[self getCurrentTime]+86400];
    
    datePicker.minimumDate = date_min;
    datePicker.maximumDate = date_max;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LocationUpdateNotification:)
                                                 name:@"LocationUpdateNotification"
                                               object:nil];
    
     [self.navigationController setNavigationBarHidden:YES];
    
    
    btn_play.hidden=TRUE;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"mouveVideo.mov"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])	{	//Does
        BOOL status=[[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
        if(status){
            btn_play.hidden=TRUE;
        }
    }
    
    isImage=FALSE;
    
    self.mouve_dict=[[NSMutableDictionary alloc] init];
    
    [self configureMetalThemeForSlider:self.standardSlider];
    
    if(self.isEdit){
        [self setMouveEditData];
    }else{        
        [[LocationHelper sharedLocationHelper] startTrackingLoocation];
    }
    [ self segmentSwitch:0];
   
}


- (void)locationManager:(CLLocationManager*)aManager didFailWithError:(NSError*)anError
{
    switch([anError code])
    {
        case kCLErrorLocationUnknown:
            break;
            
        case kCLErrorDenied:
        {
            
           
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Denied" message:@"You didn't allow to access your current location you can change it from ur phone settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
               
          
            
            break;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
