//
//  Activity.swift
//  The Mouve
//
//  Created by Hilal Habashi on 8/21/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import Parse

class Activity {
    @NSManaged var type: String
    @NSManaged var fromUser: PFUser
    @NSManaged var toUser: PFUser
    @NSManaged var content: String
    @NSManaged var event: Events
    
//    // Type values
//    NSString *const kPAPActivityTypeLike       = @"like";
//    NSString *const kPAPActivityTypeFollow     = @"follow";
//    NSString *const kPAPActivityTypeComment    = @"comment";
//    NSString *const kPAPActivityTypeJoined     = @"joined";
}