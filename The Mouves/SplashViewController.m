//
//  ViewController.m
//  MOUVE
//
//  Created by SANDY on 27/08/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "SplashViewController.h"
#import "LoginViewController.h"
#import "AFURLSessionManager.h"
#import "LocationHelper.h"

@interface SplashViewController ()
@property (nonatomic , retain) NSTimer *timer;

@property int completed;

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activityIndicator.hidden=TRUE;
    [activityIndicator stopAnimating];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerForLoadingScreen) userInfo:nil repeats:YES];
}

-(void)timerForLoadingScreen
{
    [_timer invalidate];
    
    [self checkUserData];
}

-(void) checkUserData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *UserName=[userDefaults objectForKey:@"UserName"];
    NSString *Password=[userDefaults objectForKey:@"Password"];
    if(UserName.length>0 && Password.length>0){        
        [self DoLogin];
    } else{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginViewController *controller = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

-(void)gotoMainScreen{
    
    SlideBaseViewController *view = [[SlideBaseViewController alloc] initWithNibName:@"SlideBaseViewController" bundle:nil];
   
    [self.navigationController pushViewController:view animated:NO];
}



-(void)uploadVideo2{
    
    //video_test.mp4
   
    NSString *myPathDocs =  [[NSBundle mainBundle] pathForResource:@"video_test" ofType:@"mp4" inDirectory:@""];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])	{	//Does
        
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:myPathDocs];
        
        NSInputStream *stream = [[NSInputStream alloc]initWithData:data];
        
        NSString *baseURL = [NSString stringWithFormat:@"http://117.218.164.150/TheMouveWCF/Mouves.svc/UploadMouveVideo/6"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:baseURL parameters:nil];
        //[request setTimeoutInterval:6000];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [
         operation
         setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"success: %@", operation.responseString);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error: %@", operation.error);
         }
         ];
        
        operation.inputStream = stream;
        [[[NSOperationQueue alloc] init] addOperation:operation];
    }
}




-(void)DoLogin{
    
    
    activityIndicator.hidden=FALSE;
    [activityIndicator startAnimating];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *UserName=[userDefaults objectForKey:@"UserName"];
    NSString *Password=[userDefaults objectForKey:@"Password"];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[UserName lowercaseString] forKey:@"UserName"];
    [dict setObject:[Utiles md5:Password] forKey:@"Password"];
    [[AFAppAPIClient WSsharedClient] POST:API_LOGIN
                             parameters:dict
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   
                                    activityIndicator.hidden=TRUE;
                                    [activityIndicator stopAnimating];
                                    
                                    NSDictionary *dict_res=(NSDictionary *)responseObject;
                                    
                                    
                                    NSNumber * isSuccessNumber = (NSNumber *)[dict_res objectForKey: RESULT];
                                    if([isSuccessNumber boolValue] == YES)
                                    {
                                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                        [userDefaults setObject:[dict_res objectForKey:DATA] forKey:@"MyData"];
                                        [userDefaults synchronize];
                                        
                                        [self gotoMainScreen];
                                        
                                    }else{
                                        
                                        [Utiles showAlert:ERROR Message:@"Login fail."];
                                    }
                                    
                                    
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                    activityIndicator.hidden=TRUE;
                                    [activityIndicator stopAnimating];

                                    [Utiles showAlert:ERROR Message:[error localizedDescription]];
                                    
                                }];
}



-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
