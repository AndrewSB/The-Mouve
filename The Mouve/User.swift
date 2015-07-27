import UIKit
import KeychainAccess
import Alamofire


class userCredentials{
    let keychain = Keychain(service: "tm.The-Mouve")
    let deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
//    defaults should be replaced with CoreData
    let defaults = NSUserDefaults.standardUserDefaults()
    
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
        keychain.remove("userid")
    }
    
    func createUser(username: String,password: String,token: String) {
        keychain["username"] = username
        keychain["password"] = password
        keychain["token"] = token
        var usernamesDict = NSMutableDictionary()
        defaults.setObject(usernamesDict, forKey: "usernamesDict")
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
        let URL = NSURL(string: rootURL + "/auth/logout/")!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        Alamofire.request(request)
            .response {(request, response, data, error) in
                userCredentials.sharedInstance.clearKeychain()
        }
    }
    class var sharedInstance: userRequestsController{
        struct Static {
            static let instance = userRequestsController()
        }
        return Static.instance
    }
}