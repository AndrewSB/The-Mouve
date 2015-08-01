import UIKit
import KeychainAccess
import Alamofire
import SwiftyJSON


class userCredentials {
    let keychain = Keychain(service: "tm.The-Mouve")
    
    func getEmail() -> String? {
        return keychain["email"]
    }
    func getPassword() -> String? {
        return keychain["password"]
    }
    
    
    func getToken() -> String? {
        return keychain["token"]
    }
    
    
    func getUserId() -> String? {
        return keychain["userid"]
    }
    
    
    func logUserOut() {
        userRequestsController.sharedInstance.requestLogout()
    }
    
    func clearKeychain() {
        keychain.remove("email")
        keychain.remove("password")
        keychain.remove("token")
        keychain.remove("userid")
    }
    
    func setUser(email: String,password: String, id:String, token: String) {
        keychain["email"] = email
        keychain["password"] = password
        keychain["token"] = token
        keychain["userid"] = id
    }
    

    class var sharedInstance: userCredentials{
        struct Static {
            static let instance = userCredentials()
        }
        return Static.instance
    }

}

class userRequestsController{
    static let sharedInstance = userRequestsController()
    let manager = Alamofire.Manager.sharedInstance
    func authUser(email: String,
        password: String) {
            let URL:String = (rootURL + "/api/users/login")
            
            // JSON Body
            let bodyParameters = [
                "email": email,
                "password": password
            ]
            
            let encoding = Alamofire.ParameterEncoding.JSON
            manager.request(.POST, URL, parameters: bodyParameters, encoding: encoding)
                .validate(statusCode: 200..<401)
                .responseJSON {(request, response, json, error) in
                    if let anError = error
                    {
                        println("Couldn't log in")
                        println(error)
                        userCredentials.sharedInstance.clearKeychain()
                    }
                    else if let json: AnyObject = json
                    {
                        let parsed = JSON(json)
                        println("Logged in \(email) successfully")
                        println(parsed.rawString())
                        
                        userCredentials.sharedInstance.setUser(email, password: password, id:parsed["userid"].string!, token: parsed["session_id"].string!)
                        appDel.checkLogin()
                    }
            }
            
    }

    
    func requestLogout(){
        let URL:String = (rootURL + "/api/users/logout")
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": userCredentials.sharedInstance.getToken()
        ]
        // JSON Body
        let bodyParameters = []
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.DELETE, URL, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println("Couldn't get your user")
                    println(error)
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                    println("Got the user")
                    userCredentials.sharedInstance.clearKeychain()
                    appDel.checkLogin()
                }
        }
    }

    
    func createUser(name: String,
                    username: String,
                    password: String,
                    email: String,
                    fbId: String) {
        let URL:String = (rootURL + "/api/users")
            // JSON Body
        let bodyParameters = [
                "username": username,
                "password": password,
                "email": email,
                "name": name,
                "misc": (fbId.isEmpty) ? ["null"]:["fbId":fbId]
            ]
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.POST, URL, parameters: bodyParameters, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println("Couldn't register user")
                    println(error)
                    userCredentials.sharedInstance.clearKeychain()
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                    println("Registered in \(email) successfully")
                    self.authUser(email, password: password)
                }
            }
        }

        
    func getMe() {
        let URL:String = (rootURL + "/api/users")
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": userCredentials.sharedInstance.getToken()
        ]
        // JSON Body
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.GET, URL, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println("Couldn't update user")
                    println(error)
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                }
            }
    }


    
    func updateMe(name: String,
        username: String,
        email: String) {
            let URL:String = (rootURL + "/api/users")
            manager.session.configuration.HTTPAdditionalHeaders = [
                "Authorization": userCredentials.sharedInstance.getToken()
            ]
            // JSON Body
            let bodyParameters = [
                "username": username,
                "email": email,
                "name": name
            ]
            let encoding = Alamofire.ParameterEncoding.JSON
            manager.request(.PUT, URL, parameters: bodyParameters, encoding: encoding)
                .validate(statusCode: 200..<401)
                .responseJSON {(request, response, json, error) in
                    if let anError = error
                    {
                        println("Couldn't update user")
                        println(error)
                    }
                    else if let json: AnyObject = json
                    {
                        let parsed = JSON(json)
                        println("Updated \(email) successfully")
                    }
            }
    }
    
    func followUser(id: String) {
        
        let URL = NSURL(string: rootURL + "/api/users/\(id)/follow")!
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": userCredentials.sharedInstance.getToken()
        ]
        // JSON Body
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.POST, URL, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println(error)
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                }
        }
    }
    
    func unfollowUser(id: String) {
        let URL = NSURL(string: rootURL + "/api/users/\(id)/unfollow")!
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": userCredentials.sharedInstance.getToken()
        ]
        // JSON Body
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.DELETE, URL, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println(error)
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                }
        }
    }
    
    func getFollowers(id: String) {
        let URL = NSURL(string: rootURL + "/api/users/\(id)/followers")!
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": userCredentials.sharedInstance.getToken()
        ]
        // JSON Body
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.GET, URL, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println(error)
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                }
        }
    }
    
    func getFollowees(id: String) {
        let URL:String = rootURL + "/api/users/\(id)/following"
        manager.session.configuration.HTTPAdditionalHeaders = [
        "Authorization": userCredentials.sharedInstance.getToken()
        ]
        // JSON Body
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.GET, URL, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println(error)
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                }
        }
    }
}