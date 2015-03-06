//
//  SearchListViewController.h
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PKRevealController.h"
#import "LeftViewController.h"
#import "MainViewController.h"

@interface SlideBaseViewController : BaseViewController<PKRevealing>
{
   
}
@property (retain, nonatomic)  LeftViewController *leftViewController;
@property (retain, nonatomic)  MainViewController *mainViewController;
@property (nonatomic, strong, readwrite) PKRevealController *revealController;

@end
