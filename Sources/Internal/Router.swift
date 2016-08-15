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
                baseUrl = configuration.baseUrl + Router.apiVersion
                appToken = configuration.appToken
            }
        }
    }
    
    static let sdkVersion = "2.0.0"
    static var sessionTokenListener: SessionTokenListener? {
        didSet {
            if let sessionToken = sessionToken {
                if let sessionTokenListener = sessionTokenListener {
                    sessionTokenListener.sessionTokenSet(sessionToken)
                }
            }
        }
    }
    private static let apiVersion = "/0.4"
    private static var baseUrl = "https://api.tapglue.com/0.4"
    private static var appToken = ""
    static var sessionToken: String? {
        didSet {
            if let sessionTokenListener = sessionTokenListener {
                sessionTokenListener.sessionTokenSet(sessionToken)
            }
        }
    }
    let method: Alamofire.Method
    let path: String
    let payload: [String: AnyObject]
    var encodedToken: String {
        return Encoder.encode(Router.appToken, sessionToken: Router.sessionToken ?? "")
    }

    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseUrl + path)!
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = method.rawValue
        request.setValue("Basic " + encodedToken, forHTTPHeaderField: "Authorization")
        request.setValue("iOS", forHTTPHeaderField: "X-Tapglue-OS")
        request.setValue("Apple", forHTTPHeaderField: "X-Tapglue-Manufacturer")
        request.setValue(Router.sdkVersion, forHTTPHeaderField: "X-Tapglue-SDKVersion")
        request.setValue(NSTimeZone.localTimeZone().abbreviation ?? "", 
            forHTTPHeaderField: "X-Tapglue-Timezone")
        request.setValue(UIDevice.currentDevice().identifierForVendor?.UUIDString ?? "", forHTTPHeaderField: "X-Tapglue-IDFV")
        request.setValue(UIDevice.currentDevice().tapglueModelName, forHTTPHeaderField: "X-Tapglue-Model")
        request.setValue(UIDevice.currentDevice().systemVersion, forHTTPHeaderField: "X-Tapglue-OSVersion")
        
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

protocol SessionTokenListener {
    func sessionTokenSet(sessionToken: String?)
}