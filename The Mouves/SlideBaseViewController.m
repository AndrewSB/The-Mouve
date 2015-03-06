//
//  SlideBaseViewController.m
//  MOUVE
//
//  Created by Sandeep on 9/11/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "SlideBaseViewController.h"


@interface SlideBaseViewController ()

@end

static NSString *cellIdentifier1 = @"cellID";

@implementation SlideBaseViewController
@synthesize leftViewController,mainViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
       
    self.view.backgroundColor=[UIColor clearColor];
    
    mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    leftViewController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:frontNavigationController
                                                                     leftViewController:leftViewController
                                                                    rightViewController:nil];
    // Step 3: Configure.
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
    
    //[self.view addSubview:self.revealController.view];
    [self.navigationController pushViewController:self.revealController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
