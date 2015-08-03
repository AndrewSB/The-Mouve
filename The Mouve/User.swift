//import UIKit
//import KeychainAccess
//import Alamofire
//import SwiftyJSON
//
//class userRequestsController{

//    func createUser(name: String,
//                    username: String,
//                    password: String,
//                    email: String,
//                    fbId: String) {
//        let URL:String = (rootURL + "/api/users")
//            // JSON Body
//        let bodyParameters = [
//                "username": username,
//                "password": password,
//                "email": email,
//                "name": name,
//                "misc": (fbId.isEmpty) ? ["null"]:["fbId":fbId]
//            ]
//        let encoding = Alamofire.ParameterEncoding.JSON
//        manager.request(.POST, URL, parameters: bodyParameters, encoding: encoding)
//            .validate(statusCode: 200..<401)
//            .responseJSON {(request, response, json, error) in
//                if let anError = error
//                {
//                    println("Couldn't register user")
//                    println(error)
//                    userCredentials.sharedInstance.clearKeychain()
//                }
//                else if let json: AnyObject = json
//                {
//                    let parsed = JSON(json)
//                    println("Registered in \(email) successfully")
//                    self.authUser(email, password: password)
//                }
//            }
//        }
//
//        
//    func getMe() {
//        let URL:String = (rootURL + "/api/users")
//        manager.session.configuration.HTTPAdditionalHeaders = [
//            "Authorization": userCredentials.sharedInstance.getToken()
//        ]
//        // JSON Body
//        let encoding = Alamofire.ParameterEncoding.JSON
//        manager.request(.GET, URL, encoding: encoding)
//            .validate(statusCode: 200..<401)
//            .responseJSON {(request, response, json, error) in
//                if let anError = error
//                {
//                    println("Couldn't update user")
//                    println(error)
//                }
//                else if let json: AnyObject = json
//                {
//                    let parsed = JSON(json)
//                }
//            }
//    }
//
//
//    
//    func updateMe(name: String,
//        username: String,
//        email: String) {
//            let URL:String = (rootURL + "/api/users")
//            manager.session.configuration.HTTPAdditionalHeaders = [
//                "Authorization": userCredentials.sharedInstance.getToken()
//            ]
//            // JSON Body
//            let bodyParameters = [
//                "username": username,
//                "email": email,
//                "name": name
//            ]
//            let encoding = Alamofire.ParameterEncoding.JSON
//            manager.request(.PUT, URL, parameters: bodyParameters, encoding: encoding)
//                .validate(statusCode: 200..<401)
//                .responseJSON {(request, response, json, error) in
//                    if let anError = error
//                    {
//                        println("Couldn't update user")
//                        println(error)
//                    }
//                    else if let json: AnyObject = json
//                    {
//                        let parsed = JSON(json)
//                        println("Updated \(email) successfully")
//                    }
//            }
//    }
//    
//    func followUser(id: String) {
//        
//        let URL = NSURL(string: rootURL + "/api/users/\(id)/follow")!
//        manager.session.configuration.HTTPAdditionalHeaders = [
//            "Authorization": userCredentials.sharedInstance.getToken()
//        ]
//        // JSON Body
//        let encoding = Alamofire.ParameterEncoding.JSON
//        manager.request(.POST, URL, encoding: encoding)
//            .validate(statusCode: 200..<401)
//            .responseJSON {(request, response, json, error) in
//                if let anError = error
//                {
//                    println(error)
//                }
//                else if let json: AnyObject = json
//                {
//                    let parsed = JSON(json)
//                }
//        }
//    }
//    
//    func unfollowUser(id: String) {
//        let URL = NSURL(string: rootURL + "/api/users/\(id)/unfollow")!
//        manager.session.configuration.HTTPAdditionalHeaders = [
//            "Authorization": userCredentials.sharedInstance.getToken()
//        ]
//        // JSON Body
//        let encoding = Alamofire.ParameterEncoding.JSON
//        manager.request(.DELETE, URL, encoding: encoding)
//            .validate(statusCode: 200..<401)
//            .responseJSON {(request, response, json, error) in
//                if let anError = error
//                {
//                    println(error)
//                }
//                else if let json: AnyObject = json
//                {
//                    let parsed = JSON(json)
//                }
//        }
//    }
//    
//    func getFollowers(id: String) {
//        let URL = NSURL(string: rootURL + "/api/users/\(id)/followers")!
//        manager.session.configuration.HTTPAdditionalHeaders = [
//            "Authorization": userCredentials.sharedInstance.getToken()
//        ]
//        // JSON Body
//        let encoding = Alamofire.ParameterEncoding.JSON
//        manager.request(.GET, URL, encoding: encoding)
//            .validate(statusCode: 200..<401)
//            .responseJSON {(request, response, json, error) in
//                if let anError = error
//                {
//                    println(error)
//                }
//                else if let json: AnyObject = json
//                {
//                    let parsed = JSON(json)
//                }
//        }
//    }
//    
//    func getFollowees(id: String) {
//        let URL:String = rootURL + "/api/users/\(id)/following"
//        manager.session.configuration.HTTPAdditionalHeaders = [
//        "Authorization": userCredentials.sharedInstance.getToken()
//        ]
//        // JSON Body
//        let encoding = Alamofire.ParameterEncoding.JSON
//        manager.request(.GET, URL, encoding: encoding)
//            .validate(statusCode: 200..<401)
//            .responseJSON {(request, response, json, error) in
//                if let anError = error
//                {
//                    println(error)
//                }
//                else if let json: AnyObject = json
//                {
//                    let parsed = JSON(json)
//                }
//        }
//    }
//}