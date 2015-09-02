////
////  ParseCache.swift
////  The Mouve
////
////  Created by Hilal Habashi on 8/27/15.
////  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
////
//
//import Foundation
//import Parse
//
//class ParseCache{
//    var cache: NSCache?
//    class var sharedCache: ParseCache{
//        struct Static {
//            static let instance = ParseCache()
//        }
//        return Static.instance
//    }
//    func setAttributes(attributes: NSDictionary, forMouve: Events) {
//        let key = self.keyForMouve(forMouve)
//        self.cache?.setObject(attributes, forKey: key)
//    }
//    
//    func setAttributes(attributes: NSDictionary, forUser: PFUser) {
//        let key = self.keyForUser(forUser)
//        self.cache?.setObject(attributes, forKey: key)
//    }
//    
//    func keyForMouve(mouve: Events) -> String {
//        return("mouve_\(mouve.objectId)")
//    }
//    func keyForUser(user: PFUser) -> String {
//        return("user_\(user.objectId)")
//    }
//    func clear(){
//        self.cache?.removeAllObjects()
//    }
//    func setAttributesForMouve(mouve: Events, attendees: [PFUser], invited: [PFUser], posts: [Activity], isAttending: Bool){
//        let attributes = NSDictionary(objectsAndKeys: [["isAttending": isAttending],["postsOnMouve":posts],["postsCount":posts.count],["mouveAttendees":attendees],["attendeesCount":attendees.count], ["invitedToMouve":invited],["invitedCount":invited.count]])
//        self.setAttributes(attributes, forMouve: mouve)
//    }
//    //- (NSDictionary *)attributesForPhoto:(PFObject *)photo;
//    func attributesForMouve(mouve: Events) -> NSDictionary{
//        let key = self.keyForMouve(mouve)
//        return self.cache?.objectForKey(key) as! NSDictionary
//    }
//    
//
//
//    //- (NSNumber *)likeCountForPhoto:(PFObject *)photo;
//    func attendeesCountForMouve(mouve: Events) -> Int{
//        let dict = self.attributesForMouve(mouve)
//        if let aCount = dict.objectForKey("mouveAttendees")?.count  {
//            return aCount
//        }
//        return 0 as Int
//    }
//    
//    //- (NSNumber *)commentCountForPhoto:(PFObject *)photo;
//    func postCountForMouve(mouve: Events) -> Int{
//        let dict = self.attributesForMouve(mouve)
//        if let aCount = dict.objectForKey("postsOnMouve")?.count  {
//            return aCount
//        }
//        return 0 as Int
//    }
//    //- (NSArray *)likersForPhoto:(PFObject *)photo;
//    func attendeesForMouve(mouve: Events) -> [PFUser]{
//        let dict = self.attributesForMouve(mouve)
//        if let array: AnyObject = dict.objectForKey("mouveAttendees")  {
//            return array as! [PFUser]
//        }
//        return [PFUser]()
//    }
//    func attendThisMouve(mouve: Events, attend: Bool) {
//        let dict = self.attributesForMouve(mouve)
//        dict.setValue(attend, forKey: "isAttending")
//        self.setAttributes(dict, forMouve: mouve)
//    }
//    func isAttendedByCurrentUser(mouve: Events) -> Bool{
//        let dict = self.attributesForMouve(mouve)
//        if let result: AnyObject = dict.objectForKey("isAttending"){
//            return result as! Bool
//        }
//            return false
//    }
//
//    //- (NSArray *)commentersForPhoto:(PFObject *)photo;
//    func postAuthorsForMouve(mouve: Events) -> [PFUser]{
//        let dict = self.attributesForMouve(mouve)
//        if let array: AnyObject = dict.objectForKey("postsOnMouve")  {
//            return array as! [PFUser]
//        }
//        return [PFUser]()
//    }
//
//    
//    //- (void)incrementLikerCountForPhoto:(PFObject *)photo;
//    func incrementAttendeesForMouve(mouve: Events){
//        let count = self.attendeesCountForMouve(mouve) + 1
//        let attributes = self.attributesForMouve(mouve)
//        attributes.objectForKey("attendeesCount")
//        self.setAttributes(attributes, forMouve: mouve)
//
//    }
//    //- (void)decrementLikerCountForPhoto:(PFObject *)photo;
//    func decrementAttendeesForMouve(mouve: Events){
//        let count = self.attendeesCountForMouve(mouve) - 1
//        let attributes = self.attributesForMouve(mouve)
//        attributes.objectForKey("attendeesCount")
//        self.setAttributes(attributes, forMouve: mouve)
//    }
//    //- (void)incrementCommentCountForPhoto:(PFObject *)photo;
//    func incrementPostsForMouve(mouve: Events){
//        let count = self.postCountForMouve(mouve) + 1
//        let attributes = self.attributesForMouve(mouve)
//        attributes.objectForKey("postsCount")
//        self.setAttributes(attributes, forMouve: mouve)
//    }
//    //- (void)decrementCommentCountForPhoto:(PFObject *)photo;
//    func decrementPostsForMouve(mouve: Events){
//        let count = self.postCountForMouve(mouve)-1
//        let attributes = self.attributesForMouve(mouve)
//        attributes.objectForKey("postsCount")
//        self.setAttributes(attributes, forMouve: mouve)
//    }    //
//    
//    func setAttributesForMouve(user: PFUser, mouveCount: Int,followersCount: Int,followingCount:Int, isFollowing: Bool){
//        let attributes = NSDictionary(objectsAndKeys: [["isFollowing": isFollowing],["mouveCount":mouveCount],["followersCount":followersCount],["followingCount":followingCount]])
//        self.setAttributes(attributes, forUser: user)
//    }
//
//    //- (NSDictionary *)attributesForUser:(PFUser *)user;
//    func attributesForUser(user: PFUser) -> NSDictionary{
//        let key = self.keyForUser(user)
//        return self.cache?.objectForKey(key) as! NSDictionary
//    }    //- (NSNumber *)photoCountForUser:(PFUser *)user;
//    func mouveCountForUser(user: PFUser) -> Int{
//        let dict = self.attributesForUser(user)
//        if let aCount = dict.objectForKey("mouvesCount")?.count  {
//            return aCount
//        }
//        return 0 as Int
//    }
//    //- (BOOL)followStatusForUser:(PFUser *)user;
//    func followStatusForUser(user: PFUser) -> Bool{
//        let attributes = self.attributesForUser(user)
//        if let status: AnyObject = attributes.objectForKey("isFollowing"){
//            return status as! Bool
//        }
//        return false
//    }
//    //- (void)setPhotoCount:(NSNumber *)count user:(PFUser *)user;
//    func setMouveCount(user: PFUser,count:Int ) {
//        let attributes = self.attributesForUser(user)
//        attributes.setValue(count, forKey: "mouvesCount")
//        self.setAttributes(attributes, forUser: user)
//    }
//    //- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;
//    func setFollowStatus(user: PFUser,following: Bool ) {
//        let attributes = self.attributesForUser(user)
//        attributes.setValue(following, forKey: "isFollowing")
//        self.setAttributes(attributes, forUser: user)
//    }
//    //
//    //- (void)setFacebookFriends:(NSArray *)friends;
//    //- (NSArray *)facebookFriends;
//}
