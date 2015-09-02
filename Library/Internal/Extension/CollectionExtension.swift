//
//  CollectionExtension.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 6/21/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> Element {
        let randomElement = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomElement]
    }
}