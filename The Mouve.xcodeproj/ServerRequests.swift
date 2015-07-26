import Alamofire

let rootURL = "http://test.fyshbowlapp.com"

func getHTTPGetRequest(url: String, addURLToRoot: Bool) -> NSMutableURLRequest {
    var URL: NSURL?
    if(addURLToRoot) {
        URL = NSURL(string: rootURL + url)!
    }
    else {
        URL = NSURL(string: url)!
    }
    var request = NSMutableURLRequest(URL: URL!)
    request.HTTPMethod = "GET"
    var err: NSError?
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Token "+getToken(), forHTTPHeaderField: "Authorization")
    return request
}

func getHTTPPostRequest(url: String, parameters: [String: AnyObject]) -> NSMutableURLRequest {
    let URL = NSURL(string: rootURL + url)!
    var request = NSMutableURLRequest(URL: URL)
    request.HTTPMethod = "POST"
    var err: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &err)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Token "+getToken(), forHTTPHeaderField: "Authorization")
    return request
}

func getHTTPPatchRequest(url: String, parameters: [String: AnyObject]) -> NSMutableURLRequest {
    let URL = NSURL(string: rootURL + url)!
    var request = NSMutableURLRequest(URL: URL)
    request.HTTPMethod = "PATCH"
    var err: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &err)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Token "+getToken(), forHTTPHeaderField: "Authorization")
    return request
}

func getHTTPDeleteRequest(url: String) -> NSMutableURLRequest {
    let URL = NSURL(string: rootURL + url)!
    var request = NSMutableURLRequest(URL: URL)
    request.HTTPMethod = "DELETE"
    var err: NSError?
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Token "+getToken(), forHTTPHeaderField: "Authorization")
    return request
}

func getJSONFromData(data: AnyObject) -> JSON {
    let myNSData = data as NSData
    let myNSString = NSString(data: myNSData, encoding: NSUTF8StringEncoding)
    let data = myNSString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let jsonObject = JSON(data: data!)
    return jsonObject
}