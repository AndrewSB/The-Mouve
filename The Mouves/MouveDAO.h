//
//  MouveDAO.h
//  MOUVE
//
//  Created by Sandeep on 9/27/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationDAO.h"

@interface MouveDAO : NSObject

@property int ID;
@property int CreatorId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) LocationDAO *location;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *type;
@property int peopleGoingCount;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
