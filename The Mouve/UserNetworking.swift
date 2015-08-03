//
//  UserNetworking.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 8/3/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import Alamofire

extension UserModel {
    func login(email: String, password: String, retryNum: Int = 3, success: (() -> ()), failure: ((title: String, message : String, code : Int) -> ())) {
        Alamofire.request(.UserAuth(["email": email, "password": password])).responseJSON { (_, _, JSON, error) in
            if let response = JSON as [String: AnyObject]? {
                if let userId = response["userid"], sessionId = response["session_id"] {
                    self.userId = userId
                    self.token = sessionId
                    success()
                    return
                }
            }
            
            // TODO: HILAL: Get hilal to actually pass errors to me like this
            // otherwise legit failure
            if let message = response["userMsg"] as? String {
                if let errorCode = response["code"] as? Int {
                    let errorTitle = response["title"] ?? self.defaultErrorMessage
                    failure(title: errorTitle, message: message, code: errorCode)
                    return
                }
            }
            
            //remove after implementing retries
            return
            
            // TODO: HILAL: Implement retries with Hilal
            //            let newRetryNum = retryNum + 1
            //            if newRetryNum < self.maxRetries {
            //                // show an alert that an error occurred
            //                log("AUTH PHONE NUMBER: RETRY \(newRetryNum)")
            //                Tracking.trackEvent("authphone_retry", withProperties: [ "num": newRetryNum ])
            //                self.internalAuthWithPhoneNumber(phoneNumber, retryNum: newRetryNum, success: success, failure: failure)
            //            }
            //            else {
            //                failure(title: self.defaultErrorTitle, message: self.defaultErrorMessage, code: -999)
            //            }
            
        }
    }
    
    func logout(retryNum: Int = 3, success: (() -> ()), failure: ((title: String, message : String, code : Int) -> ())) {
        Alamofire.request(.UserLogout).responseJSON { (_, _, JSON, error) in
            if let response = JSON as? [String: AnyObject]? {
                UserModel.sharedInstance.nuke()
                return
            }
            
            // legitFailure
            if let message = response["userMsg"] as? String {
                if let errorCode = response["code"] as? Int {
                    let errorTitle = response["title"] ?? self.defaultErrorMessage
                    failure(title: errorTitle, message: message, code: errorCode)
                    return
                }
            }
    
            
            // TODO: implement retries
            return
        }
    }
}