//
//  MouveStore.swift
//  The Mouve
//
//  Created by Hilal Habashi on 7/13/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStore{
    let currentUser = User()
    let currentRealm = Realm(path: Realm.defaultPath)

    var mouveArray: Results<Mouve>{
        get {
            return currentRealm.objects(Mouve)
        }
    }
    func addMouve(name: String, details: String, image: String, startTime: NSDate, endTime: NSDate){
            let currMouve = Mouve()
            currentRealm.beginWrite()
            
            //Mouve fields filled in
            currMouve.name = name
            currMouve.details = details
            currMouve.image = image
            currMouve.start = startTime
            currMouve.end = endTime
            
            currentRealm.add(currMouve)
            currentRealm.commitWrite()
    }
    func registerUser(name: String, username: String, email: String,
        password: String,
        authToken: String,
        image: String){
        let currUser = currentUser
        currentRealm.beginWrite()
        
        //Mouve fields filled in
        currUser.name = name
        currUser.username = username
        currUser.email = email
        currUser.password = password
        currUser.image = image
        
        currentRealm.add(currUser)
        currentRealm.commitWrite()
    }
    
    func fbRegister(username: String, email: String,
        fbId: String,
        name: String){
        let currUser = currentUser
        currentRealm.beginWrite()
        currentUser.name = name
        currentUser.username = username
        currentUser.email = email
        currentUser.fbId = fbId

        currentRealm.add(currUser)
        currentRealm.commitWrite()
    }
    
    func addPerson(username: String, image: String
        ){
            let currPerson = Person()
            currentRealm.beginWrite()
            
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
            var myFollowers = currentUser.followers
            return myFollowers
        }
    }
    var followingList: List<Person>{
        get {
            var iFollow = currentUser.following
            return iFollow
        }
    }
    class var sharedInstance: RealmStore{
        struct Static {
            static let instance = RealmStore()
        }
        return Static.instance
    }
}