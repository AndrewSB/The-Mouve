//
//  MouveDetailPageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 3/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class MouveDetailPageViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    @IBOutlet weak var friendScrollView: UIScrollView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContent()

        let tap = UITapGestureRecognizer(target: self, action: "toggleShow")
        webView.addGestureRecognizer(tap)
    }
    
    func toggleShow(sender:UITapGestureRecognizer) {
        println("hit")
    }
    
    func setContent() {
        var filePath = NSBundle.mainBundle().pathForResource("IMG_1962", ofType: "gif")
        var gif = NSData(contentsOfFile: filePath!)
        
        webView.loadData(gif, MIMEType: "image/gif", textEncodingName: nil, baseURL: nil)

    }

    
    func toggleShowHUD(hide: Bool) {
        let elements = [backButton, titleLabel, timeLabel, detailLabel, friendScrollView]
        
        for i in elements {
            i.hidden = hide
        }
    }
    
    @IBAction func backButtonWasHit(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}


