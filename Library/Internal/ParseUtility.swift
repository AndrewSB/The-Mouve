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
                println("deleting \(activity.objectId)")
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
                println("data cant be found")
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
        if(targetEvent.backgroundImage == nil){
            onCompletion!(data: nil, error: nil)
            println("error'd out")
        }
        targetEvent.backgroundImage?.getDataInBackgroundWithBlock(){(imgData:NSData?, error: NSError?) -> Void in
            if((imgData) != nil){
                onCompletion!(data: UIImage(data: imgData! as NSData), error: nil)
                }
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
//    + (void)unlikePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
//    
//    + (void)processFacebookProfilePictureData:(NSData *)data;
//    
//    + (BOOL)userHasValidFacebookData:(PFUser *)user;
//    + (BOOL)userHasProfilePictures:(PFUser *)user;
//    + (UIImage *)defaultProfilePicture;
//    
//    + (NSString *)firstNameForDisplayName:(NSString *)displayName;
//    
//    + (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
//    + (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
//    + (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
//    + (void)unfollowUserEventually:(PFUser *)user;
//    + (void)unfollowUsersEventually:(NSArray *)users;

}