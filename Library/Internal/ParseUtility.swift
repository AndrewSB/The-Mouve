//
//  ParseUtility.swift
//  The Mouve
//
//  Created by Hilal Habashi on 8/22/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import Parse
import UIKit

class ParseUtility{
    class func attendMouveInBackground(targetEvent: Events ,onCompletion: ((succeeded: Bool, error: NSError?) -> ())?){
//        Check if invited if private
        let query = Activity.query()
//        if (targetEvent.privacy){
//            query?.whereKey("onMouve", equalTo: targetEvent)
//            query?.whereKey("fromUser", equalTo: targetEvent.creator)
//            query?.whereKey("toUser", equalTo: appDel.currentUser!)
//            query?.whereKey("typeKey", equalTo: typeKeyEnum.Invite.rawValue)
//            if(((query?.countObjects()) ) == nil){
//                return;
//            }
//        }
////        Check if already attending
//        else{
            query?.whereKey("onMouve", equalTo: targetEvent)
            query?.whereKey("fromUser", equalTo: appDel.currentUser!)
            query?.whereKey("typeKey", equalTo: typeKeyEnum.Attend.rawValue)
            if((query!.countObjects()) != 0){
                return;
            }
//        }
        
        let activity = Activity()
        activity.type = typeKeyEnum.Attend
        activity.fromUser = appDel.currentUser!
        activity.toUser = targetEvent.creator
        activity.onMouve = targetEvent

        
        let activityACL = PFACL(user: appDel.currentUser!)
        activityACL.setPublicReadAccess(true)
//        let eventACL = PFACL(user: appDel.currentUser!)
//        eventACL.setReadAccess(true, forUser: targetUser)
        activity.ACL = activityACL
//        targetEvent.ACL = eventACL
        
        activity.saveInBackgroundWithBlock(){(succeeded: Bool, error: NSError?) -> Void in
//            if((error) == nil){
            if((onCompletion) != nil){
                onCompletion!(succeeded: succeeded, error: error)
            }
            //        Save the ACL for event
//                targetEvent.saveInBackgroundWithBlock(){(succeeded: Bool, error: NSError?) -> Void in
//                    if((onCompletion) != nil){
//                        onCompletion!(succeeded: succeeded, error: error)
//                    }
//                }
            }
        
        //        Set cache
        //        [[PAPCache sharedCache] setFollowStatus:YES user:user];
    }

    class func unattendMouveInBackground(targetEvent: Events! ,onCompletion: ((succeeded: Bool, error: NSError?) -> ())?){
        let query = Activity.query()
        //        query?.whereKey(appDel.currentUser, )
        query?.whereKey("fromUser", equalTo: appDel.currentUser!)
        //        [query whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
        query?.whereKey("onMouve", equalTo: targetEvent)
        //        [query whereKey:kPAPActivityToUserKey equalTo:user];
        //        [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
        query?.whereKey("typeKey", equalTo: typeKeyEnum.Attend.rawValue)
        query?.findObjectsInBackgroundWithBlock(){(data:[AnyObject]?, error: NSError?) -> Void in
//            var serverData = [Activity]()
//            //            println(results)
        if let attendActivities = data as? [Activity]{
            for  activity in attendActivities{
                print("deleting \(activity.objectId)")
                activity.deleteEventually()
            }
        }
//            println("object found")
//            // While normally there should only be one follow activity returned, we can't guarantee that.
//            if ((data) != nil) {
//                println("deleting data")
//                let followActivities = data as! [Activity]
//                for  activity in followActivities{
//                    println("deleting \(activity.objectId)")
////                    activity.deleteEventually()
//                }
//            }
            else{
                print("data cant be found")
            }
        }
        
    }
    class func inviteUserToMouveInBackground(targetEvent: Events, targetUser: PFUser ,onCompletion: ((succeeded: Bool, error: NSError?) -> ())?){
        if ((targetUser.objectId) == (appDel.currentUser?.objectId)) {
            return;
        }
        let query = Activity.query()
        query?.whereKey("onMouve", equalTo: targetEvent)
        query?.whereKey("toUser", equalTo: targetUser)
        query?.whereKey("typeKey", equalTo: typeKeyEnum.Invite.rawValue)
        if((query!.countObjects()) != 0){
            return;
        }
        
