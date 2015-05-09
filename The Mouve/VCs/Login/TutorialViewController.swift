//
//  TutorialViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class TutorialViewController: UIViewController {
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageLabelWidthConstraint: NSLayoutConstraint!
        
    var pageImage: UIImage = UIImage()
    var pageIndex: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + 50)
        let imageOrigin = CGPoint(x: UIDevice.currentDevice().model == "iPad" ? 0 : 14, y: 0)
        
        let backgroundImage = UIImageView(frame: CGRect(origin: imageOrigin, size: imageSize))
        backgroundImage.image = pageImage
        backgroundImage.contentMode = .ScaleAspectFill
        
        self.view.insertSubview(backgroundImage, atIndex: 0)
 
        pageLabel.text = title
        pageLabelWidthConstraint.constant = self.view.frame.width - 88
    }
    
    @IBAction func unwindToTutorialVC(segue: UIStoryboardSegue) {}
}
