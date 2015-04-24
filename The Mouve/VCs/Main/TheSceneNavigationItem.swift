//
//  TheSceneNavigationItem.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/23/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class TheSceneNavigationItem: UINavigationItem {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleView = SceneTitleView(frame: CGRect(x: 0, y: 0, width: 180, height: 44))
    }
}