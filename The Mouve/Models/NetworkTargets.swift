//
//  NetworkTargets.swift
//  The Mouve
//
//  Created by Hilal Habashi on 7/17/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

public enum MouveREST {
    // Auth
//    case XApp
    case AuthUser(email: String, password: String)
    case LogoutUser
//    case TrustToken(number: String, auctionPIN: String)
        //Users
//    case Me
    case RetreiveUser(id: String)
    case UpdateMe(name: String, username: String, email: String, password: String, image: String)
    case CreateUser(name: String, username: String, email: String, password: String)
    case FollowUser(user_id: String)
    case UnfollowUser(user_id: String)
    case MyMouves

    //// Mouves --------------------------------------------------------------------
    case InvitedToMouves
    case MouveInfo(id: String)
    case CreateMouve(name: String, image: String, location: String, details: String, start: NSDate, end: NSDate, privacy: Bool)
    case UpdateMouve(id: String, name: String, location: String, details: String, start: NSDate, end: NSDate, privacy: Bool)
    case ReplaceMouvePic(id: String, image: String)
    case CancelMouve(id: String)
    case MouvesByUser(user_id: String)
//    case AttendedMouves
    //// Mouves Comments
    case AvailableComments(mouve_id: String)
    case AddComment(mouve_id: String, comment: String, media: String)
    case UpdateComment(mouve_id: String, id: String, comment: String, media: String)
    case DeleteComment(mouve_id: String, id: String)
    //// Mouves Invites ------------------------------------------------------------
    case Attendees(mouve_id: String)
    case InvitePerson(mouve_id: String, user_id: String)
    case DeleteInvite(mouve_id: String, user_id: String)
    //
    //// Search --------------------------------------------------------------------
    //app.get('/api/mouves/nearby', mouves.query.nearby)
    case NearbyMouves(location: String)
    case RetreiveMouveScene
    case SearchMouves(filter: String)
    
    //app.get('/api/mouves/scene', mouves.query.scene)
    //app.get('/api/mouves/search', mouves.query.search)

    
}

