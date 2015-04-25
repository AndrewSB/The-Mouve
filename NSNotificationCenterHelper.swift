//
//  NSNotificationCenterHelper.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit

enum notification: String {
    case HomeFeedPageOne = "HomeFeedDidGoToPageOne"
    case HomeFeedPageTwo = "HomeFeedDidGoToPageTwo"
    case ActivityFeedPageOne = "ActivityFeedDidGoToPageOne"
    case ActivityFeedPageTwo = "ActivityFeedDidGoToPageTwo"
    
    case TitleHitPageOne = "TitleDidClickPageOne"
    case TitleHitPageTwo = "TitleDidClickPageTwo"
}

class LocalMessage {
    class func post(message: notification) {
        NSNotificationCenter.defaultCenter().postNotificationName(message.rawValue, object: nil)
    }
    
    class func observe(message: notification, classFunction: String, inClass: AnyObject) {
        NSNotificationCenter.defaultCenter().addObserver(inClass, selector: Selector(classFunction), name: message.rawValue, object: nil)
    }
}