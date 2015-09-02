//
//  UIColorExtension.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func seaFoamGreen() -> UIColor {
        return UIColor.colorWithHexString("#50E3C2")
    }
    class func lightSeaFoamGreen() -> UIColor {
        return UIColor.colorWithHexString("#50E3C2", varAlpha: CGFloat(0.4))
    }
    
    class func nicePaleBlue() -> UIColor {
        return UIColor.colorWithHexString("#4A90E2")
    }
    class func lightNicePaleBlue() -> UIColor {
        return UIColor.colorWithHexString("#4A90E2", varAlpha: CGFloat(0.6))
    }
    
    class func colorWithHexString(hex:String, varAlpha:CGFloat = CGFloat(1.0)) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: varAlpha
        )
    }
}