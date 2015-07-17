//
//  NetworkTargets.swift
//  The Mouve
//
//  Created by Hilal Habashi on 7/17/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import Moya
//
public enum MouveREST {
    // Auth
    case XApp
    case XAuth(email: String, password: String)
    case TrustToken(number: String, auctionPIN: String)
        //Users
    case Me
    case UpdateMe(name: String, username: String, email: String, password: String)
    case CreateUser(email: String, password: String, phone: String, postCode: String, name: String)
    case FollowUser(user_id: String)
    case UnfollowUser(user_id: String)
    case MyMouves

    //// Mouves --------------------------------------------------------------------
    case AvailableMouves
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
    case Invitees(mouve_id: String)
    case InvitePerson(mouve_id: String, user_id: String)
    case DeleteInvite(mouve_id: String, user_id: String)
    

    
    case RegisterCard(stripeToken: String)
    
    case BidderDetailsNotification(auctionID: String, identifier: String)
    
    case LostPasswordNotification(email: String)
    case FindExistingEmailRegistration(email: String)
}

extension MouveREST : MoyaPath {
    public var path: String {
        switch self {
            
        case XApp:
            return "/api/v1/xapp_token"
            
        case XAuth:
            return "/oauth2/access_token"
            
        case MouveInfo(let id):
            return "/api/v1/sale/\(id)"
            
        case AvailableMouves:
            return "/api/v1/sales"
            
        case AuctionListings(let id, _, _):
            return "/api/v1/sale/\(id)/sale_artworks"
            
        case MouveInfoForArtwork(let auctionID, let artworkID):
            return "/api/v1/sale/\(auctionID)/sale_artwork/\(artworkID)"
            
        case SystemTime:
            return "/api/v1/system/time"
            
        case Ping:
            return "/api/v1/system/ping"
            
        case RegisterToBid:
            return "/api/v1/bidder"
            
        case MyMouves:
            return "/api/v1/me/credit_cards"
            
        case CreatePINForBidder(let bidderID):
            return "/api/v1/bidder/\(bidderID)/pin"
            
        case ActiveAvailableMouves:
            return "/api/v1/sales"
            
        case Me:
            return "/api/v1/me"
            
        case UpdateMe:
            return "/api/v1/me"
            
        case CreateUser:
            return "/api/v1/user"
            
        case MyBiddersForAuction:
            return "/api/v1/me/bidders"
            
        case MyBidPositionsForAuctionArtwork:
            return "/api/v1/me/bidder_positions"
            
        case Artwork(let id):
            return "/api/v1/artwork/\(id)"
            
        case Artist(let id):
            return "/api/v1/artist/\(id)"
            
        case FindBidderRegistration:
            return "/api/v1/bidder"
            
        case PlaceABid:
            return "/api/v1/me/bidder_position"
            
        case RegisterCard:
            return "/api/v1/me/credit_cards"
            
        case TrustToken:
            return "/api/v1/me/trust_token"
            
        case BidderDetailsNotification:
            return "/api/v1/bidder/bidding_details_notification"
            
        case LostPasswordNotification:
            return "/api/v1/users/send_reset_password_instructions"
            
        case FindExistingEmailRegistration:
            return "/api/v1/user"
            
        }
    }
}

extension ArtsyAPI : MoyaTarget {
    
    public var base: String { return AppSetup.sharedState.useStaging ? "https://stagingapi.artsy.net" : "https://api.artsy.net" }
    public var baseURL: NSURL { return NSURL(string: base)! }
    
