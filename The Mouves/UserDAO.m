//
//  UserDAO.m
//  MOUVE
//
//  Created by Sandeep on 9/27/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "UserDAO.h"

@implementation UserDAO

- (id)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.ID = [[attributes valueForKeyPath:@"_id"] intValue];
    
    self.name=[attributes valueForKeyPath:@"name"];
    
    self.Bio=[attributes valueForKeyPath:@"Bio"];
    
    self.Email=[attributes valueForKeyPath:@"Email"];
  
    self.photoUrl=[attributes valueForKeyPath:@"photoUrl"];
    
    self.gender=[attributes valueForKeyPath:@"gender"];
    
    self.Password=[attributes valueForKeyPath:@"Password"];
    
    self.CountryCode=[attributes valueForKeyPath:@"CountryCode"];
    
    self.Phone=[attributes valueForKeyPath:@"Phone"];
    
    self.followersCount=[[attributes valueForKeyPath:@"followersCount"] intValue];
    
    self.followeringCount=[[attributes valueForKeyPath:@"followeringCount"] intValue];
        
    return self;
    
}


@end
