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
    
    case LoginUser(String)
    
    var authRequired: Bool {
        switch self {
        case .LoginUser(let parameters):
            return true
        }
    }
    
    var method: Alamofire.Method {
        switch self {
        case .LoginUser(let parameters):
            return .GET
        }
    }
    
    var contentType: String {
        switch self {
        case .LoginUser(let parameters):
            return "application/json"
        }
    }
    
    var path: String {
        switch self {
        case .LoginUser(let parameters):
            return "/login"
        }
    }
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: RequestRouter.baseURLString)!
        var timeout: NSTimeInterval = 25
        var pathURL = URL.URLByAppendingPathComponent(path)
        
        switch self {
        case .LoginUser(let parameters):
            if let pathURLString = pathURL.absoluteString {
                var finalURLString = pathURLString // + other path params
                if let finalURL = NSURL(string: finalURLString) {
                    pathURL = finalURL
                }
            }
        }
    
        
        let mutableURLRequest = NSMutableURLRequest(URL: pathURL)
        mutableURLRequest.cachePolicy = .ReloadIgnoringLocalCacheData
        
        mutableURLRequest.timeoutInterval = timeout
        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if authRequired {
            let token = UserModel.sharedInstance.userRecord.accessToken
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
}