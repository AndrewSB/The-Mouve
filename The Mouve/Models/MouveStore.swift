//
//  MouveStore.swift
//  The Mouve
//
//  Created by Hilal Habashi on 7/13/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import RealmSwift
import CoreData

class persistentData{
//    let currentUser = User()

    let currentRealm = Realm(path: Realm.defaultPath)
    var currentUser: User{
        get {
            if let currU = currentRealm.objectForPrimaryKey(User.self, key: 0){
                return currU
            }
            else{
                return User()
            }
        }
    }


    var mouveArray: Results<Mouve>{
        get {
            return currentRealm.objects(Mouve)
        }
    }
    func addMouve(name: String, details: String, image: String, startTime: NSDate, endTime: NSDate){

            
            //Mouve fields filled in
            currMouve.name = name
            currMouve.details = details
            currMouve.image = image
            currMouve.start = startTime
            currMouve.end = endTime
        currMouve.createdAt
            
        saveContext()
    }
    func registerUser(name: String, username: String, email: String,
        password: String,
        authToken: String,
        image: String){
        let currUser = currentUser
        currentRealm.beginWrite()
        
        //Mouve fields filled in
        currUser.person.name = name
        currUser.person.username = username
        currUser.email = email
        currUser.password = password
        currUser.person.image = image
        
        currentRealm.add(currUser)
        currentRealm.commitWrite()
    }
    
    func isLogged(){
        
    }
    
    func fbRegister(username: String, email: String,
        fbId: String,
        name: String){
        let currUser = currentUser
        currentRealm.beginWrite()
        currentUser.person.name = name
        currentUser.person.username = username
        currentUser.email = email
        currentUser.fbId = fbId

        currentRealm.add(currUser)
        currentRealm.commitWrite()
    }
    
    func addPerson(username: String, image: String
        ){
let person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as! Person
             
            
            //Mouve fields filled in
            currPerson.username = username
            currPerson.image = image
            currentRealm.add(currPerson)
            currentRealm.commitWrite()
    }
    func delPerson(currPerson: Person){
        currentRealm.beginWrite()
        currentRealm.delete(currPerson)
        currentRealm.commitWrite()
    }
    func logoutUser(){
        currentRealm.beginWrite()
        currentRealm.delete(currentUser)
        currentRealm.commitWrite()
    }
    
    func delMouve(currMouve: Mouve){
        currentRealm.beginWrite()
        currentRealm.delete(currMouve)
        currentRealm.commitWrite()
    }
    
    var followersList: List<Person>{
        get {
            var myFollowers = currentUser.person.followers
            return myFollowers
        }
    }
    var followingList: List<Person>{
        get {
            var iFollow = currentUser.person.following
            return iFollow
        }
    }
    class var sharedInstance: persistentData{
        struct Static {
            static let instance = persistentData()
        }
        return Static.instance
    }
}