//
//  LoginViewController.h
//  MOUVE
//
//  Created by SANDY on 27/08/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Constant.h"
#import "SlideBaseViewController.h"
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
{
    IBOutlet UIScrollView *bg_Scroll;
    IBOutlet UITextField *UserName;
    IBOutlet UITextField *Password;
    IBOutlet UIButton *btn_login;
    IBOutlet UIButton *btn_signup;
}


@end
