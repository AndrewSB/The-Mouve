//import UIKit
//import KeychainAccess
//import Alamofire
//import SwiftyJSON
//
//
//class userCredentials{
//    let keychain = Keychain(service: "tm.The-Mouve")
//    let deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
////    let defaults = NSUserDefaults.standardUserDefaults()
//    
//    func getUsername() -> String {
//        if let username = keychain["username"] {
//            return username
//        }
//        return "Anonymous"
//    }
//    func getPassword() -> String {
//        if let password = keychain["password"] {
//            return password
//        }
//        return "Password"
//    }
//    
//    
//    func getToken() -> String {
//        if let token = keychain["token"] {
//            return token
//        }
//        return "Token"
//    }
//    
//    
//    func getUserId() -> String {
//        if let userLink = keychain["userid"] {
//            return userLink
//        }
//        return "NA"
//    }
//    
//    
//    func logUserOut() {
//        userRequestsController.sharedInstance.requestLogout()
//    }
//    
//    func clearKeychain() {
//        keychain.remove("username")
//        keychain.remove("password")
//        keychain.remove("token")
////        keychain.remove("userid")
//    }
//    
//    func setUser(email: String,password: String, id:String, token: String) {
//        keychain["email"] = email
//        keychain["password"] = password
//        keychain["token"] = token
//        keychain["userid"] = id
////        var usernamesDict = NSMutableDictionary()
////        defaults.setObject(usernamesDict, forKey: "usernamesDict")
//    }
//    
//
//    class var sharedInstance: userCredentials{
//        struct Static {
//            static let instance = userCredentials()
//        }
//        return Static.instance
//    }
//
//}
//
//class userRequestsController{
//    let manager = Alamofire.Manager.sharedInstance
//    func authUser(email: String,
//        password: String) {
//            let URL:String = (rootURL + "/api/users/login")
//            
//            // JSON Body
//            let bodyParameters = [
//                "email": email,
//                "password": password
//            ]
//            
//            let encoding = Alamofire.ParameterEncoding.JSON
//            manager.request(.POST, URL, parameters: bodyParameters, encoding: encoding)
//                .validate(statusCode: 200..<401)
//                .responseJSON {(request, response, json, error) in
//                    if let anError = error
//                    {
//                        println("Couldn't log in")
//                        println(error)
//                        userCredentials.sharedInstance.clearKeychain()
//                    }
//                    else if let json: AnyObject = json
//                    {
//                        let parsed = JSON(json)
//                        println("Logged in \(email) successfully")
//                        println(parsed.rawString())
//                        
//                        userCredentials.sharedInstance.setUser(email, password: password, id:parsed["userid"].string!, token: parsed["session_id"].string!)
//                        appDel.checkLogin()
//                    }
//            }
//            
//    }
//
//    
//    func requestLogout(){
//        let URL:String = (rootURL + "/api/users/logout")
//        manager.session.configuration.HTTPAdditionalHeaders = [
//            "Authorization": userCredentials.sharedInstance.getToken()
//        ]
//        // JSON Body
//        let bodyParameters = []
//        let encoding = Alamofire.ParameterEncoding.JSON
//        manager.request(.DELETE, URL, encoding: encoding)
//            .validate(statusCode: 200..<401)
//            .responseJSON {(request, response, json, error) in
//                if let anError = error
//                {
//                    println("Couldn't get your user")
//                    println(error)
//                }
//                else if let json: AnyObject = json
//                {
//                    let parsed = JSON(json)
//                    println("Got the user")
//                }
//        }
//    }
//
//    
//    func createUser(name: String,
//                    username: String,
//                    password: String,
//                    email: String) {
//        let URL:String = (rootURL + "/api/users")
//            // JSON Body
//        let bodyParameters = [
//                "username": username,
//                "password": password,
//                "email": email,
//                "name": name
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
//                  username: String,
//                  email: String) {
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
//        manager.session.configuration.HTTPAdditionalHeaders = [
//            "Authorization": userCredentials.sharedInstance.getToken()
//        ]
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
//    
//    class var sharedInstance: userRequestsController{
//        struct Static {
//            static let instance = userRequestsController()
//        }
//        return Static.instance
//    }
//}