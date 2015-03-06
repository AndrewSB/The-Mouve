//
//  MouveDAO.m
//  MOUVE
//
//  Created by Sandeep on 9/27/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//

#import "MouveDAO.h"

@implementation MouveDAO
- (id)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
   
    self.ID = [[attributes valueForKeyPath:@"_id"] intValue];
    
    self.CreatorId = [[attributes valueForKeyPath:@"CreatorId"] intValue];
    
    self.name=[attributes valueForKeyPath:@"name"];
    
    self.description=[attributes valueForKeyPath:@"description"];
    
    self.type=[attributes valueForKeyPath:@"type"];
    
    self.location=[[LocationDAO alloc] initWithAttributesFromDB:attributes];
    
    self.start_time=[attributes valueForKeyPath:@"start_time"];
    self.end_time=[attributes valueForKeyPath:@"end_time"];
    self.photoUrl=[attributes valueForKeyPath:@"MouvesPhoto"];
    self.videoUrl=[attributes valueForKeyPath:@"videoUrl"];
    self.peopleGoingCount=[[attributes valueForKeyPath:@"peopleGoingCount"] intValue];
    
    return self;
    
}


@end
