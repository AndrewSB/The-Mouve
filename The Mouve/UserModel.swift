//
//  UserModel.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 8/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

class UserModel {
    static let sharedInstance = UserModel()
}

class UserRecords: UserDefaults {
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