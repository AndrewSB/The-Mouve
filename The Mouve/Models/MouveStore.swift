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
    let currentUser = Person()
    let currentRealm = Realm(inMemoryIdentifier: "currentRealm")
    let currMouve = Mouve()

    var mouveArray: Results<Mouve>{
        get {
            return currentRealm.objects(Mouve)
        }
    }
    func addMouve(name: String, details: String, image: String, startTime: NSDate, endTime: NSDate){
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