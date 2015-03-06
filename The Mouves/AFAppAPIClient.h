//
//  AFAppAPIClient.h
//  MOUVE
//
//  Created by  on 27/01/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "Utiles.h"

@interface AFAppAPIClient : AFHTTPRequestOperationManager

+ (AFHTTPRequestOperationManager *)sharedClient;
+ (instancetype)WSsharedClient;
@end
