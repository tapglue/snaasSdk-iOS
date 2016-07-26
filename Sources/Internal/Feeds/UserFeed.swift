//
//  UserFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/8/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import ObjectMapper

class UserFeed: NullableFeed {
    var users: [User]?
    
    required init?(_ map: Map) {
        
    }
    
    required init() {
        self.users = [User]()
    }
    
    func mapping(map: Map) {
        users <- map["users"]
    }
}
