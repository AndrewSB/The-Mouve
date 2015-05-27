//
//  AddMouveViewController.swift
//  The Mouve
//
//  Created by Samuel Ojogbo on 5/25/15.
//  Copyright (c) 2015 Samuel Ojogbo. All rights reserved.
//

//import UIKit
//
//class AddMouveViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

import UIKit
import Parse
import Toucan

class AddMouveViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate {
    @IBOutlet weak var titleEventTextField: UnderlinedTextField!
    @IBOutlet weak var detailInfoTextField: UnderlinedTextField!
    @IBOutlet weak var locationTextField: UnderlinedTextField!
    @IBOutlet weak var postMouveButton: UIButton!
    @IBOutlet weak var eventImageButton: UIButton?
    var imagePicker: UIImagePickerController?=UIImagePickerController()
    var popoverMenu: UIPopoverController?=nil
    
    let newMouve = PFObject(className: "mouveEvent")

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var eventPic = self.eventImageButton?.currentBackgroundImage
        self.eventImageButton?.setBackgroundImage(circleMyImage(eventPic!), forState: .Normal)
        setupForEntry(postMouveButton)
    }
    
    //    Using Toucan to circle the images
    func circleMyImage(currentImage: UIImage) -> UIImage{
        var roundedEventPic = Toucan(image: currentImage).resize(CGSize(width: 210, height: 210), fitMode: Toucan.Resize.FitMode.Crop).maskWithEllipse()
        return roundedEventPic.image
        //        return currentImage
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
    func imagePickerController(imagePicker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!)
    {
        imagePicker! .dismissViewControllerAnimated(true, completion: nil)
        var pickedPic = info[UIImagePickerControllerOriginalImage] as! UIImage
        println("Circling "+pickedPic.description);
        eventImageButton?.setBackgroundImage(circleMyImage(pickedPic), forState: .Normal)
        //sets the selected image to image view
    }
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController)
    {
        imagePicker .dismissViewControllerAnimated(true, completion: nil)
        println("picker cancel.")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//
//
    @IBAction func postMouveButtonWasHit(sender: AnyObject) {
        newMouve["title"]    = titleEventTextField.text
        newMouve["detail"]   = detailInfoTextField.text
        newMouve["location"] = locationTextField.text
        newMouve.pinInBackground()
        newMouve.saveEventually()

//        Figure out how to segue
//        performSegueWithIdentifier("segueToDetail", sender: self)
    }
}
