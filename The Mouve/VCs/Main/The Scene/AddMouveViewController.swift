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
        
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 150
        
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
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: 40, y: startTime!.frame.origin.y - 35, width: view.frame.width - 80, height: 31)
    }
    
    // Changes labels as you drag slider
    func rangeSliderValueChanged(rangeSlider: TimeRangeSlider) {
        var currentTimes = rangeSlider.timeValues()
        startTime!.text = currentTimes.startVal
        endTime!.text = currentTimes.endVal
    }
    
    
    //  Switch to toggle between public and private
    @IBOutlet weak var publicPrivateSwitch: UISwitch!
    @IBOutlet weak var publicPrivateLabel: UILabel!
    
    @IBAction func flipSwitch(sender: AnyObject) {
        publicPrivateLabel.text = publicPrivateSwitch.on ? "Private" : "Public"
        var buttonLabel = publicPrivateSwitch.on ? "Invite People" : "Create Mouve"
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
        
            newMouve.name  = titleEventTextField.text
            newMouve.about = detailInfoTextField.text
            newMouve.startTime = NSDate()
            newMouve.endTime = NSDate()
            newMouve.address = locationTextField.text
//            location UserDefaults.lastLocation,
            newMouve.privacy = publicPrivateSwitch.on
            newMouve.backgroundImage = PFFile(data:UIImageJPEGRepresentation(pickedPic!,1.0))
        
        newMouve.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                self.presentViewController(UIAlertController(title: "Uh oh!", message: errorString as! String), animated: true, completion: nil)
            }
            self.presentViewController(TheScenePageViewController(), animated: true, completion: nil)
        }
        
        
//        println("current events num:\(persistentData.sharedInstance.mouveArray.count)")
//        persistentData.sharedInstance.addMouve(titleEventTextField.text, details: "", image: "http://google.com", startTime: NSDate(), endTime: NSDate(timeIntervalSinceNow: 10))
//            println("event created success:\(persistentData.sharedInstance.mouveArray.count)")

//        newMouve.location = UserDefaults.lastLocation!
        
//        let remoteMouve = PFObject(event: newMouve)
//        remoteMouve.saveInBackground()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AddMouveViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //    Using Toucan to circle the images
    func circleMyImage(currentImage: UIImage) -> UIImage{
        var roundedEventPic = Toucan(image: currentImage).resize(CGSize(width: 210, height: 210), fitMode: Toucan.Resize.FitMode.Crop).maskWithEllipse()
        return roundedEventPic.image
    }
    //  Open Photo Library to upload photo (some code from theappguruz)
    
    @IBAction func switchImageMenu(sender: AnyObject)
    {
        imagePicker!.delegate = self
        println("Popped up..")
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.openCamera()
            
        }
        var gallaryAction = UIAlertAction(title: "Choose Existing Photo", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.openGallary()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){
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
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.pickedPic = info[UIImagePickerControllerOriginalImage] as? UIImage
        println("Circling "+pickedPic!.description);
        eventImageButton?.setBackgroundImage(circleMyImage(pickedPic!), forState: .Normal)
        //sets the selected image to image view
    }
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController)
    {
        imagePicker .dismissViewControllerAnimated(true, completion: nil)
        println("picker cancel.")
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
        println(place.description)
        
        place.getDetails { details in
            self.locationTextField.text = details.name
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}