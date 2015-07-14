//
//  Users.swift
//  The Mouve
//
//  Created by Hilal Habashi on 7/13/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import RealmSwift


class Mouve: Object {
}

class Person: Object {
    dynamic var username = "user"
    dynamic var image = "http://localhost/image.jpg"
    dynamic var createdAt = NSDate()
    dynamic var updatedAt = NSDate()
    let myMouves = List<Mouve>()
    let memberOf = List<Mouve>()
    let followers = List<Person>()
    let following = List<Person>()
}

//email: {type: String, required: true, unique: true},

//password: {type: String, required: true},
//device_id: {type: String, required: true},

//mouves: {type: Array, ref: 'Mouve', default: []},
//memberOf: {type: Array, ref: 'Mouve', default: []},
