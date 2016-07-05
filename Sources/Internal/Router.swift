//
//  Router.swift
//  Tapglue
//
//  Created by John Nilsen on 7/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Alamofire

class Router: URLRequestConvertible {

    static var configuration: Configuration? {
        didSet {
            if let configuration = configuration {
                baseUrl = configuration.baseUrl
                appToken = configuration.appToken
            }
        }
    }
    
    private static var baseUrl = "https://api.tapglue.com"
    private static var appToken = ""
    private static var sessionToken = ""
    private static var headers = ["Authorization":"Basic ",
                          "User-Agent": "TapglueSDKExample",
                          "Accept":"Application/json"]
    
    let method: Alamofire.Method
    let path: String
    let payload: [String: AnyObject]
    var encodedToken: String {
        return Encoder.encode(Router.appToken, sessionToken: Router.sessionToken)
    }

    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseUrl)!
        let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        request.HTTPMethod = method.rawValue
        request.setValue("Basic " + encodedToken, forHTTPHeaderField: "Authorization")
        
        
        return Alamofire.ParameterEncoding.JSON.encode(request, parameters: payload).0
    }

    class func post(path: String, payload: [String: AnyObject]) -> NSMutableURLRequest {
        return Router(method: .POST, path: path, payload: payload).URLRequest
    }

    private init(method: Alamofire.Method, path: String, payload: [String: AnyObject]) {
        self.method = method
        self.path = path
        self.payload = payload
    }
}