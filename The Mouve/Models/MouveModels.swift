//
//  Mouve.swift
//  The Mouve
//
//  Created by Samuel Ifeanyi Ojogbo Jr. on 7/13/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
//import RealmSwift
import CoreData

@objc(Person)
class Person: NSManagedObject {
    let entityName = "Person"
    @NSManaged var name: String
    @NSManaged var username: String
    @NSManaged var createdAt: NSDate
    @NSManaged var updatedAt: NSDate
    @NSManaged var image: String
    @NSManaged var attended: [Mouve]
    @NSManaged var planned: [Mouve]
    @NSManaged var comments: [Comment]
    
}
@objc(Mouve)
class Mouve: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var details: String
    @NSManaged var image: String
    @NSManaged var privacy: Boolean
    @NSManaged var owner: Person
    @NSManaged var comments: [Comment]
    @NSManaged var attendees: [Person]
    @NSManaged var createdAt: NSDate
    @NSManaged var updatedAt: NSDate
    @NSManaged var startTime: NSDate
    @NSManaged var endTime: NSDate
    
}
@objc(Comment)
class Comment: NSManagedObject {
    
    @NSManaged var textContent: String
    @NSManaged var media: String
    @NSManaged var author: Person
    @NSManaged var createdAt: NSDate
    @NSManaged var updatedAt: NSDate
    @NSManaged var postedOn: Mouve
    
}
//
//
//class Person: Object {
//    dynamic var name: String = ""
//    dynamic var username: String = "nil"
//    dynamic var image = "http://localhost/image.jpg"
//    dynamic var createdAt = NSDate()
//    dynamic var updatedAt = NSDate()
//    let myMouves = List<Mouve>()
//    let memberOf = List<Mouve>()
//    let followers = List<Person>()
//    let following = List<Person>()
//}
//
//class User: Object{
//    dynamic var person = Person()
//    dynamic var id = 0
//    dynamic var authToken : String = "nil"
//    dynamic var email: String = "a@a.com"
//    dynamic var password: String = "password"
//    dynamic var fbId: String=""
//    dynamic var isNil: Bool=true
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//}
//
//class Mouve: Object {
//    dynamic var owner: Person? // Can be optional
//    
//    dynamic var name = ""
//    dynamic var details = ""
//    //    dynamic var location=
//
//    dynamic var image = ""
//    dynamic var comments = ""
//
//    dynamic var privacy = Bool()
//
//    dynamic var start = NSDate()
//    dynamic var end = NSDate()
//    dynamic var createdAt = NSDate()
//    dynamic var updatedAt = NSDate()
//    
//    let inviteList = List<Person>()
//
//    
//
//}
