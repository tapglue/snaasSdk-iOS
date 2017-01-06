//
//  Router.swift
//  Tapglue
//
//  Created by John Nilsen on 7/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

class Router {


    static var configuration: Configuration? {
        didSet {
            if let configuration = configuration {
                baseUrl = configuration.baseUrl + Router.apiVersion
                appToken = configuration.appToken
            }
        }
    }
    
    static let sdkVersion = "2.3.0"
    static var sessionTokenListener: SessionTokenListener? {
        didSet {
            if let sessionToken = sessionToken {
                if let sessionTokenListener = sessionTokenListener {
                    sessionTokenListener.sessionTokenSet(sessionToken)
                }
            }
        }
    }
    fileprivate static let apiVersion = "/0.4"
    fileprivate static var baseUrl = "https://api.tapglue.com/0.4"
    fileprivate static var appToken = ""
    static var sessionToken: String? {
        didSet {
            if let sessionTokenListener = sessionTokenListener {
                sessionTokenListener.sessionTokenSet(sessionToken)
            }
        }
    }
    let method: Method
    let path: String
    let payload: [String: AnyObject]
    var encodedToken: String {
        return Encoder.encode(Router.appToken, sessionToken: Router.sessionToken ?? "")
    }

    var urlRequest: URLRequest {
        let URL = Foundation.URL(string: Router.baseUrl + path)!
        var request = URLRequest(url: URL)
        //let request = NSMutableURLRequest(url: URL)
        request.httpMethod = method.rawValue
        request.setValue("Basic " + encodedToken, forHTTPHeaderField: "Authorization")
        request.setValue("iOS", forHTTPHeaderField: "X-Tapglue-OS")
        request.setValue("Apple", forHTTPHeaderField: "X-Tapglue-Manufacturer")
        request.setValue(Router.sdkVersion, forHTTPHeaderField: "X-Tapglue-SDKVersion")
        request.setValue(TimeZone.ReferenceType.local.abbreviation() ?? "",
            forHTTPHeaderField: "X-Tapglue-Timezone")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forHTTPHeaderField: "X-Tapglue-IDFV")
        request.setValue(UIDevice.current.tapglueModelName, forHTTPHeaderField: "X-Tapglue-Model")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "X-Tapglue-OSVersion")
        
        if method == .post || method == .put{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                return request
            } catch {
                return request
            }
        } else {
            return request
        }
    }

    class func post(_ path: String, payload: [String: AnyObject]) -> URLRequest {
        return Router(method: .post, path: path, payload: payload).urlRequest
    }

    class func get(_ path: String) -> URLRequest {
        return Router(method: .get, path: path, payload: [:]).urlRequest
    }

    class func put(_ path: String, payload: [String: AnyObject]) -> URLRequest {
        return Router(method: .put, path: path, payload: payload).urlRequest
    }

    class func delete(_ path: String) -> URLRequest {
        return Router(method: .delete, path: path, payload: [:]).urlRequest
    }

    class func getOnURL(_ url: String) -> URLRequest {
        var request = Router(method: .get, path: "", payload: [:]).urlRequest
        request.url = URL(string: url)
        return request
    }

    class func postOnURL(_ url: String, payload: [String: AnyObject]) -> URLRequest {
        var request = Router(method: .post, path: "", payload: payload).urlRequest
        request.url = URL(string: url)
        return request
    }

    fileprivate init(method: Method, path: String, payload: [String: AnyObject]) {
        self.method = method
        self.path = path
        self.payload = payload
    }
}

enum Method: String {
    case get = "get", post = "post", put = "put", delete = "delete"
}

protocol SessionTokenListener {
    func sessionTokenSet(_ sessionToken: String?)
}
