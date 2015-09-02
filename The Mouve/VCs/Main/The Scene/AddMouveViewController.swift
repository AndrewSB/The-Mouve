//
//  AddMouveViewController.swift
//  The Mouve
//
//  Created by Samuel Ojogbo on 5/25/15.
//  Copyright (c) 2015 Samuel Ojogbo. All rights reserved.
//

import UIKit
import Parse
import Toucan

class AddMouveViewController: UIViewController, UIAlertViewDelegate, UIPopoverControllerDelegate {
    @IBOutlet weak var titleEventTextField: UnderlinedTextField!
    @IBOutlet weak var detailInfoTextField: UnderlinedTextField!
    @IBOutlet weak var locationTextField: UnderlinedTextField!
    @IBOutlet weak var postMouveButton: UIButton!
    @IBOutlet weak var eventImageButton: UIButton?
    @IBOutlet weak var startTime: UILabel?
    @IBOutlet weak var endTime: UILabel?
    var pickedPic: UIImage?
    var pickedPoint: PFGeoPoint?
    var actualAddress: String?

//    let rangeSlider = TimeRangeSlider()
    let rangeSlider = TimeRangeSlider(frame: CGRectZero)


    
    let gpaViewController = GooglePlacesAutocomplete(
        apiKey: "AIzaSyBhSL-vMg7MfAe4kXukMDlGy-nv8UMlOno",
        placeType: .All
    )

    
    var imagePicker: UIImagePickerController?=UIImagePickerController()
    var popoverMenu: UIPopoverController?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextDismiss()
        
//        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 150
        
        [titleEventTextField, detailInfoTextField, locationTextField].map({ $0.delegate = self })
        
        eventImageButton!.layer.cornerRadius = eventImageButton!.frame.height / 2
        
        //Switch color
        publicPrivateSwitch.tintColor = UIColor.lightSeaFoamGreen()
        publicPrivateSwitch.onTintColor = UIColor.lightSeaFoamGreen()
        publicPrivateSwitch.thumbTintColor = UIColor.seaFoamGreen()
        //switch color ends
//        self.locationTextField.becomeFirstResponder()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Time slider
        rangeSlider.trackHighlightTintColor = UIColor.seaFoamGreen()
        rangeSlider.trackTintColor = UIColor.lightNicePaleBlue()
        rangeSlider.curvaceousness = 0.3
        rangeSlider.thumbThicknessPercent = 0.5
        rangeSlider.thumbTintColor = UIColor.seaFoamGreen()
        
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        
        self.view.addSubview(rangeSlider)
        // Time Slider ends
        
        statusBar(.LightContent)
    }
    
    
    // Alignments for the range-slider
    override func viewDidLayoutSubviews() {
//        let margin: CGFloat = 20.0
//        let width = view.bounds.width - 2.0 //* margin
        rangeSlider.frame = CGRect(x: 40, y: startTime!.frame.origin.y - 35, width: view.frame.width - 80, height: 30)
    }
    
    // Changes labels as you drag slider
    func rangeSliderValueChanged(rangeSlider: TimeRangeSlider) {
        let currentTimes = rangeSlider.timeDates()
        startTime!.text = currentTimes.startDate.toShortTimeString()
        endTime!.text = currentTimes.endDate.toShortTimeString()
    }
    
    
    //  Switch to toggle between public and private
    @IBOutlet weak var publicPrivateSwitch: UISwitch!
    @IBOutlet weak var publicPrivateLabel: UILabel!
    
    @IBAction func flipSwitch(sender: AnyObject) {
        publicPrivateLabel.text = publicPrivateSwitch.on ? "Private" : "Public"
        let buttonLabel = publicPrivateSwitch.on ? "Invite People" : "Create Mouve"
        postMouveButton.setTitle(buttonLabel, forState: UIControlState.Normal)
    }
    // Switch ends
    
    
    @IBAction func postMouveButtonWasHit(sender: AnyObject) {
        
//        mouveRequestsController.sharedInstance.createMouve(
//            titleEventTextField.text,
//            details: detailInfoTextField.text,
//            privacy: publicPrivateSwitch.on,
//            startTime: startTime!.text!,
//            endTime: endTime!.text!,
//            location: locationTextField.text)
        let newMouve = Events()
            newMouve.creator = PFUser.currentUser()!
            newMouve.name  = titleEventTextField.text!.uppercaseString
            newMouve.about = detailInfoTextField.text!
            newMouve.address = self.actualAddress!
            newMouve.location = pickedPoint!
            newMouve.startTime = rangeSlider.timeDates().startDate
            newMouve.endTime = rangeSlider.timeDates().endDate
            newMouve.privacy = publicPrivateSwitch.on
        if (newMouve.privacy){
            let eventACL = PFACL(user: newMouve.creator)
            newMouve.ACL = eventACL
        }
            if ((pickedPic) != nil){
                newMouve.backgroundImage = PFFile(name: "bg.jpg", data:UIImageJPEGRepresentation(pickedPic!, 0.7)!)
            }
        
//        let remoteMouve = PFObject(event: newMouve)
        newMouve.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                self.presentViewController(UIAlertController(title: "Uh oh!", message: errorString as! String), animated: true, completion: nil)
                }
            }


        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AddMouveViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //    Using Toucan to circle the images
    func circleMyImage(currentImage: UIImage) -> UIImage{
        let croppedEventPic = Toucan(image: currentImage).resize(CGSize(width: eventImageButton!.frame.width, height: eventImageButton!.frame.height), fitMode: Toucan.Resize.FitMode.Crop).image
        
        let roundedEventPic = Toucan(image: croppedEventPic).resize(CGSize(width: 210, height: 210), fitMode: Toucan.Resize.FitMode.Crop).maskWithEllipse()
        return roundedEventPic.image
    }
    //  Open Photo Library to upload photo (some code from theappguruz)
    
    @IBAction func switchImageMenu(sender: AnyObject)
    {
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
            popoverMenu!.presentPopoverFromRect(eventImageButton!.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
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
            popoverMenu!.presentPopoverFromRect(eventImageButton!.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.pickedPic = info[UIImagePickerControllerOriginalImage] as? UIImage
        print("Circling "+pickedPic!.description);
        eventImageButton?.setBackgroundImage(circleMyImage(pickedPic!), forState: .Normal)
        //sets the selected image to image view
    }
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController)
    {
        imagePicker .dismissViewControllerAnimated(true, completion: nil)
        print("picker cancel.")
    }
}

extension AddMouveViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField){
        
        if textField == locationTextField{
        // Google API for location field
        gpaViewController.placeDelegate = self // Conforms to GooglePlacesAutocompleteDelegate
        
        presentViewController(gpaViewController, animated: true, completion: nil)
        }
        else{
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case titleEventTextField:
            titleEventTextField.resignFirstResponder()
            detailInfoTextField.becomeFirstResponder()
        case detailInfoTextField:
            detailInfoTextField.resignFirstResponder()
            locationTextField.becomeFirstResponder()
        case locationTextField:
            locationTextField.resignFirstResponder()
        default: ()
        }
        
        return true
    }
}
extension AddMouveViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        print(place.description)
        
        place.getDetails { details in
            self.locationTextField.text = details.name
            self.actualAddress = place.description
            self.pickedPoint = PFGeoPoint(latitude: details.latitude, longitude: details.longitude)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    
        
    }
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}