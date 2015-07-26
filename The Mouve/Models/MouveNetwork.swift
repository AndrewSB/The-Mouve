//
//  NetworkTargets.swift
//  The Mouve
//
//  Created by Hilal Habashi on 7/17/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

public enum MouveREST {
    //// Auth --------------------------------------------------------------------
    case AuthUser(email: String, password: String)
    case LogoutUser
    //// Users --------------------------------------------------------------------
    case RetreiveUser(user_id: String)
    case Me
    case UpdateMe(name: String, username: String, email: String, password: String, image: String)
    case CreateUser(name: String, username: String, email: String, password: String)
    case AttendedMouves(user_id: String)
    case FollowUser(user_id: String)
    case Followers(user_id: String)
    case Following(user_id: String)
    case UnfollowUser(user_id: String)
    case MouvesByUser(user_id: String)

    //// Mouves --------------------------------------------------------------------
    case Attendents(mouve_id: String)
    case Attend(mouve_id: String)
    case UnAttend(mouve_id: String)
    case MouveInfo(mouve_id: String)
    case CreateMouve(name: String, image: String, location: String, details: String, start: NSDate, end: NSDate, privacy: Bool)
    case UpdateMouve(mouve_id: String, name: String, location: String, details: String, start: NSDate, end: NSDate, image: String,privacy: Bool)
    case CancelMouve(mouve_id: String)
    
    

    //// Mouves Comments ------------------------------------------------------------
    case RetrieveComments(mouve_id: String)
    case AddComment(mouve_id: String, comment: String)
    case UpdateComment(mouve_id: String, comment_id: String, comment: String)
    case DeleteComment(mouve_id: String, comment_id: String)
    //// Mouves Invites -------------------------------------------------------------
    //Should be embeded inside the model so no point of having actual method
    case ListInvitedUsers(mouve_id: String)
    case InviteUser(mouve_id: String, user_id: String)
    case DeleteInvite(mouve_id: String, user_id: String)
    //
    //// Search ---------------------------------------------------------------------
    //app.get('/api/mouves/nearby', mouves.query.nearby)
    case NearbyMouves(location: String)
    case RetreiveMouveScene(filter: String)
    case SearchMouves(filter: String)
    case SearchUser(filter: String)
    
    //app.get('/api/mouves/scene', mouves.query.scene)
    //app.get('/api/mouves/search', mouves.query.search)

    
}

extension MouveREST : MoyaPath {
    public var path: String {
        switch self {
            //Auth Paths
        case AuthUser:
            return "/api/users/login"
        case LogoutUser:
            return "/api/users/logout"
            //User Paths
        case CreateUser:
            return "/api/users"
        case RetreiveUser(let id):
            return "/api/users/\(id)"
        case UpdateMe:
            return "/api/users"
        case Me:
            return "/api/users"
        case FollowUser(let user_id):
            return "/api/users/\(user_id)/follow"
        case UnfollowUser(let user_id):
            return "/api/users/\(user_id)/unfollow"
        case Followers(let user_id):
            return "/api/users/\(user_id)/followers"
        case Following(let user_id):
            return "/api/users/\(user_id)/following"
        case AttendedMouves(let user_id):
            return "/api/users/\(user_id)/attended"
        case MouvesByUser(let user_id):
            return "/api/users/\(user_id)/planned"

            //// Mouves --------------------------------------------------------------------
        case Attendents(let mouve_id):
            return "/api/mouves/\(mouve_id)/attendents"
        case Attend(let mouve_id):
            return "/api/mouves/\(mouve_id)/attend"
        case UnAttend(let mouve_id):
            return "/api/mouves/\(mouve_id)/unattend"
        case MouveInfo(let mouve_id):
            return "/api/mouves/\(mouve_id)"
        case CreateMouve:
//            (let name, let image, let location, let details, let start, let end, let privacy, let image):
            return "/api/mouves"
        case UpdateMouve(let mouve_id):
//            ( let name, let image, let location, let details, let start, let end, let privacy, let image):
            return "/api/mouves/\(mouve_id)"
        case CancelMouve(let mouve_id):
            return "/api/mouves/\(mouve_id)"
            //// Mouves Comments ------------------------------------------------------------
        case RetrieveComments(let mouve_id):
            return "/api/mouves/\(mouve_id)/comments"
        case AddComment(let mouve_id,let comment):
            return "/api/mouves/\(mouve_id)/comments"
        case UpdateComment(let mouve_id,let comment_id, let comment):
            return "/api/mouves/\(mouve_id)/comments/\(comment_id)"
        case DeleteComment(let mouve_id,let comment_id):
            return "/api/mouves/\(mouve_id)/comments/\(comment_id)"
            //// Mouves Invites -------------------------------------------------------------
            
//        case ListInvitedUsers(let mouve_id):
//        case InviteUser(mouve_id: String, user_id: String)
//        case DeleteInvite(mouve_id: String, user_id: String)
            //
            //// Search ---------------------------------------------------------------------
            //// Search ---------------------------------------------------------------------
            //app.get('/api/mouves/nearby', mouves.query.nearby)
        case NearbyMouves:
            return "/api/mouves/nearby"
        case RetreiveMouveScene(let filter):
            return "/api/mouves/filter?=\(filter)"
        case SearchMouves(let filter):
            return "/api/mouves/filter?=\(filter)"
        case SearchUser(let filter):
            return "/api/mouves/filter?=\(filter)"
        default:
            return "/api/users"
        }
    }
}

