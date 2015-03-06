//
//  TutorialViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 3/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    var pageIndex = Int()
    var hasSegued = false
    var haveTriedOnce = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("inited")
        
    }

    @IBAction func goButtonWasHit(sender: AnyObject) {
        let s = UIStoryboard(name: "Main", bundle: nil)
        self.presentViewController(s.instantiateInitialViewController() as UINavigationController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
