//
//  UserDAO.h
//  MOUVE
//
//  Created by Sandeep on 9/27/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDAO : NSObject

@property int ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *Bio;
@property (nonatomic, strong) NSString *Email;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *Password;
@property (nonatomic, strong) NSString *CountryCode;
@property (nonatomic, strong) NSString *Phone;
@property (nonatomic, strong) NSString *photoUrl;
@property int followersCount;
@property int followeringCount;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