        let activity = Activity()
        activity.fromUser = appDel.currentUser!
        activity.toUser = targetUser
        activity.type = typeKeyEnum.Invite
        
        let activityACL = PFACL(user: appDel.currentUser!)
        activityACL.setReadAccess(true, forUser: targetUser)
        let eventACL = PFACL(user: appDel.currentUser!)
        eventACL.setReadAccess(true, forUser: targetUser)
        activity.ACL = activityACL
        targetEvent.ACL = eventACL
        
        activity.saveInBackgroundWithBlock(){(succeeded: Bool, error: NSError?) -> Void in
            if((error) == nil){
                //        Save the ACL for event
                targetEvent.saveInBackgroundWithBlock(){(succeeded: Bool, error: NSError?) -> Void in
                    if((onCompletion) != nil){
                        onCompletion!(succeeded: succeeded, error: error)
                    }
                }
            }
        }

        //        Set cache
        //        [[PAPCache sharedCache] setFollowStatus:YES user:user];
    }
    
    class func inviteUserToMouveEventually(targetEvent: Events, targetUser: PFUser,onCompletion: ((succeeded: Bool, error: NSError?) -> ())?){
//        Check if inviting self or trying to invite to someone elses event
        if (((targetUser.objectId) == (appDel.currentUser?.objectId)) || ((targetEvent.creator.objectId) != (appDel.currentUser?.objectId))) {
            return;
        }
//        Check if already invited
        let query = Activity.query()
        query?.whereKey("onMouve", equalTo: targetEvent)
        query?.whereKey("toUser", equalTo: targetUser)
        if((query!.countObjects()) != 0){
            return;
        }
        
        let activity = Activity()
        activity.fromUser = appDel.currentUser!
        activity.toUser = targetUser
        activity.type = typeKeyEnum.Invite
        
        let activityACL = PFACL(user: appDel.currentUser!)
        activityACL.setPublicReadAccess(true)
        let eventACL = PFACL(user: appDel.currentUser!)
        eventACL.setReadAccess(true, forUser: targetUser)
        activity.ACL = activityACL
        targetEvent.ACL = eventACL

        activity.saveEventually(){(succeeded: Bool, error:NSError?) -> Void in
            if(succeeded){
                targetEvent.saveEventually(onCompletion)
            }
        }
        
    }
    class func inviteUsersToMouveEventually(targetEvent: Events, targetUsers: [PFUser],onCompletion: ((succeeded: Bool, error: NSError?) -> ())?){
        for user in targetUsers{
            inviteUserToMouveEventually(targetEvent, targetUser:user, onCompletion: onCompletion)

        }
        //        Set cache
        //        [[PAPCache sharedCache] setFollowStatus:YES user:user];
    }
    class func inviteUsersToMouveInBackground(targetEvent: Events, targetUsers: [PFUser],onCompletion: ((succeeded: Bool, error: NSError?) -> ())?){
        for user in targetUsers{
            inviteUserToMouveInBackground(targetEvent, targetUser:user, onCompletion: onCompletion)
            
        }
        //        Set cache
        //        [[PAPCache sharedCache] setFollowStatus:YES user:user];
    }
    class func uninviteUserFromMouveEventually(targetEvent: Events, targetUser: PFUser){
        let query = Activity.query()
        query?.whereKey("onMouve", equalTo: targetEvent)
        query?.whereKey("fromUser", equalTo: appDel.currentUser!)
        query?.whereKey("toUser", equalTo: targetUser)
        query?.whereKey("typeKey", equalTo: typeKeyEnum.Invite.rawValue)
        query?.findObjectsInBackgroundWithBlock(){(data:[AnyObject]?, error: NSError?) -> Void in
            // While normally there should only be one follow activity returned, we can't guarantee that.
        if let inviteActivities = data as? [Activity]{
                for  activity in inviteActivities{
                    activity.deleteEventually()
                }
            }
        }
        //        Set cache
        //        [[PAPCache sharedCache] setFollowStatus:YES user:user];
    }
    
