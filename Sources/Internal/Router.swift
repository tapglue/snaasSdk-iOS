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
    
    private static var baseUrl = "https://api.tapglue.com/0.4"
    private static var appToken = ""
    static var sessionToken = ""
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
        
        if method == .POST || method == .PUT{
            return Alamofire.ParameterEncoding.JSON.encode(request, parameters: payload).0
        } else {
            return request
        }
    }

    class func post(path: String, payload: [String: AnyObject]) -> NSMutableURLRequest {
        return Router(method: .POST, path: path, payload: payload).URLRequest
    }

    class func get(path: String) -> NSMutableURLRequest {
        return Router(method: .GET, path: path, payload: [:]).URLRequest
    }

    class func put(path: String, payload: [String: AnyObject]) -> NSMutableURLRequest {
        return Router(method: .PUT, path: path, payload: payload).URLRequest
    }

    class func delete(path: String) -> NSMutableURLRequest {
        return Router(method: .DELETE, path: path, payload: [:]).URLRequest
    }

    private init(method: Alamofire.Method, path: String, payload: [String: AnyObject]) {
        self.method = method
        self.path = path
        self.payload = payload
    }
}