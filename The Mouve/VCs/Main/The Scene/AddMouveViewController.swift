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
    
    // will result in a race condition. REFACTOR later
    var compressedImage: (UIImage?, NSData?) {
        didSet {
            compressedImage.1 = UIImageJPEGRepresentation(compressedImage.0, 0.7)
        }
    }

    let rangeSlider = TimeRangeSlider()
    
    var imagePicker: UIImagePickerController?=UIImagePickerController()
    var popoverMenu: UIPopoverController?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextDismiss()
        
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 200
        
        [titleEventTextField, detailInfoTextField, locationTextField].map({ $0.delegate = self })
        
        rangeSlider.frame = CGRect(x: 40, y: startTime!.frame.origin.y - 35, width: view.frame.width - 80, height: 31)
        rangeSlider.trackHighlightTintColor = UIColor.seaFoamGreen()
        rangeSlider.trackTintColor = UIColor.lightNicePaleBlue()
        rangeSlider.curvaceousness = 0.2
        rangeSlider.thumbThicknessPercent = 0.3
        rangeSlider.thumbTintColor = UIColor.seaFoamGreen()
        
        self.view.addSubview(rangeSlider)
        
        eventImageButton!.layer.cornerRadius = eventImageButton!.frame.height / 2

        
        publicPrivateSwitch.tintColor = UIColor.lightSeaFoamGreen()
        publicPrivateSwitch.onTintColor = UIColor.lightSeaFoamGreen()
        publicPrivateSwitch.thumbTintColor = UIColor.seaFoamGreen()
        
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        statusBar(.LightContent)
        rangeSlider.lowerValue = 2.5
        rangeSliderValueChanged(rangeSlider)
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
    }

    @IBAction func postMouveButtonWasHit(sender: AnyObject) {
//        let newMouve = Event(name: titleEventTextField.text, about: "", time: NSDate(timeInterval: 80, sinceDate: NSDate()), length: 100, address: locationTextField.text, invitees: ["lol"], backgroundImage: eventImageButton!.backgroundImageForState(.Normal)!)
                    println("current events num:\(RealmStore.sharedInstance.mouveArray.count)")
        RealmStore.sharedInstance.addMouve(titleEventTextField.text, details: "", image: "http://google.com", startTime: NSDate(), endTime: NSDate(timeIntervalSinceNow: 10))
            println("event created success:\(RealmStore.sharedInstance.mouveArray.count)")

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
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.openCamera()
            
        }
        var gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default){
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
        var pickedPic = info[UIImagePickerControllerOriginalImage] as! UIImage

        compressedImage.0 = pickedPic
        
        eventImageButton?.setBackgroundImage(circleMyImage(pickedPic), forState: .Normal)
        //sets the selected image to image view
    }
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController)
    {
        imagePicker .dismissViewControllerAnimated(true, completion: nil)
        println("picker cancel.")
    }
}

extension AddMouveViewController: UITextFieldDelegate {
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