extension MouveREST : MoyaPath {
    public var path: String {
        switch self {
        case AuthUser:
            return "/api/users/auth"
        case LogoutUser:
            return "/api/users/auth"
            
//        case Me:
//            return "/api/users"
        case RetreiveUser(let id):
            return "/api/users/\(id)"
        case UpdateMe:
            return "/api/users"
        case CreateUser:
            return "/api/users"
        case FollowUser(let user_id):
            return "/api/users/\(user_id)/follow"
        case UnfollowUser(let user_id):
            return "/api/users/\(user_id)/unfollow"
        case MyMouves:
            return "/api/users/mouves"

            //// Mouves --------------------------------------------------------------------
            //app.all('/api/mouves/*', users.middleware.isLoggedIn)
            //
            //app.get('/api/mouves/:id', mouves.middleware.canLook, mouves.crud.get)
            //app.post('/api/mouves', mouves.crud.create)
            //app.put('/api/mouves/:id', mouves.middleware.isUsers, mouves.crud.update)
            //app.put('/api/mouves/:id/image', mouves.middleware.isUsers, mouves.crud.updateImage)
            //app.delete('/api/mouves/:id', mouves.middleware.isUsers, mouves.crud.delete)
            //
            //// Mouves Comments
            //app.all('/api/mouves/:id/comments', mouves.middleware.canLook)
            //
            //app.get('/api/mouves/:id/comments', mouves.comments.get)
            //app.post('/api/mouves/:id/comments', mouves.comments.new)
            //app.put('/api/mouves/:id/comments/:comment_id', mouves.middleware.isUsersComment, mouves.comments.edit)
            //app.delete('/api/mouves/:id/comments/:comment_id', mouves.middleware.isUsersComment, mouves.comments.delete)
            //
            //// Mouves Invites ------------------------------------------------------------
            //app.all('/api/mouves/:id/invites/*', mouves.middleware.isUsers, mouves.middleware.isPrivate)
            //
            //app.get('./api/mouves/:id/invites', mouves.invites.get)
            //app.put('./api/mouves/:id/invites/:user_id', users.middleware.isValid, mouves.invites.new)
            //app.delete("./api/mouves/:id/invites/:user_id", users.middleware.isValid, mouves.invites.delete)
            //
            //
            //// Search --------------------------------------------------------------------
            //app.get('/api/mouves/nearby', mouves.query.nearby)
            //app.get('/api/mouves/scene', mouves.query.scene)
            //app.get('/api/mouves/search', mouves.query.search)
//        case MouveInfo(let id):
//            return "/api/v1/sale/\(id)"
//            
//        case InvitedToMouves:
//            return "/api/v1/sales"
//            
//        case AuctionListings(let id, _, _):
//            return "/api/v1/sale/\(id)/sale_artworks"
//            
//        case MouveInfoForArtwork(let auctionID, let artworkID):
//            return "/api/v1/sale/\(auctionID)/sale_artwork/\(artworkID)"
//            
//        case SystemTime:
//            return "/api/v1/system/time"
//            
//        case Ping:
//            return "/api/v1/system/ping"
//            
//        case RegisterToBid:
//            return "/api/v1/bidder"
//            
//        case MyMouves:
//            return "/api/v1/me/credit_cards"
//            
//        case CreatePINForBidder(let bidderID):
//            return "/api/v1/bidder/\(bidderID)/pin"
//            
//        case ActiveAvailableMouves:
//            return "/api/v1/sales"
//            
//        case Me:
//            return "/api/v1/me"
//            
//        case UpdateMe:
//            return "/api/v1/me"
//            
//        case CreateUser:
//            return "/api/v1/user"
//            
//        case MyBiddersForAuction:
//            return "/api/v1/me/bidders"
//            
//        case MyBidPositionsForAuctionArtwork:
//            return "/api/v1/me/bidder_positions"
//            
//        case Artwork(let id):
//            return "/api/v1/artwork/\(id)"
//            
//        case Artist(let id):
//            return "/api/v1/artist/\(id)"
//            
//        case FindBidderRegistration:
//            return "/api/v1/bidder"
//            
//        case PlaceABid:
//            return "/api/v1/me/bidder_position"
//            
//        case RegisterCard:
//            return "/api/v1/me/credit_cards"
//            
//        case TrustToken:
//            return "/api/v1/me/trust_token"
//            
//        case BidderDetailsNotification:
//            return "/api/v1/bidder/bidding_details_notification"
//            
//        case LostPasswordNotification:
//            return "/api/v1/users/send_reset_password_instructions"
//            
//        case FindExistingEmailRegistration:
//            return "/api/v1/user"
            
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
            return "/api/users/auth"
        case LogoutUser:
            return "/api/users/auth"
        case RetreiveUser(let id):
            return "/api/users/\(id)"
        case UpdateMe:
            return "/api/users"
        case CreateUser:
            return "/api/users"
        case FollowUser(let user_id):
            return "/api/users/\(user_id)/follow"
        case UnfollowUser(let user_id):
            return "/api/users/\(user_id)/unfollow"
        case MyMouves:
            return "/api/users/mouves"
            
//        case XApp:
//            return stubbedResponse("XApp")
//            
//        case XAuth:
//            return stubbedResponse("XAuth")
//            
//        case TrustToken:
//            return stubbedResponse("XAuth")
//            
//        case AvailableMouves:
//            return stubbedResponse("AvailableMouves")
//            
//        case AuctionListings:
//            return stubbedResponse("AuctionListings")
//            
//        case SystemTime:
//            return stubbedResponse("SystemTime")
//            
//        case CreatePINForBidder:
//            return stubbedResponse("CreatePINForBidder")
//            
//        case ActiveAvailableMouves:
//            return stubbedResponse("ActiveAvailableMouves")
//            
//        case MyMouves:
//            return stubbedResponse("MyMouves")
//            
//        case RegisterToBid:
//            return stubbedResponse("RegisterToBid")
//            
//        case MyBiddersForAuction:
//            return stubbedResponse("MyBiddersForAuction")
//            
//        case Me:
//            return stubbedResponse("Me")
//            
//        case UpdateMe:
//            return stubbedResponse("Me")
//            
//        case CreateUser:
//            return stubbedResponse("Me")
//            
//            // This API returns a 302, so stubbed response isn't valid
//        case FindBidderRegistration:
//            return stubbedResponse("Me")
//            
//        case PlaceABid:
//            return stubbedResponse("CreateABid")
//            
//        case Artwork:
//            return stubbedResponse("Artwork")
//            
//        case Artist:
//            return stubbedResponse("Artist")
//            
//        case MouveInfo:
//            return stubbedResponse("MouveInfo")
//            
//        case RegisterCard:
//            return stubbedResponse("RegisterCard")
//            
//        case BidderDetailsNotification:
//            return stubbedResponse("RegisterToBid")
//            
//        case LostPasswordNotification:
//            return stubbedResponse("ForgotPassword")
//            
//        case FindExistingEmailRegistration:
//            return stubbedResponse("ForgotPassword")
//            
//        case MouveInfoForArtwork:
//            return stubbedResponse("MouveInfoForArtwork")
//            
//        case MyBidPositionsForAuctionArtwork:
//            return stubbedResponse("MyBidPositionsForAuctionArtwork")
//            
//        case Ping:
//            return stubbedResponse("Ping")
            
        }
    }
}

