//
//  Router.swift
//  Tapglue
//
//  Created by John Nilsen on 7/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Alamofire

class Router: URLRequestConvertible {

    static let baseUrl = "https://api.tapglue.com"
    let method: Alamofire.Method
    let path: String
    let payload: [String: AnyObject]

    var URLRequest: NSMutableURLRequest {
       let URL = NSURL(string: Router.baseUrl)!
       let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
       request.HTTPMethod = method.rawValue
        
       return Alamofire.ParameterEncoding.JSON.encode(request, parameters: payload).0
    }

    static func post(path: String, payload: [String: AnyObject]) -> NSMutableURLRequest {
        return Router(method: .POST, path: path, payload: payload).URLRequest
    }

    private init(method: Alamofire.Method, path: String, payload: [String: AnyObject]) {
        self.method = method
        self.path = path
        self.payload = payload
    }
}