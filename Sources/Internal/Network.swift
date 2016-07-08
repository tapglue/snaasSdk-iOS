//
//  Network.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Alamofire
import RxSwift

class Network {
    func loginUser(username: String, password:String) -> Observable<User> {
        let payload = ["user_name": username, "password": password]
        return Observable.create { observer in
            Alamofire.request(Router.post("/users/login", payload: payload))
                .validate()
                .debugLog()
                .responseObject { (response: Response<User, NSError>) in
                    switch response.result {
                    case .Success(let value):
                        print(value)
                        observer.on(.Next(value))
                        observer.on(.Completed)
                    case .Failure(let error):
                        print(error)
                        observer.on(.Error(error))
//                        if let data = response.data {
//                            let json = String(data: data, encoding: NSUTF8StringEncoding)
//                            print("Failure Response: \(json)")
//                        }
                    }
            }
            return NopDisposable.instance
            }.map { (user:User) in
                Router.sessionToken = user.sessionToken ?? ""
                return user
        }
    }

    func refreshCurrentUser() -> Observable<User> {
        return Http().execute(Router.get("/me"))
    }
}
