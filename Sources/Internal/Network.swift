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
    let http = Http()
    
    func loginUser(username: String, password:String) -> Observable<User> {
        let payload = ["user_name": username, "password": password]
        return http.execute(Router.post("/users/login", payload: payload))
            .map { (user:User) in
                Router.sessionToken = user.sessionToken ?? ""
                return user
        }
    }

    func refreshCurrentUser() -> Observable<User> {
        return http.execute(Router.get("/me"))
    }
}