    public var parameters: [String: AnyObject] {
        switch self {
            
        case XAuth(let email, let password):
            return [
                "client_id": APIKeys.sharedKeys.key ?? "",
                "client_secret": APIKeys.sharedKeys.secret ?? "",
                "email": email,
                "password":  password,
                "grant_type": "credentials"
            ]
            
        case XApp:
            return ["client_id": APIKeys.sharedKeys.key ?? "",
                "client_secret": APIKeys.sharedKeys.secret ?? ""]
            
        case AvailableMouves:
            return ["is_auction": "true"]
            
        case RegisterToBid(let auctionID):
            return ["sale_id": auctionID]
            
        case MyBiddersForAuction(let auctionID):
            return ["sale_id": auctionID]
            
        case PlaceABid(let auctionID, let artworkID, let maxBidCents):
            return [
                "sale_id": auctionID,
                "artwork_id":  artworkID,
                "max_bid_amount_cents": maxBidCents
            ]
            
        case TrustToken(let number, let auctionID):
            return ["number": number, "auction_pin": auctionID]
            
        case CreateUser(let email, let password,let phone,let postCode, let name):
            return [
                "email": email, "password": password,
                "phone": phone, "name": name,
                "location": [ "postal_code": postCode ]
            ]
            
        case UpdateMe(let email, let phone,let postCode, let name):
            return [
                "email": email, "phone": phone,
                "name": name, "location": [ "postal_code": postCode ]
            ]
            
        case RegisterCard(let token):
            return ["provider": "stripe", "token": token]
            
        case FindBidderRegistration(let auctionID, let phone):
            return ["sale_id": auctionID, "number": phone]
            
        case BidderDetailsNotification(let auctionID, let identifier):
            return ["sale_id": auctionID, "identifier": identifier]
            
        case LostPasswordNotification(let email):
            return ["email": email]
            
        case FindExistingEmailRegistration(let email):
            return ["email": email]
            
        case AuctionListings(_, let page, let pageSize):
            return ["size": pageSize, "page": page]
            
        case ActiveAvailableMouves:
            return ["is_auction": true, "live": true]
            
        case MyBidPositionsForAuctionArtwork(let auctionID, let artworkID):
            return ["sale_id": auctionID, "artwork_id": artworkID]
            
        default:
            return [:]
        }
    }
    
    public var method: Moya.Method {
        //TODO:
        switch self {
        case .LostPasswordNotification,
        .CreateUser,
        .PlaceABid,
        .RegisterCard,
        .RegisterToBid,
        .CreatePINForBidder:
            return .POST
        case .FindExistingEmailRegistration:
            return .HEAD
        case .UpdateMe,
        .BidderDetailsNotification:
            return .PUT
        default:
            return .GET
        }
    }
    
    public var sampleData: NSData {
        switch self {
            
        case XApp:
            return stubbedResponse("XApp")
            
        case XAuth:
            return stubbedResponse("XAuth")
            
        case TrustToken:
            return stubbedResponse("XAuth")
            
        case AvailableMouves:
            return stubbedResponse("AvailableMouves")
            
        case AuctionListings:
            return stubbedResponse("AuctionListings")
            
        case SystemTime:
            return stubbedResponse("SystemTime")
            
        case CreatePINForBidder:
            return stubbedResponse("CreatePINForBidder")
            
        case ActiveAvailableMouves:
            return stubbedResponse("ActiveAvailableMouves")
            
        case MyMouves:
            return stubbedResponse("MyMouves")
            
        case RegisterToBid:
            return stubbedResponse("RegisterToBid")
            
        case MyBiddersForAuction:
            return stubbedResponse("MyBiddersForAuction")
            
        case Me:
            return stubbedResponse("Me")
            
        case UpdateMe:
            return stubbedResponse("Me")
            
        case CreateUser:
            return stubbedResponse("Me")
            
            // This API returns a 302, so stubbed response isn't valid
        case FindBidderRegistration:
            return stubbedResponse("Me")
            
        case PlaceABid:
            return stubbedResponse("CreateABid")
            
        case Artwork:
            return stubbedResponse("Artwork")
            
        case Artist:
            return stubbedResponse("Artist")
            
        case MouveInfo:
            return stubbedResponse("MouveInfo")
            
        case RegisterCard:
            return stubbedResponse("RegisterCard")
            
        case BidderDetailsNotification:
            return stubbedResponse("RegisterToBid")
            
        case LostPasswordNotification:
            return stubbedResponse("ForgotPassword")
            
        case FindExistingEmailRegistration:
            return stubbedResponse("ForgotPassword")
            
        case MouveInfoForArtwork:
            return stubbedResponse("MouveInfoForArtwork")
            
        case MyBidPositionsForAuctionArtwork:
            return stubbedResponse("MyBidPositionsForAuctionArtwork")
            
        case Ping:
            return stubbedResponse("Ping")
            
        }
    }
}

