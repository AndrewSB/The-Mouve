//
//  Constant.h
//  MOUVE
//
//  Created by  on 02/09/14.
//  Copyright (c) 2014 Mouve. All rights reserved.
//
#import "Utiles.h"

#define ALL_CONTACTS_SYNC @"all_contacts_sync"
#define APP_NAME @"MOUVE"
#define ERROR @"Error"
#define RESULT @"Result"
#define DATA @"Data"

//local ip 192.168.1.9

#define USER_PHOTO_URL @"http://117.218.164.150/TheMouveWCF/UserPhotos/%@"
#define MOUVE_PHOTO_URL @"http://117.218.164.150/TheMouveWCF/MouvePhotos/%@"
#define API_BASE_USER_URL @"http://117.218.164.150/TheMouveWCF/Users.svc/"
#define API_BASE_MOUVE_URL @"http://117.218.164.150/TheMouveWCF/Mouves.svc/"
#define API_BASE_FOLLOW_URL @"http://117.218.164.150/TheMouveWCF/Follow.svc/"
#define API_BASE_SETTINGS_URL @"http://117.218.164.150/TheMouveWCF/Settings.svc/"
#define API_BASE_NOTIFICATION_URL @"http://117.218.164.150/TheMouveWCF/Notification.svc/"

#define API_VIDEO_UPLOAD @"http://117.218.164.150/TheMouveWCF/Mouves.svc/UploadMouveVideo/%@"

#define API_VIDEO_PLAY @"http://117.218.164.150/TheMouveWCF/MouveVideos/%@"


#define API_LOGIN (API_BASE_USER_URL @"UserLogin")
#define API_REGISTER (API_BASE_USER_URL @"SaveUser")
#define API_VALID_USER (API_BASE_USER_URL @"ValidUser")
#define API_USER_DETAILS (API_BASE_USER_URL @"UserDetails")
#define API_USER_UPDATE (API_BASE_USER_URL @"UpdateUser")
#define API_USER_UPLOAD_PHOTO (API_BASE_USER_URL @"UploadPhoto")
#define API_PHOTO_UPLOAD (API_BASE_USER_URL @"UploadPhotoString")
#define API_USER_SEARCH (API_BASE_USER_URL @"SearchUsers")


#define API_FOLLOWER_LIST (API_BASE_FOLLOW_URL @"FollowersByUserID")
#define API_FOLLOWING_LIST (API_BASE_FOLLOW_URL @"FollowingsByUserID")

#define API_FOLLOW_USER (API_BASE_FOLLOW_URL @"FollowUser")
#define API_UN_FOLLOW_USER (API_BASE_FOLLOW_URL @"UnFollowUser")

#define API_CREATE_MOUVE (API_BASE_MOUVE_URL @"SaveMouve")
#define API_UPDATE_MOUVE (API_BASE_MOUVE_URL @"UpdateMouve")
#define API_HOME_MOUVE (API_BASE_MOUVE_URL @"HomeMouves")
#define API_EXPLORE_MOUVE (API_BASE_MOUVE_URL @"ExploreMouves")
#define API_MOUVE_DETAILS (API_BASE_MOUVE_URL @"MouveDetails")
#define API_USER_MOUVES (API_BASE_MOUVE_URL @"MyMouves")
#define API_GOING_MOUVES (API_BASE_MOUVE_URL @"MouveGoing")
#define API_MOUVE_SEARCH (API_BASE_MOUVE_URL @"SearchMouve")

#define API_REGISTER_FOR_PUSH (API_BASE_SETTINGS_URL @"RegisterPush")
#define API_INVITE_PUSH (API_BASE_SETTINGS_URL @"InviteActive")
#define API_FOLLOWER_PUSH (API_BASE_SETTINGS_URL @"FollowerActive")

#define API_GET_NOTIFICATIONS (API_BASE_NOTIFICATION_URL @"GetNotification")
#define API_DELETE_NOTIFICATIONS (API_BASE_NOTIFICATION_URL @"IsDeleteNotification")
#define API_READ_NOTIFICATIONS (API_BASE_NOTIFICATION_URL @"IsReadNotification")


