//
//  NSNotificationCenterHelper.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit

enum LocalMessageNotification: String {
    case HomeFeedPageOne = "HomeFeedDidGoToPageOne"
    case HomeFeedPageTwo = "HomeFeedDidGoToPageTwo"
    case ActivityFeedPageOne = "ActivityFeedDidGoToPageOne"
    case ActivityFeedPageTwo = "ActivityFeedDidGoToPageTwo"
    
    case HomeTitlePageOne = "HomeTitleDidClickPageOne"
    case HomeTitlePageTwo = "HomeTitleDidClickPageTwo"
    case ActivityTitlePageOne = "ActivityTitleDidClickPageOne"
    case ActivityTitlePageTwo = "ActivityTitleDidClickPageTwo"
    
    
    case NewLocationRegistered = "NewLocationRegistered"
}

class LocalMessage {
    class func post(message: LocalMessageNotification) {

        NSNotificationCenter.defaultCenter().postNotificationName(message.rawValue, object: self)
    }
    
    class func observe(message: LocalMessageNotification, classFunction: String, inClass: AnyObject) {
        
        NSNotificationCenter.defaultCenter().addObserver(inClass, selector: Selector(classFunction), name: message.rawValue, object: nil)
    }
}