    class func getEventBgImg(targetEvent: Events,onCompletion: ((data: UIImage?, error: NSError?) -> ())?){
        if let eventImage = targetEvent.backgroundImage as PFFile?{
            targetEvent.backgroundImage?.getDataInBackgroundWithBlock(){(imgData:NSData?, error: NSError?) -> Void in
                if((error) != nil){
                    onCompletion!(data: nil, error: error)
                }
                onCompletion!(data: UIImage(data: imgData! as NSData), error: nil)
            }
        }
        else{
            onCompletion!(data: nil, error: nil)
        }
    }
    class func getProfileImg(targetUser: PFUser,onCompletion: ((data: UIImage?, error: NSError?) -> ())?){
        if(targetUser.profileImage == nil){
            onCompletion!(data: nil, error: nil)
        }
        targetUser.profileImage?.getDataInBackgroundWithBlock(){(imgData:NSData?, error: NSError?) -> Void in
            if((imgData) != nil){
                onCompletion!(data: UIImage(data: imgData!), error: nil)
            }
        }
    }

    class func followUserInBackground(targetUser: PFUser,onCompletion: ((succeeded: Bool, error: NSError?) -> ())?){
        if ((targetUser.objectId) == (appDel.currentUser?.objectId)) {
            return;
        }
        
        let activity = Activity()
        activity.fromUser = appDel.currentUser!
        activity.toUser = targetUser
        activity.type = typeKeyEnum.Follow
        
        let activityACL = PFACL(user: appDel.currentUser!)
        activityACL.setPublicReadAccess(true)
        activity.ACL = activityACL;
        
        activity.saveInBackgroundWithBlock(){(succeeded: Bool, error: NSError?) -> Void in
            if((onCompletion) != nil){
                onCompletion!(succeeded: succeeded,error: error)
            }
        }
//        Set cache
//        [[PAPCache sharedCache] setFollowStatus:YES user:user];
    }
    class func followUserEventually(targetUser: PFUser,onCompletion: ((succeeded: Bool, error: NSError?) -> ())?){
        if ((targetUser.objectId) == (appDel.currentUser?.objectId)) {
            return;
        }
        
        let activity = Activity()
        activity.fromUser = appDel.currentUser!
        activity.toUser = targetUser
        activity.type = .Follow
        
        let activityACL = PFACL(user: appDel.currentUser!)
        activityACL.setPublicReadAccess(true)
        activity.ACL = activityACL;
        
