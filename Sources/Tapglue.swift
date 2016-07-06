//
//  Tapglue.swift
//  Tapglue
//
//  Created by John Nilsen on 6/27/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RxSwift

public class Tapglue {
    
    let appToken = "365612c09fc7d75eb1dc2bee9f127c6d"
    var network: Network
    var headers = ["Authorization":"Basic ",
                   "User-Agent": "TapglueSDKExample",
                   "Accept":"Application/json"]
    
    public init() {
        headers["Authorization"] = "Basic " + Encoder.encode(appToken, sessionToken: "")
        Router.configuration = Configuration()
        network = Network()
    }
    
    public func createUser(username: String, password: String) {
        print(headers)
        Alamofire.request(.POST, "https://api.tapglue.com/0.4/users",
            headers: headers,
            parameters: ["user_name": username, "password": password],
            encoding: .JSON)
            .validate()
            .debugLog()
            .responseJSON { response in
                print(response.request)
                switch response.result {
                case .Success(let JSON):
                    print(JSON)
                case .Failure(let error):
                    print(error)
                    if let data = response.data {
                        let json = String(data: data, encoding: NSUTF8StringEncoding)
                        print("Failure Response: \(json)")
                    }
                }
        }
    }
    
    public func loginUser(username: String, password: String) -> Observable<User> {
        return network.loginUser(username, password: password)
    }

    public func refreshCurrentUser() -> Observable<User> {
        return network.refreshCurrentUser()
    }
}