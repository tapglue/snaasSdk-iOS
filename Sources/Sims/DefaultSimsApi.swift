//
//  DefaultSimsApi.swift
//  simsTest
//
//  Created by John Nilsen on 5/19/16.
//  Copyright © 2016 John Nilsen. All rights reserved.
//

import Foundation

class DefaultSimsApi: SimsApi {
    
    let url: String
    let deviceRegistrationPath = "/0.4/me/devices/"
    let environment: Environment

    var deviceUrl: URL {
        get {
            let idfv = UIDevice.current.identifierForVendor?.uuidString
            return Foundation.URL(string: self.url + self.deviceRegistrationPath + idfv!)!
        }
    }

    init(url: String, environment: Environment) {
        self.url = url
        self.environment = environment
    }

    func registerDevice(_ appToken: String, deviceToken: String, sessionToken: String) {
        let language = Locale.preferredLanguages[0]
        let headers = generateGenericHeaders(appToken: appToken, sessionToken: sessionToken)
        let parameters = ["token": deviceToken,
                          "platform": environment.rawValue,
                          "language": language] as [String : Any]

        var request = URLRequest(url: deviceUrl)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "put"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])

            let session = URLSession.shared
            var task: URLSessionDataTask?
            log(request)
            task = session.dataTask(with: request) { (data: Data?, response:URLResponse?, error:Error?) in
                log(response ?? "SIMS: no response")
            }

            task?.resume()
        } catch {
            return
        }
    }

    func unregisterDevice(_ appToken: String, deviceToken: String, sessionToken: String) {
        let headers = generateGenericHeaders(appToken: appToken, sessionToken: sessionToken)

        var request = URLRequest(url: deviceUrl)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "delete"
        let session = URLSession.shared
        var task: URLSessionDataTask?
        log(request)
        task = session.dataTask(with: request) { (data: Data?, response:URLResponse?, error:Error?) in
            log(response ?? "SIMS: no response")
        }

        task?.resume()
    }

    fileprivate func generateGenericHeaders(appToken: String, sessionToken: String) -> 
        [String: String] {
        return [
            "Authorization": generateAuthToken(appToken: appToken, sessionToken: sessionToken),
            "Accept": "application/json",
            "Content-Type": "application/json"
            ]
        }

    fileprivate func generateAuthToken(appToken: String, sessionToken: String) -> String {
        let authorizationToken = appToken + ":" + sessionToken
        let utf8authToken = authorizationToken.data(using: String.Encoding.utf8)
        let encodedAuthString = utf8authToken?.base64EncodedString(options:
            Data.Base64EncodingOptions(rawValue:0))
        return "Basic " + encodedAuthString!
    }
}
