//
//  Imgur.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/20/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

var globalImgurSession: Imgur?
class Imgur: NSObject, NSURLSessionDelegate {
    let imgurSessionConfig = NSURLSessionConfiguration()
    let imgurOperationQueue = NSOperationQueue()
    var imgurSession: NSURLSession?
    
    override init() {
        imgurSessionConfig.HTTPAdditionalHeaders = ["Authorization": "Client-ID 3bf2e2045a5cbb7"]
        imgurSession = nil
            
        super.init()
        
        self.imgurSession = NSURLSession(configuration: imgurSessionConfig, delegate: self, delegateQueue: imgurOperationQueue)
    }
    
    static var defaultSession: Imgur {
        get {
            if globalImgurSession == nil {
                globalImgurSession = Imgur()
            }
            return globalImgurSession!
        }
    }

    
    
    func getImageWithIDAndCompletion(id: String, completion: (image: UIImage, error: NSError)) {
        
    }
}