//
//  NotificationTableViewCell.m
//  MOUVE
//
//  Created by Sandeep on 9/27/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

@synthesize img_read,profile_img,lbl_Name,lbl_time;


-(void) setSmallBorder:(int)width{
    [profile_img.layer setCornerRadius:(profile_img.frame.size.width)/2];
    [profile_img.layer setBorderWidth:width];
    [profile_img.layer setBorderColor:[UIColor whiteColor].CGColor];
    [profile_img.layer setMasksToBounds:YES];
    
}

-(void)setData:(NSDictionary *)dict{
    
    [self setSmallBorder:1];
    self.lbl_Name.text=[NSString stringWithFormat:@"@%@",[dict objectForKey:@"Message"]];
    
    NSString *relativeURL=@"";
    
    self.img_read.hidden=TRUE;
    if ([dict objectForKey:@"IsRead"]) {
        NSString *IsRead=[dict objectForKey:@"IsRead"];
        if([IsRead isEqualToString:@"N"]){
            self.img_read.hidden=FALSE;
        }
    }
    
    if ([dict objectForKey:@"UsersPhoto"]) {
        relativeURL=[dict objectForKey:@"UsersPhoto"];
    }else if ([dict objectForKey:@"MouvesPhoto"]) {
        relativeURL=[dict objectForKey:@"MouvesPhoto"];
    }
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:USER_PHOTO_URL,relativeURL]];
    [self.profile_img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
