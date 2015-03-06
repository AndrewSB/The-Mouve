//
//  LeftViewController.h
//  MOUVE
//
//  Created by SANDY on 04/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomBadge.h"

@interface LeftViewController : BaseViewController

{
    IBOutlet UIButton *btn_notification;
    
}
@property(nonatomic,retain) CustomBadge *noti_badge;
@end
