import Foundation
import Moya

/// Request to fetch and store new XApp token if the current token is missing or expired.

private func UserAuthTokenRequest(defaults: NSUserDefaults) {

    // I don't like an extension of a class referencing what is essentially a singleton of that class.
    var userToken = UserAuthToken(defaults: defaults)

    let newAuth = Provider.sharedProvider.request(MouveREST.AuthUser).filterSuccessfulStatusCodes().mapJSON().doNext({ (response)
        if let dictionary = response as? NSDictionary {
            userToken.token = dictionary["token"] as? String
//            userToken.expiry = NSDate.dateFromISOString(dictionary["expires_in"] as? String)
        }
    }).logError().ignoreValues()

    // Signal that returns whether our current token is valid
    let validTokenSignal = RACSignal.`return`(appToken.isValid)

    // If the token is valid, just return an empty signal, otherwise return a signal that fetches new tokens
    return RACSignal.`if`(validTokenSignal, then: RACSignal.empty(), `else`: newTokenSignal)
}

/// Request to fetch a given target. Ensures that valid XApp tokens exist before making request
public func XAppRequest(token: ArtsyAPI, provider: ArtsyProvider<ArtsyAPI> = Provider.sharedProvider, defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()) -> RACSignal {

    return provider.onlineSignal().then {
        // First perform UserAuthTokenRequest(). When it completes, then the signal returned from the closure will be subscribed to.
        UserAuthTokenRequest(defaults).then {
            return provider.request(token)
        }
    }
}