// MARK: - Provider setup

public func endpointResolver () -> ((endpoint: Endpoint<ArtsyAPI>) -> (NSURLRequest)) {
    return { (endpoint: Endpoint<ArtsyAPI>) -> (NSURLRequest) in
        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
        request.HTTPShouldHandleCookies = false
        return request
    }
}

public class ArtsyProvider<T where T: MoyaTarget>: ReactiveMoyaProvider<T> {
    public typealias OnlineSignalClosure = () -> RACSignal
    
    // Closure that returns a signal which completes once the app is online.
    public let onlineSignal: OnlineSignalClosure
    
    public init(endpointsClosure: MoyaEndpointsClosure = MoyaProvider.DefaultEndpointMapping(), endpointResolver: MoyaEndpointResolution = MoyaProvider.DefaultEnpointResolution(), stubResponses: Bool = false, stubBehavior: MoyaStubbedBehavior = MoyaProvider.DefaultStubBehavior, networkActivityClosure: Moya.NetworkActivityClosure? = nil, onlineSignal: OnlineSignalClosure = connectedToInternetSignal) {
        self.onlineSignal = onlineSignal
        super.init(endpointsClosure: endpointsClosure, endpointResolver: endpointResolver, stubResponses: stubResponses, networkActivityClosure: networkActivityClosure)
    }
}

public struct Provider {
    private static var endpointsClosure = { (target: ArtsyAPI) -> Endpoint<ArtsyAPI> in
        
        var endpoint: Endpoint<ArtsyAPI> = Endpoint<ArtsyAPI>(URL: url(target), sampleResponse: .Success(200, {target.sampleData}), method: target.method, parameters: target.parameters)
        // Sign all non-XApp token requests
        
        switch target {
        case .XApp:
            return endpoint
        case .XAuth:
            return endpoint
            
        default:
            return endpoint.endpointByAddingHTTPHeaderFields(["X-Xapp-Token": XAppToken().token ?? ""])
        }
    }
    
    public static func DefaultProvider() -> ArtsyProvider<ArtsyAPI> {
        return ArtsyProvider(endpointsClosure: endpointsClosure, endpointResolver: endpointResolver(), stubResponses: APIKeys.sharedKeys.stubResponses)
    }
    
    public static func StubbingProvider() -> ArtsyProvider<ArtsyAPI> {
        return ArtsyProvider(endpointsClosure: endpointsClosure, endpointResolver: endpointResolver(), stubResponses: true, onlineSignal: { RACSignal.empty() })
    }
    
    private struct SharedProvider {
        static var instance = Provider.DefaultProvider()
    }
    
    public static var sharedProvider: ArtsyProvider<ArtsyAPI> {
        get {
        return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
    }
}


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
//// Users ---------------------------------------------------------------------
//app.get('/api/users/:id', users.crud.get)
//app.post('/api/users', users.crud.create)
//app.put('/api/users', users.middleware.isLoggedIn, users.crud.updatePassword)
//app.get('/api/users/mouves', users.middleware.isLoggedIn, mouves.crud.all)
//
//// Auth ----------------------------------------------------------------------
//app.post('/api/users/auth', users.auth.login)
//app.delete('/api/users/auth', users.middleware.isLoggedIn, users.auth.logout)
//
//// Follow --------------------------------------------------------------------
//app.put('/api/users/:user_id/follow', users.middleware.isLoggedIn, users.middleware.isValid, users.relations.follow)
//app.put('/api/users/:user_id/unfollow', users.middleware.isLoggedIn, users.middleware.isValid, users.relations.unfollow)
//
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

