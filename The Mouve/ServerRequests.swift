//import Alamofire
//import SwiftyJSON
//
//let rootURL = "http://mouve.ngrok.io"
//
//func getHTTPGetRequest(url: String, addURLToRoot: Bool) -> NSMutableURLRequest {
//    var URL: NSURL?
//    if(addURLToRoot) {
//        URL = NSURL(string: rootURL + url)!
//    }
//    else {
//        URL = NSURL(string: url)!
//    }
//    let request = NSMutableURLRequest(URL: URL!)
//    request.HTTPMethod = "GET"
//    var err: NSError?
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
//    return request
//}
//
//func getHTTPPostRequest(url: String, parameters: [String: AnyObject]) -> NSMutableURLRequest {
//    let URL = NSURL(string: rootURL + url)!
//    let request = NSMutableURLRequest(URL: URL)
//    request.HTTPMethod = "POST"
//    var err: NSError?
//    do {
//        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
//    } catch let error as NSError {
//        err = error
//        request.HTTPBody = nil
//    }
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
//    return request
//}
//
//func getHTTPPatchRequest(url: String, parameters: [String: AnyObject]) -> NSMutableURLRequest {
//    let URL = NSURL(string: rootURL + url)!
//    let request = NSMutableURLRequest(URL: URL)
//    request.HTTPMethod = "PATCH"
//    var err: NSError?
//    do {
//        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
//    } catch let error as NSError {
//        err = error
//        request.HTTPBody = nil
//    }
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
//    return request
//}
//
//func getHTTPDeleteRequest(url: String) -> NSMutableURLRequest {
//    let URL = NSURL(string: rootURL + url)!
//    let request = NSMutableURLRequest(URL: URL)
//    request.HTTPMethod = "DELETE"
//    var err: NSError?
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue(userCredentials.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
//    return request
//}
//
//func getJSONFromData(data: AnyObject) -> JSON {
//    let myNSData = data as! NSData
//    let myNSString = NSString(data: myNSData, encoding: NSUTF8StringEncoding)
//    let data = myNSString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//    let jsonObject = JSON(data: data!)
//    return jsonObject
//}