extension MouveREST : MoyaTarget {
    
//    public var base: String { return AppSetup.sharedState.useStaging ? "https://themouve.herokuapp.com" }
//    public var base: String { return AppSetup.sharedState.useStaging ? "https://themouve.herokuapp.com" : "https://api.themouveapp.com" }
//    public var baseURL: NSURL { return NSURL(string: base)! }
    public var baseURL: NSURL { return NSURL(fileURLWithPath: "https://themouve.herokuapp.com")! }
    public var parameters: [String: AnyObject] {
        switch self {
        case AuthUser(let email, let password):
            return [
                "email": email,
                "password":  password
            ]
        case CreateUser(let name, let username, let email, let password):
            return [
                "name": name,
                "username": username,
                "email": email,
                "password": password
            ]
        case UpdateMe(let name, let username, let email, let password, let image):
            return [
                "name": name,
                "username": username,
                "email": email,
                "password": password,
                "image": image
            ]
        default:
            return [:]
        }
    }
    
    public var method: Moya.Method {
        //TODO:
        switch self {
        case .CreateUser,
             .AuthUser,
             .FollowUser,
             .UnfollowUser:
            return .POST
        case .UpdateMe:
            return .PUT
        case .LogoutUser:
            return .DELETE
        default:
            return .GET
        }
    }

    
    public var sampleData: NSData {
        switch self {
//            CHANGE TO ACTUAL EXAMPLE OF RESPONSES
        case AuthUser:
            return stubbedResponse("Login")
        case LogoutUser:
            return stubbedResponse("Logout")
        case CreateUser:
            return stubbedResponse("CreateUser")
        case UpdateMe:
            return stubbedResponse("UpdateMe")
        case RetreiveUser(let id):
            return stubbedResponse("Me")
        case FollowUser(let user_id):
            return stubbedResponse("FollowUser")
        case UnfollowUser(let user_id):
            return stubbedResponse("UnfollowUser")
        case Me:
            return stubbedResponse("Me")
        default:
            return stubbedResponse("Me")
        }
    }
}

//// MARK: - Provider setup
//
public func endpointResolver () -> ((endpoint: Endpoint<MouveREST>) -> (NSURLRequest)) {
    return { (endpoint: Endpoint<MouveREST>) -> (NSURLRequest) in
        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
        request.HTTPShouldHandleCookies = false
        return request
    }
}

//let endpointClosure = { (target: MouveREST) -> Endpoint<MouveREST> in
//    let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
//    return Endpoint(URL: url!, sampleResponse: .Success(200, {target.sampleData}), method: target.method, parameters: target.parameters)
//}
//let provider = MoyaProvider(endpointClosure: endpointClosure)
public class MouveProvider<T where T: MoyaTarget>: MoyaProvider<T> {
    
    let mouveEndpointClosure = { (target: MoyaTarget) -> Endpoint<MoyaTarget> in
        let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
        return Endpoint(URL: url!, sampleResponse: .Success(200, {target.sampleData}), method: target.method, parameters: target.parameters)
    }
    public override init(endpointsClosure: MoyaEndpointsClosure = MoyaProvider.DefaultEndpointMapping(), endpointResolver: MoyaEndpointResolution = MoyaProvider.DefaultEnpointResolution(), stubResponses: Bool = false, stubBehavior: MoyaStubbedBehavior = MoyaProvider.DefaultStubBehavior, networkActivityClosure: Moya.NetworkActivityClosure? = nil) {
        super.init(endpointsClosure: endpointsClosure, endpointResolver: endpointResolver, stubResponses: stubResponses, networkActivityClosure: networkActivityClosure)
    }
}

public struct Provider {
    private static var endpointsClosure = { (target: MouveREST) -> Endpoint<MouveREST> in
        
        var endpoint: Endpoint<MouveREST> = Endpoint<MouveREST>(URL: url(target), sampleResponse: .Success(200, {target.sampleData}), method: target.method, parameters: target.parameters)
        // Sign all non-XApp token requests
        
        switch  target {
        case .AuthUser:
            return endpoint
        default:
            return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": UserAuthToken().token ?? ""])
        }
    }
    
    public static func DefaultProvider() -> MouveProvider<MouveREST> {
        return MouveProvider(endpointsClosure: endpointsClosure, endpointResolver: endpointResolver(), stubResponses: true)
    }
    
    public static func StubbingProvider() -> MouveProvider<MouveREST > {
        return MouveProvider(endpointsClosure: endpointsClosure, endpointResolver: endpointResolver(), stubResponses: true)
    }
    
    private struct SharedProvider {
        static var instance = Provider.DefaultProvider()
    }
    
    public static var sharedProvider: MouveProvider<MouveREST> {
        get {
        return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
    }
}
//
//
// MARK: - Provider support

private func stubbedResponse(filename: String) -> NSData! {
    @objc class TestClass { }
    
    let bundle = NSBundle(forClass: TestClass.self)
    let path = bundle.pathForResource(filename, ofType: "json")
    return NSData(contentsOfFile: path!)
}

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public func url(route: MoyaTarget) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString!
}
