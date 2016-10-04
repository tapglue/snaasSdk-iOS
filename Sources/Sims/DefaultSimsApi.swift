//
//  DefaultSimsApi.swift
//  simsTest
//
//  Created by John Nilsen on 5/19/16.
//  Copyright © 2016 John Nilsen. All rights reserved.
//

import Foundation
import Alamofire

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
        let encodedAuthString = utf8authToken?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue:0))
        let language = Locale.preferredLanguages[0]
        let headers = [
            "Authorization": "Basic " + encodedAuthString!,
            "Accept": "application/json"
        ]
        let parameters = ["token": deviceToken,
                          "platform": environment.rawValue,
                          "language": language] as [String : Any]
        
        let idfv = UIDevice.current.identifierForVendor?.uuidString
        _ = Alamofire.request(url + deviceRegistrationPath + idfv!, method: HTTPMethod.put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
        }
    }
}
