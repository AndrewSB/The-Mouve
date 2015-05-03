//
//  UIViewControllerExtension.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func initVC(vcID: String, storyboard: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewControllerWithIdentifier(vcID) as! UIViewController
    }
}