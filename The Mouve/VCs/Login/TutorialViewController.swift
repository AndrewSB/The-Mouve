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
        
    var pageImage: UIImage = UIImage()
    var pageIndex: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidAppear(false)
        
        let imageSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + 50)
                
        let originX = UIDevice.currentDevice().model == "iPad" ? 0 : 15
        
        let backgroundImage = UIImageView(frame: CGRect(origin: CGPoint(x: originX, y: 0), size: imageSize))
        backgroundImage.image = pageImage
        backgroundImage.contentMode = .ScaleAspectFill
        
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        pageLabel.text = title
//        pageLabel.frame.origin.x = 44
//        pageLabel.frame.size.width = view.bounds.width - 88
    }
    
    @IBAction func unwindToTutorialVC(segue: UIStoryboardSegue) {}
}
