//
//  Mouve.swift
//  The Mouve
//
//  Created by Samuel Ifeanyi Ojogbo Jr. on 7/13/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import RealmSwift



class Person: Object {
    dynamic var name: String = ""
    dynamic var username: String = "user"
    dynamic var image = "http://localhost/image.jpg"
    dynamic var createdAt = NSDate()
    dynamic var updatedAt = NSDate()
    let myMouves = List<Mouve>()
    let memberOf = List<Mouve>()
    let followers = List<Person>()
    let following = List<Person>()
}

class User: Person{
    dynamic var authToken : String = ""
    dynamic var email: String = "a@a.com"
    dynamic var password: String = "password"
    dynamic var fbId: String=""
}

class Mouve: Object {
    dynamic var owner: Person? // Can be optional
    
    dynamic var name = ""
    dynamic var details = ""
    //    dynamic var location=

    dynamic var image = ""
    dynamic var comments = ""

    dynamic var privacy = Bool()

    dynamic var start = NSDate()
    dynamic var end = NSDate()
    dynamic var createdAt = NSDate()
    dynamic var updatedAt = NSDate()
    
    let inviteList = List<Person>()

    

}
