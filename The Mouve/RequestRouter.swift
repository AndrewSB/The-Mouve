//
//  RequestRouter.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 8/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Alamofire

enum RequestRouter: URLRequestConvertible {
    static let baseURLString = "http://mouve.ngrok.io"
    
    case UserAuth([String: AnyObject])
    case UserLogout
    
    case MouveHomeFeed
    
    var authRequired: Bool {
        switch self {
        case .UserAuth:
            return false
        case .UserLogout:
            return true
        case .MouveHomeFeed:
            return true
        }
    }
    
    var method: Alamofire.Method {
        switch self {
        case .UserAuth:
            return .POST
        case .UserLogout:
            return .DELETE
        case .MouveHomeFeed:
            return .GET
        }
    }
    
    var contentType: String {
        switch self {
        case .UserAuth, .UserLogout, .MouveHomeFeed:
            return "application/json"
        }
    }
    
    var path: String {
        switch self {
        case .UserAuth:
            return "/api/users/login"
        case .UserLogout:
            return "api/users/logout"
        case .MouveHomeFeed:
            return "/api/mouves/mine"
        }
    }
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: RequestRouter.baseURLString)!
        var timeout: NSTimeInterval = 25
        var pathURL = URL.URLByAppendingPathComponent(path)
    
        
        let mutableURLRequest = NSMutableURLRequest(URL: pathURL)
        mutableURLRequest.cachePolicy = .ReloadIgnoringLocalCacheData
        
        mutableURLRequest.timeoutInterval = timeout
        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if authRequired {
            let token = UserModel.sharedInstance.token!
            mutableURLRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .UserAuth(let parameters):
            mutableURLRequest.timeoutInterval = 15
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .UserLogout:
            mutableURLRequest.timeoutInterval = 15
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .MouveHomeFeed:
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        }
        
    }
}