//// MARK: - Provider setup
//
//public func endpointResolver () -> ((endpoint: Endpoint<ArtsyAPI>) -> (NSURLRequest)) {
//    return { (endpoint: Endpoint<ArtsyAPI>) -> (NSURLRequest) in
//        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
//        request.HTTPShouldHandleCookies = false
//        return request
//    }
//}
//
//public class MouveProvider<T where T: MoyaTarget>: ReactiveMoyaProvider<T> {
//    public typealias OnlineSignalClosure = () -> RACSignal
//    
//    // Closure that returns a signal which completes once the app is online.
//    public let onlineSignal: OnlineSignalClosure
//    
//    public init(endpointsClosure: MoyaEndpointsClosure = MoyaProvider.DefaultEndpointMapping(), endpointResolver: MoyaEndpointResolution = MoyaProvider.DefaultEnpointResolution(), stubResponses: Bool = false, stubBehavior: MoyaStubbedBehavior = MoyaProvider.DefaultStubBehavior, networkActivityClosure: Moya.NetworkActivityClosure? = nil, onlineSignal: OnlineSignalClosure = connectedToInternetSignal) {
//        self.onlineSignal = onlineSignal
//        super.init(endpointsClosure: endpointsClosure, endpointResolver: endpointResolver, stubResponses: stubResponses, networkActivityClosure: networkActivityClosure)
//    }
//}
//
//public struct Provider {
//    private static var endpointsClosure = { (target: ArtsyAPI) -> Endpoint<ArtsyAPI> in
//        
//        var endpoint: Endpoint<ArtsyAPI> = Endpoint<ArtsyAPI>(URL: url(target), sampleResponse: .Success(200, {target.sampleData}), method: target.method, parameters: target.parameters)
//        // Sign all non-XApp token requests
//        
//        switch target {
//        case .XApp:
//            return endpoint
//        case .XAuth:
//            return endpoint
//            
//        default:
//            return endpoint.endpointByAddingHTTPHeaderFields(["X-Xapp-Token": XAppToken().token ?? ""])
//        }
//    }
//    
//    public static func DefaultProvider() -> MouveProvider<MouveREST > {
//        return MouveProvider(endpointsClosure: endpointsClosure, endpointResolver: endpointResolver(), stubResponses: APIKeys.sharedKeys.stubResponses)
//    }
//    
//    public static func StubbingProvider() -> MouveProvider<MouveREST > {
//        return MouveProvider(endpointsClosure: endpointsClosure, endpointResolver: endpointResolver(), stubResponses: true, onlineSignal: { RACSignal.empty() })
//    }
//    
//    private struct SharedProvider {
//        static var instance = Provider.DefaultProvider()
//    }
//    
//    public static var sharedProvider: MouveProvider<MouveREST> {
//        get {
//        return SharedProvider.instance
//        }
//        
//        set (newSharedProvider) {
//            SharedProvider.instance = newSharedProvider
//        }
//    }
//}
//
//
//// MARK: - Provider support
//
//private func stubbedResponse(filename: String) -> NSData! {
//    @objc class TestClass { }
//    
//    let bundle = NSBundle(forClass: TestClass.self)
//    let path = bundle.pathForResource(filename, ofType: "json")
//    return NSData(contentsOfFile: path!)
//}
//
//private extension String {
//    var URLEscapedString: String {
//        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
//    }
//}
//
//public func url(route: MoyaTarget) -> String {
//    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString!
//}
