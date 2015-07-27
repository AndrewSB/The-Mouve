import UIKit
import KeychainAccess
import Alamofire
import SwiftyJSON


class userCredentials{
    let keychain = Keychain(service: "tm.The-Mouve")
    let deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
//    let defaults = NSUserDefaults.standardUserDefaults()
    
    func getUsername() -> String {
        if let username = keychain["username"] {
            return username
        }
        return "Anonymous"
    }
    func getPassword() -> String {
        if let password = keychain["password"] {
            return password
        }
        return "Password"
    }
    
    
    func getToken() -> String {
        if let token = keychain["token"] {
            return token
        }
        return "Token"
    }
    
    
    func getUserId() -> String {
        if let userLink = keychain["userid"] {
            return userLink
        }
        return "NA"
    }
    
    
    func logUserOut() {
        userRequestsController.sharedInstance.requestLogout()
    }
    
    func clearKeychain() {
        keychain.remove("username")
        keychain.remove("password")
        keychain.remove("token")
//        keychain.remove("userid")
    }
    
    func setUser(username: String,password: String,token: String) {
        keychain["username"] = username
        keychain["password"] = password
        keychain["token"] = token
//        var usernamesDict = NSMutableDictionary()
//        defaults.setObject(usernamesDict, forKey: "usernamesDict")
    }
    

    class var sharedInstance: userCredentials{
        struct Static {
            static let instance = userCredentials()
        }
        return Static.instance
    }

}

class userRequestsController{
    
    func requestLogout(){
        let URL = NSURL(string: rootURL + "/api/users/logout")!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "DELETE"
        request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        let encoding = Alamofire.ParameterEncoding.JSON
        // Fetch Request
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON {(request, response, data, error) in
                if let anError = error
                {
                    println("error calling POST on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    let parsed = JSON(data)
                }
        }
        
    }

    
    func createUser(name: String,
                    username: String,
                    password: String,
                    email: String) {
        let URL = NSURL(string: rootURL + "/api/users")!
        var request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = "POST"
            // JSON Body
        let bodyParameters = JSON([
                "username": username,
                "password": password,
                "email": email,
                "name": name
            ])
            request.HTTPBody = bodyParameters.rawData()
        let encoding = Alamofire.ParameterEncoding.JSON
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON {(request, response, data, error) in
                if let anError = error
                {
                    println("error calling POST on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    let parsed = JSON(data)
                    println("Registered \(username) successfully")
                }
        }
    
    }

        
    func getMe() {
        let URL = NSURL(string: rootURL + "/api/users")!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        let encoding = Alamofire.ParameterEncoding.JSON
        // Fetch Request
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON {(request, response, data, error) in
                if let anError = error
                {
                    println("error calling POST on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    let parsed = JSON(data)
                }
            }
        
        }
    
    func updateMe(name: String,
        username: String,
        email: String) {
            let URL = NSURL(string: rootURL + "/api/users")!
            var request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = "PUT"
            request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")

            // JSON Body
            let bodyParameters = JSON([
                "username": username,
                "email": email,
                "name": name
            ])
            request.HTTPBody = bodyParameters.rawData()
            let encoding = Alamofire.ParameterEncoding.JSON
            Alamofire.request(request)
                .validate(statusCode: 200..<300)
                .responseJSON {(request, response, data, error) in
                    if let anError = error
                    {
                        println("error calling POST on /posts")
                        println(error)
                    }
                    else if let data: AnyObject = data
                    {
                        let parsed = JSON(data)
                    }
            }
            
    }
    
    func followUser(id: String) {
        let URL = NSURL(string: rootURL + "/api/users/\(id)/follow")!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        let encoding = Alamofire.ParameterEncoding.JSON
        // Fetch Request
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON {(request, response, data, error) in
                if let anError = error
                {
                    println("error calling POST on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    let parsed = JSON(data)
                }
        }
        
    }
    
    func unfollowUser(id: String) {
        let URL = NSURL(string: rootURL + "/api/users/\(id)/unfollow")!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "DELETE"
        request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        let encoding = Alamofire.ParameterEncoding.JSON
        // Fetch Request
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON {(request, response, data, error) in
                if let anError = error
                {
                    println("error calling POST on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    let parsed = JSON(data)
                }
        }
        
    }
    
    func getFollowers(id: String) {
        let URL = NSURL(string: rootURL + "/api/users/\(id)/followers")!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        let encoding = Alamofire.ParameterEncoding.JSON
        // Fetch Request
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON {(request, response, data, error) in
                if let anError = error
                {
                    println("error calling POST on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    let parsed = JSON(data)
                }
        }
        
    }
    
    func getFollowees(id: String) {
        let URL = NSURL(string: rootURL + "/api/users/\(id)/following")!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        let encoding = Alamofire.ParameterEncoding.JSON
        // Fetch Request
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON {(request, response, data, error) in
                if let anError = error
                {
                    println("error calling POST on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    let parsed = JSON(data)
                }
        }
        
    }
    
    func authUser(email: String,
                  password: String) {
            let URL = NSURL(string: rootURL + "/api/users/login")!
            var request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = "POST"
            // JSON Body
            let bodyParameters = JSON([
                "email": email,
                "password": password
                ])
            request.HTTPBody = bodyParameters.rawData()
            let encoding = Alamofire.ParameterEncoding.JSON
            println(request.HTTPBody)
            Alamofire.request(request)
//                .validate(statusCode: 200..<300)
                .responseJSON {(request, response, data, error) in
                    if let anError = error
                    {
                        println("Couldn't log in")
                        println(error)
                        userCredentials.sharedInstance.clearKeychain()
                    }
                    else if let data: AnyObject = data
                    {
                        let parsed = JSON(data)
                        println("Registered \(email) successfully")
                        println("Received Token: "+parsed["session_id"].string!)
                        println(parsed.rawString())
                        userCredentials.sharedInstance.setUser(email, password: password, token: parsed["session_id"].string!)
                        appDel.checkLogin()
                    }
            }
            
    }
    
    class var sharedInstance: userRequestsController{
        struct Static {
            static let instance = userRequestsController()
        }
        return Static.instance
    }
}