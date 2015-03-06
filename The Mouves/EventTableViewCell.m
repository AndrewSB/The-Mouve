//
//  EventTableViewCell.m
//  MOUVE
//
//  Created by SANDY on 04/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

@synthesize profile_img,lbl_Name,lbl_time,lbl_attendCount;


-(void) setSmallBorder:(int)width{
    [profile_img.layer setCornerRadius:(profile_img.frame.size.width)/2];
    [profile_img.layer setBorderWidth:width];
    [profile_img.layer setBorderColor:[UIColor whiteColor].CGColor];
    [profile_img.layer setMasksToBounds:YES];
    
}

-(void)setData:(NSDictionary *)dict{
    @try {
               
    [self setSmallBorder:1];
    self.lbl_Name.text=[dict objectForKey:@"Name"];
     self.lbl_time.text=[NSString stringWithFormat:@"%@ - %@",[dict objectForKey:@"StartTime"],[dict objectForKey:@"EndTime"]];
    
    int going_count=[[dict objectForKey:@"IsGoing"] intValue];
    if(going_count>0){
        self.lbl_attendCount.text=[NSString stringWithFormat:@"%@ People Going",[dict objectForKey:@"IsGoing"]];
    }else{
     self.lbl_attendCount.text=@"Be the first for Going";
    }
    
        NSString *relativeURL=@"";
        
        if ([dict objectForKey:@"UsersPhoto"]) {
            relativeURL=[dict objectForKey:@"UsersPhoto"];
        }else if ([dict objectForKey:@"MouvesPhoto"]) {
            relativeURL=[dict objectForKey:@"MouvesPhoto"];
        }
        
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:USER_PHOTO_URL,relativeURL]];
    [self.profile_img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"]];
    }
    @catch (NSException *exception) {
        
    }
}

-(void)setProfileMouveData:(NSDictionary *)dict{
    @try {
        
        [self setSmallBorder:1];
        self.lbl_Name.text=[dict objectForKey:@"Name"];
        self.lbl_time.text=[NSString stringWithFormat:@"%@ - %@",[dict objectForKey:@"StartTime"],[dict objectForKey:@"EndTime"]];
        
        int going_count=[[dict objectForKey:@"Going"] intValue];
        if(going_count>0){
            self.lbl_attendCount.text=[NSString stringWithFormat:@"%@ People Going",[dict objectForKey:@"Going"]];
        }else{
            self.lbl_attendCount.text=@"Be the first for Going";
        }
        
        NSString *relativeURL=@"";
        
        if ([dict objectForKey:@"MouvesPhoto"]) {
            relativeURL=[dict objectForKey:@"MouvesPhoto"];
        }else if ([dict objectForKey:@"UsersPhoto"]) {
            relativeURL=[dict objectForKey:@"UsersPhoto"];
        }
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:MOUVE_PHOTO_URL,relativeURL]];
        [self.profile_img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hdrbg"]];
    }
    @catch (NSException *exception) {
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
