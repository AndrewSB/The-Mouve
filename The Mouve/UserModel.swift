//
//  UserModel.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 8/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import Alamofire

class UserModel {
    static let sharedInstance = UserModel()
    private lazy var records = UserRecords.self
    let defaultErrorMessage = "Looking for network..."
    
    var name: String? {
        get {
            return records.name
        }
    }
    
    var email: String? {
        get {
            return records.email
        }
    }
    
    var token: String? {
        get {
            return records.token
        }
    }
    
    var userId: String? {
        get {
            return records.id
        }
    }
    
    var loggedIn: Bool {
        get {
            return records.token != nil
        }
    }
    
    func login(email: String, password: String, retryNum: Int = 3, success: (() -> ()), failure: ((title: String, message : String, code : Int) -> ())) {
        Alamofire.request(.UserAuth(["email": email, "password": password])).responseJSON { (_, _, JSON, error) in
            if let response = JSON as Dictionary<String, AnyObject>? {
                if let userId = response["userid"], sessionId = response["session_id"] {
                    self.userId = userId
                    self.token = sessionId
                    success()
                }
            }
            
            // TODO: HILAL: Get hilal to actually pass errors to me like this
            // otherwise legit failure
            if let message = response["userMsg"] as? String {
                if let errorCode = response["code"] as? Int {
                    let errorTitle = response["title"] ?? self.defaultErrorMessage
                    failure(title: errorTitle, message: message, code: errorCode)
                }
            }
            
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
}

internal class UserRecords: UserDefaults {
    enum UserKey: String {
        case Name = "Name"
        case Email = "Email"
        case Token = "Token"
        case Password = "Password"
        case Id = "UserId"
    }
    
    class var name: String? {
        get {
        return get(UserDefaults.keyFor(.User(.Name))) as? String
        }
        set {
            set(newValue, forKey: UserDefaults.keyFor(.User(.Name)))
        }
    }
    
    class var email: String? {
        get {
        return get(UserDefaults.keyFor(.User(.Email))) as? String
        }
        set {
            set(newValue, forKey: UserDefaults.keyFor(.User(.Email)))
        }
    }
    
    class var token: String? {
        get {
        return get(UserDefaults.keyFor(.User(.Token))) as? String
        }
        set {
            set(newValue, forKey: UserDefaults.keyFor(.User(.Token)))
        }
    }
    
    class var password: String? {
        get {
        return get(UserDefaults.keyFor(.User(.Password))) as? String
        }
        set {
            set(newValue, forKey: UserDefaults.keyFor(.User(.Password)))
        }
    }
    
    class var id: String? {
        get {
        return get(UserDefaults.keyFor(.User(.Id))) as? String
        }
        set {
            set(newValue, forKey: UserDefaults.keyFor(.User(.Id)))
        }
    }
}