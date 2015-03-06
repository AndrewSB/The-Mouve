//
//  UserTableViewCell.m
//  MOUVE
//
//  Created by SANDY on 04/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

@synthesize profile_img,lbl_Name,lbl_UserName,mouve_img;


-(void) setSmallBorder:(int)width{
    [profile_img.layer setCornerRadius:(profile_img.frame.size.width)/2];
    [profile_img.layer setBorderWidth:width];
    [profile_img.layer setBorderColor:[UIColor whiteColor].CGColor];
    [profile_img.layer setMasksToBounds:YES];
}



-(void)setData:(NSDictionary *)dict{
    @try {
               
    [self setSmallBorder:0];
        
        profile_img.hidden=FALSE;
        mouve_img.hidden=TRUE;
    self.lbl_Name.text=[dict objectForKey:@"Name"];
    self.lbl_UserName.text=[dict objectForKey:@"UserName"];
    
    NSString *relativeURL=@"";
        
        if([dict objectForKey:@"UsersPhoto"]){
            relativeURL=[dict objectForKey:@"UsersPhoto"];
        }else{
           relativeURL=[dict objectForKey:@"Photo"];
        }
        
   NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:USER_PHOTO_URL,relativeURL]];
    [self.profile_img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"]];
    }
    @catch (NSException *exception) {
        
    }
}

-(void)setMouveData:(NSDictionary *)dict{
    @try {
        profile_img.hidden=TRUE;
        mouve_img.hidden=FALSE;
        
        self.lbl_UserName.text=[dict objectForKey:@"Name"];
        self.lbl_Name.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"StartDate"]];
        
        NSString *relativeURL=[dict objectForKey:@"MouvesPhoto"];
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:MOUVE_PHOTO_URL,relativeURL]];
        [self.profile_img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hdrbg.png"]];
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
