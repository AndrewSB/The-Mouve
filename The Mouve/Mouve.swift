import UIKit
import KeychainAccess
import Alamofire
import Foundation

struct geoLoc {
    var name: String
    var lng: Float
    var lat: Float
}


class mouveRequestsController{
    let manager = Alamofire.sharedInstance.Manager
    func createMouve(name: String,
                    details: String,
                    privacy: Bool,
                    startTime: NSDate,
                    endTime: NSDate,
                    location: geoLoc){
        let URL = NSURL(string: rootURL + "/auth/logout/")!

        request.HTTPMethod = "POST"
        Alamofire.request(request)
            .response {(request, response, data, error) in
                userCredentials.sharedInstance.clearKeychain()
        }
    }
    class var sharedInstance: userRequestsController{
        struct Static {
            static let instance = userRequestsController()
        }
        return Static.instance
    }
}