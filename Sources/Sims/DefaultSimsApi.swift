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

    func registerDevice(appToken: String, deviceToken: String, sessionToken: String) {
        let authorizationToken = appToken + ":" + sessionToken
        let utf8authToken = authorizationToken.dataUsingEncoding(NSUTF8StringEncoding)
        let encodedAuthString = utf8authToken?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue:0))
        let language = NSLocale.preferredLanguages()[0] ?? "en-EN"
        let headers = [
            "Authorization": "Basic " + encodedAuthString!,
            "Accept": "application/json"
        ]
        let parameters = ["token": deviceToken,
                          "platform": environment.rawValue,
                          "language": language]
        
        let idfv = UIDevice.currentDevice().identifierForVendor?.UUIDString
        _ = Alamofire.request(.PUT, url + deviceRegistrationPath + idfv!, headers:headers, parameters: (parameters as! [String : AnyObject]), encoding: .JSON).responseJSON { response in
            debugPrint(response)
        }
    }
}
