//
//  UIImageExtension.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 6/21/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

extension UIImage {
    func compressed(percent: CGFloat) -> UIImage {
        let newWidth = self.size.width * percent/100
        let newHeight = self.size.height * percent/100
        
        return self.compressedAtScale(CGSize(width: newWidth, height: newHeight))
    }
    
    func compressedAtScale(scale: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(scale)
        self.drawInRect(CGRect(origin: .zeroPoint, size: scale))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return compressedImage;
    }
}