//
//  SignupViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse
import Toucan

class SignupViewController: UIViewController {
    @IBOutlet weak var nameTextField: UnderlinedTextField!
    @IBOutlet weak var usernameTextField: UnderlinedTextField!
    @IBOutlet weak var passwordTextField: UnderlinedTextField!
    @IBOutlet weak var emailTextField: UnderlinedTextField!

    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var facebookBtn: UIButton!
    

    var imagePicker: UIImagePickerController?=UIImagePickerController()
    var popoverMenu: UIPopoverController?=nil
    var pickedPic: UIImage?
    var imagePicked:Bool?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        statusBar(.Default)
        addTextDismiss()
        addNavControllerLikePan()
        
//        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = ((createAccountButton.frame.origin.y + createAccountButton.frame.height) - nameTextField.frame.origin.y) + 5
        
        [nameTextField, usernameTextField, passwordTextField, emailTextField].map({ $0.delegate = self })
        self.profileImageButton!.layer.cornerRadius = self.profileImageButton!.frame.height / 2
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBoolValues()

    }
    func setBoolValues(){
        self.imagePicked = false
    }


    @IBAction func createAccountButtonWasHit(sender: AnyObject) {
        
        var fullName = nameTextField.text
        var username = usernameTextField.text
        var password = passwordTextField.text
        var email = emailTextField.text!.lowercaseString
        
        
        if fullName != "" && username != "" && password != "" && email != ""{
            userSignUp()
        } else {
            print("All Fields Required")
        }
        
        
//
//        persistentData.sharedInstance.registerUser(
//            nameTextField.text,
//            username:usernameTextField.text,
//            email: emailTextField.text,
//            password: passwordTextField.text,
//            authToken: "demo",
//            image: "http://google.com/")
//ß
    }
    
    @IBAction func facebookButtonWasHit(sender: AnyObject) {
        let loginManager: Void = FBSDKLoginManager().logInWithReadPermissions(["public_profile"], handler: { (result, error) in
            if error != nil {
                self.presentViewController(UIAlertController(title: "Whoops!", message: error!.localizedDescription), animated: true, completion: nil)
                
            } else if result.isCancelled {
                
                self.presentViewController(UIAlertController(title: "Whoops!", message: "We couldn't access facebook! Did you hit cancel?"), animated: true, completion: nil)
            } else {
                
                if((FBSDKAccessToken.currentAccessToken()) != nil){
                    FBSDKGraphRequest(graphPath: "me", parameters:["fields":"email,name"]).startWithCompletionHandler({ (connection, result, error) in
                        if error != nil {
                            self.presentViewController(UIAlertController(title: "Whoops!", message: error!.localizedDescription), animated: true, completion: nil)
                        } else {
                            if let loginResult = result as? Dictionary<String,AnyObject> {
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let emailID = loginResult["email"] as? String{
                                        self.emailTextField.text = emailID
                                    }
                                    self.nameTextField.text = loginResult["name"] as! String
                                    let userID = loginResult["id"] as! String
                                    let facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
                                    let url = NSURL(string:facebookProfileUrl)
                                    self.imagePicked = true
                                    self.downloadImage(url!)
                                })
                            }
                        }
                    })
                    
                }
                
                // self.nameTextField.text = FBSDKProfile.currentProfile().name
                //
                //                    persistentData.sharedInstance.fbRegister(self.usernameTextField.text, email: self.emailTextField.text, fbId: FBSDKAccessToken.currentAccessToken().userID, name: self.nameTextField.text)
            }
        })
    }
    
    func downloadImage(url:NSURL){
        print("Started downloading \"\(url.URLByDeletingPathExtension?.URLString)\".")
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                print("Finished downloading \"\(url.URLByDeletingPathExtension?.URLString)\".")
                self.profileImageButton?.setBackgroundImage(self.circleMyImage(UIImage(data: data!)!), forState: .Normal)
            }
        }
    }
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    @IBAction func changeProfileImageClicked(sender: AnyObject) {
        
        imagePicker!.delegate = self
        print("Popped up..")
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.openCamera()
            
        }
        let gallaryAction = UIAlertAction(title: "Choose Existing Photo", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popoverMenu=UIPopoverController(contentViewController: alert)
            popoverMenu!.presentPopoverFromRect(profileImageButton!.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePicker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(imagePicker!, animated: true, completion: nil)
        }
        else
        {
            popoverMenu=UIPopoverController(contentViewController: imagePicker!)
            popoverMenu!.presentPopoverFromRect(profileImageButton!.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.pickedPic = info[UIImagePickerControllerOriginalImage] as? UIImage
        print("Circling "+pickedPic!.description);
        self.profileImageButton?.setBackgroundImage(circleMyImage(pickedPic!), forState: .Normal)
        self.imagePicked = true
        //sets the selected image to image view
    }
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController)
    {
        imagePicker .dismissViewControllerAnimated(true, completion: nil)
        print("picker cancel.")
    }
    
    @IBAction func backButtonWasHit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        view.endEditing(true)
    }
//    func usernameSuggester(fullname: String){
//        var fullNameArr = split(fullname) {$0 == " "}
//        var firstName: String = fullNameArr[0]
//        var lastName: String? = fullNameArr.count > 1 ? fullNameArr[-1] : nil
//        let username = firstName+lastName!
//        return username.lowercaseString
//    }
    func userSignUp() {
        let newUser = PFUser()
        let loadingSpinnerView = addLoadingView()
        view.addSubview(loadingSpinnerView)
        
        newUser["fullName"] = nameTextField.text
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        newUser.email = emailTextField.text!.lowercaseString
        if(self.imagePicked == true){
            var image = profileImageButton!.backgroundImageForState(.Normal)!
            var imageWithName:PFFile = PFFile(name: "profileImage.png", data:UIImagePNGRepresentation(image)!)
            imageWithName.saveInBackground();
            newUser["profileImage"] = imageWithName
        }
        newUser.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                self.presentViewController(UIAlertController(title: "Uh oh!", message: errorString as! String), animated: true, completion: nil)
                
                //loadingSpinnerView.removeFromSuperview()
                
                appDel.checkLogin()
            }else{
                PFUser.logInWithUsernameInBackground(newUser.username! , password: newUser.password!, block: { (user, error) in
                    if user != nil {
                        print("dun logged in")
                        
                        //loadingSpinnerView.removeFromSuperview()
                        
                        appDel.checkLogin()
                    } else {
                        if let error = error {
                            self.view.userInteractionEnabled = true
                            let errorString = error.userInfo["error"] as? NSString
                            self.presentViewController(UIAlertController(title: "Uh oh!", message: errorString as! String), animated: true, completion: nil)
                            
                            //loadingSpinnerView.removeFromSuperview()
                            
                            appDel.checkLogin()
                        }
                    }
                })
            }
            
        }

        
    }

}
extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //    Using Toucan to circle the images
    func circleMyImage(currentImage: UIImage) -> UIImage{
        let croppedEventPic = Toucan(image: currentImage).resize(CGSize(width: profileImageButton!.frame.width, height: profileImageButton!.frame.height), fitMode: Toucan.Resize.FitMode.Crop).image
        
        let roundedEventPic = Toucan(image: croppedEventPic).resize(CGSize(width: 210, height: 210), fitMode: Toucan.Resize.FitMode.Crop).maskWithEllipse()
        return roundedEventPic.image
    }
}
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            nameTextField.resignFirstResponder()
            usernameTextField.becomeFirstResponder()
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
            createAccountButtonWasHit(self)
        default: ()
        }
        
        return true
    }
}