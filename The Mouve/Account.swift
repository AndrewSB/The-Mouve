import UIKit
import Alamofire
import KeychainAccess
import JLToast

class Account: UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 61/255.0, green: 130/255.0, blue: 224/255.0, alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.title = "Welcome to Fyshbowl"
    }
    
    //When sign up is clicked, send to server
    @IBAction func clickedSignUpButton(sender: AnyObject) {
        self.view.endEditing(true)
        if(usernameField.text=="") {
            JLToast.makeText("Username Field Blank",duration: JLToastDelay.LongDelay).show()
            return
        }
        if(!Reachability.isConnectedToNetwork()) {
            JLToast.makeText("No Internet Connection",duration: JLToastDelay.LongDelay).show()
            return
        }
        signUpButton.enabled = false
        signUpButton.setTitle("Joining", forState: UIControlState.Disabled)
        createAccount()
    }
    
    //Touch outside of controls closes keyboard
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //Handles user hitting "Send" on keyboard
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n") {
            textField.resignFirstResponder()
            if(usernameField.text != "") {
                if(!Reachability.isConnectedToNetwork()) {
                    JLToast.makeText("No Internet Connection",duration: JLToastDelay.LongDelay).show()
                    return false
                }
                signUpButton.enabled = false
                signUpButton.setTitle("Joining", forState: UIControlState.Disabled)
                createAccount()
            }
            else {
                JLToast.makeText("Username Field Blank",duration: JLToastDelay.LongDelay).show()
            }
            return false
        }
        if(countElements(textField.text!) + countElements("\(string)") - range.length > 15) {
            return false
        }
        return true
    }
    
    //Sends the username and password to server
    func createAccount() {
        var usernamesDict = NSMutableDictionary()
        defaults.setObject(usernamesDict, forKey: "usernamesDict")
        let parameters = [
            "username": "\(usernameField.text)",
            "password1": "\(deviceID)",
            "password2": "\(deviceID)"
        ]
        Alamofire.request(.POST, rootURL+"/auth/",parameters: parameters)
            .response {(request, response, data, error) in
                let usernameNSData = data as NSData
                let usernameString = NSString(data: usernameNSData, encoding: NSUTF8StringEncoding)
                if(self.usernameIsTaken(data!)) {
                    self.tellUserNameIsTaken()
                }
                else {
                    self.getApiToken()
                }
        }
    }
    
    func tellUserNameIsTaken() {
        JLToast.makeText("Username Taken",duration: JLToastDelay.LongDelay).show()
        self.signUpButton.enabled = true
        self.signUpButton.setTitle("Join", forState: UIControlState.Normal)
    }

    //Requests token from server
    func getApiToken() {
        let parameters = ["username": "\(usernameField.text)","password": "\(deviceID)"]
        Alamofire.request(.POST, rootURL + "/auth/login/",parameters: parameters)
            .response {(request, response, data, error) in
                let tokenNSData = data as NSData
                let tokenString = NSString(data: tokenNSData, encoding: NSUTF8StringEncoding)
                let tokenJSONData = tokenString?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                let tokenJSONObject = JSON(data: tokenJSONData!)
                let token = tokenJSONObject["key"].stringValue
                createUser(self.usernameField.text, deviceID, token)
                self.getUserID()
        }
    }
    
    //Checks if username is unique
    func usernameIsTaken(data: AnyObject) -> Bool {
        let usernameNSData = data as NSData
        let usernameString = NSString(data: usernameNSData, encoding: NSUTF8StringEncoding)
        let usernameJSONData = usernameString?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let usernameJSONObject = JSON(data: usernameJSONData!)
        let response = usernameJSONObject["username"].stringValue
        if(response == "This username is already taken. Please choose another.") {
            return true
        }
        return false
    }
    
    func sendZeroPushTokenToServer() {
        var parameters = ["token": ""]
        if let token = keychain["zero-push-token"] {
            parameters = ["user":getUserLink(), "token":token, "device_type":"0"]
        }
        let request = getHTTPPostRequest("/Push/", parameters)
        Alamofire.request(request)
            .response {(request, response, data, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.goToApp()
                }
        }
    }
    
    func getUserID() {
        let request = getHTTPGetRequest("/Users/", true)
        Alamofire.request(request)
            .response {(request, response, data, error) in
                let users = getJSONFromData(data!)
                self.getUserLinkFromData(users)
        }
    }
    
    func getUserLinkFromData(users: JSON) {
        for var index = 0; index < users.count; ++index {
            let user = users[index]
            let username = user["username"].stringValue
            if(username == getUsername()) {
                let userID = user["id"].stringValue
                keychain["user-link"] = rootURL + "/Users/\(userID)/"
                sendZeroPushTokenToServer()
                return
            }
        }
    }
    
    //Dismisses login screen, goes to main screen
    func goToApp() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
