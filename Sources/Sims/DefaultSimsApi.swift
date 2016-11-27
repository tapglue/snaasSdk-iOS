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
    
    init(url: String, environment: Environment) {
        self.url = url
        self.environment = environment
    }

    func registerDevice(_ appToken: String, deviceToken: String, sessionToken: String) {
        let authorizationToken = appToken + ":" + sessionToken
        let utf8authToken = authorizationToken.data(using: String.Encoding.utf8)
        let encodedAuthString = utf8authToken?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue:0))
        let language = Locale.preferredLanguages[0]
        let headers = [
            "Authorization": "Basic " + encodedAuthString!,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        let parameters = ["token": deviceToken,
                          "platform": environment.rawValue,
                          "language": language] as [String : Any]

        let idfv = UIDevice.current.identifierForVendor?.uuidString
        let URL = Foundation.URL(string: self.url + self.deviceRegistrationPath + idfv!)!

        var request = URLRequest(url: URL)
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
}
