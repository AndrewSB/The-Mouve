import UIKit
import KeychainAccess
import Alamofire
import Foundation
import SwiftyJSON

struct geoLoc {
    var name: String
    var lng: Float
    var lat: Float
}


class mouveRequestsController{
    let manager = Alamofire.Manager.sharedInstance
    
    
    func createMouve(name: String,
                    details: String,
                    privacy: Bool,
                    startTime: String,
                    endTime: String,
                    location: String){
        let URL:String = (rootURL + "/api/mouves")
        manager.session.configuration.HTTPAdditionalHeaders = [
        "Authorization": userCredentials.sharedInstance.getToken()
                        ]
        // JSON Body
        let startDate = NSDate()
        let endDate = NSDate()
        let bodyParameters = [
            "name": name,
            "details": details,
            "privacy": privacy ? "private" : "public",
            "startTime": NSDate.ISOStringFromDate(startDate),
            "endTime": NSDate.ISOStringFromDate(endDate),
            "location": location
        ]
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.POST, URL, parameters: bodyParameters, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println("Couldn't create Mouve")
                    println(error)
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                    println("Created \(name) successfully")
                    println(parsed)
                }
        }
    }
    
    
    func updateMouve(name: String,
                    details: String,
                    privacy: Bool,
                    startTime: NSDate,
                    endTime: NSDate,
                    location: String,
                    id: String){
            let URL:String = (rootURL + "/api/mouves/\(id)")
            // JSON Body
            let bodyParameters = [
                "name": name,
                "details": details,
                "privacy": privacy,
                "startTime": startTime,
                "endTime": endTime,
                "location": location
            ]
            let encoding = Alamofire.ParameterEncoding.JSON
            manager.request(.PUT, URL, parameters: bodyParameters, encoding: encoding)
                .validate(statusCode: 200..<401)
                .responseJSON {(request, response, json, error) in
                    if let anError = error
                    {
                        println("Couldn't update Mouve")
                        println(error)
                    }
                    else if let json: AnyObject = json
                    {
                        let parsed = JSON(json)
                        println("Updated \(name) successfully")
                    }
            }
    }
    
    func myPlannedMouves(){
            let URL:String = (rootURL + "/api/mouves/planned")
            // JSON Body
            let encoding = Alamofire.ParameterEncoding.JSON
            manager.request(.GET, URL, encoding: encoding)
                .validate(statusCode: 200..<401)
                .responseJSON {(request, response, json, error) in
                    if let anError = error
                    {
                        println("Couldn't load Mouve list")
                        println(error)
                    }
                    else if let json: AnyObject = json
                    {
                        let parsed = JSON(json)
                        println("Here are Mouves you have planned")
                    }
            }
    }
    
    func delMouve(id: String){
        let URL:String = (rootURL + "/api/mouves/\(id)")
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": userCredentials.sharedInstance.getToken()
        ]
        // JSON Body
        let bodyParameters = []
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.DELETE, URL, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println("Couldn't delete Mouve")
                    println(error)
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                    println("Mouve Deleted")
                }
        }
    }
    
    func attendMouve(id: String){
        let URL:String = (rootURL + "/api/mouves/\(id)/attend")
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": userCredentials.sharedInstance.getToken()
        ]
        // JSON Body
        let bodyParameters = []
        let encoding = Alamofire.ParameterEncoding.JSON
        manager.request(.POST, URL, encoding: encoding)
            .validate(statusCode: 200..<401)
            .responseJSON {(request, response, json, error) in
                if let anError = error
                {
                    println("Couldn't attend Mouve")
                    println(error)
                }
                else if let json: AnyObject = json
                {
                    let parsed = JSON(json)
                    println("You'll attend this Mouve")
                }
        }
    }
    class var sharedInstance: mouveRequestsController{
        struct Static {
            static let instance = mouveRequestsController()
        }
        return Static.instance
    }
    
}