        activity.saveEventually(onCompletion)
    }
    class func followUsersEventually(targetUsers: [PFUser],onCompletion: ((succeeded: Bool, error: NSError?) -> ())?){
        for user in targetUsers{
            self.followUserEventually(user, onCompletion: onCompletion)
        //        Set cache
        //        [[PAPCache sharedCache] setFollowStatus:YES user:user];
        }
        
    }
    class func findFollowersInBackground(targetUser: PFUser,onCompletion: ((data:[AnyObject]?, error: NSError?) -> ())?){
        let query = Activity.query()
        query?.whereKey("toUser", equalTo: targetUser)
        query?.whereKey("typeKey", equalTo: typeKeyEnum.Follow.rawValue)
        query?.findObjectsInBackgroundWithBlock(){(data:[AnyObject]?, error: NSError?) -> Void in
            // While normally there should only be one follow activity returned, we can't guarantee that.
            var userResultList = [PFUser]()
            if let followActivities = data as? [Activity]{
                for  activity in followActivities{
                    userResultList.append(activity.fromUser)
                }
                onCompletion!(data: userResultList, error: nil)
            }
            else{
                onCompletion!(data: nil, error: error)
            }
            
        }
    }
    class func findFolloweesInBackground(targetUser: PFUser,onCompletion: ((data:[AnyObject]?, error: NSError?) -> ())?){
        let query = Activity.query()
        query?.whereKey("fromUser", equalTo: targetUser)
        query?.whereKey("typeKey", equalTo: typeKeyEnum.Follow.rawValue)
        query?.findObjectsInBackgroundWithBlock(){(data:[AnyObject]?, error: NSError?) -> Void in
            // While normally there should only be one follow activity returned, we can't guarantee that.
            var userResultList = [PFUser]()
            if let followActivities = data as? [Activity]{
                for  activity in followActivities{
                    userResultList.append(activity.toUser)
                }
                onCompletion!(data: userResultList, error: nil)
            }
            else{
                onCompletion!(data: nil, error: error)
            }
        }
    }
    class func unfollowUserEventually(targetUser: PFUser){
        let query = Activity.query()
//        query?.whereKey(appDel.currentUser, )
        query?.whereKey("fromUser", equalTo: appDel.currentUser!)
//        [query whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
        query?.whereKey("toUser", equalTo: targetUser)
//        [query whereKey:kPAPActivityToUserKey equalTo:user];
//        [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
        query?.whereKey("typeKey", equalTo: typeKeyEnum.Follow.rawValue)
        query?.findObjectsInBackgroundWithBlock(){(data:[AnyObject]?, error: NSError?) -> Void in
            // While normally there should only be one follow activity returned, we can't guarantee that.
            let followActivities = data as! [Activity]
            if ((error) == nil) {
                for  activity in followActivities{
                    activity.deleteEventually()
                }
            }
        }
        //Set cache
//        [[PAPCache sharedCache] setFollowStatus:NO user:user];
    }
    class func unfollowUsersEventually(targetUsers: [PFUser]){
        for user in targetUsers{
            self.unfollowUserEventually(user)
            //        Set cache
            //        [[PAPCache sharedCache] setFollowStatus:YES user:user];
        }
    }
    class func queryForActivitiesOnMouve(targetEvent: Events, cachePolicy: PFCachePolicy){
        
    }
    class func queryFeed(sceneType: SceneType,range: Range<Int>, completionBlock: PFArrayResultBlock){
        //            First query the people we follow
        //            Then query all the mouves made by them
        var feedQuery: PFQuery
        switch sceneType {
        case .Explore:
            //            println("lol")
            feedQuery = Events.query()!
            feedQuery.whereKey("location", nearGeoPoint: PFGeoPoint(location: UserDefaults.lastLocation), withinMiles: 5.0)
            feedQuery.includeKey("creator")
            feedQuery.orderByAscending("startTime")
            feedQuery.skip = range.startIndex
            feedQuery.limit = range.endIndex - range.startIndex
            feedQuery.findObjectsInBackgroundWithBlock(completionBlock)
            
        case .Scene:
            let followingQuery = PFQuery(className: Activity.parseClassName())
            followingQuery.whereKey("typeKey", equalTo: typeKeyEnum.Follow.rawValue)
            followingQuery.whereKey("fromUser", equalTo: appDel.currentUser!)
            
            // Using the activities from the query above, we find all of the photos taken by
            // the friends the current user is following
            let followingMouvesQuery = PFQuery(className: Events.parseClassName())
            followingMouvesQuery.whereKey("creator", matchesKey: "toUser", inQuery: followingQuery)
            followingMouvesQuery.whereKeyExists("name")
            
            // We create a second query for the current user's mouves
            let mouvesFromCurrentUserQuery = PFQuery(className: Events.parseClassName())
            mouvesFromCurrentUserQuery.whereKey("creator", equalTo: appDel.currentUser!)
            followingMouvesQuery.whereKeyExists("name")
            
            // We create a final compound query that will find all of the photos that were
            // taken by the user's friends or by the user
            feedQuery = PFQuery.orQueryWithSubqueries([mouvesFromCurrentUserQuery, followingMouvesQuery])
            feedQuery.includeKey("creator")
            feedQuery.orderByAscending("startTime")
            feedQuery.skip = range.startIndex
            feedQuery.limit = range.endIndex - range.startIndex
            feedQuery.findObjectsInBackgroundWithBlock(completionBlock)
        default:
            print("Nada")
        }

    }
}