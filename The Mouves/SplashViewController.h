//
//  ViewController.h
//  MOUVE
//
//  Created by SANDY on 27/08/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SlideBaseViewController.h"

@interface SplashViewController : BaseViewController<PKRevealing>{

    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@end
