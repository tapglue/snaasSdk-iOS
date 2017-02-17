//
//  UserFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/8/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import ObjectMapper

class UserFeed: FlattenableFeed<User> {
    var users: [User]?
    
    required init?(map: Map) {
        super.init()
    }
    
    required init() {
        self.users = [User]()
        super.init()
    }
    
    override func mapping(map: Map) {
        users <- map["users"]
        page <- map["paging"]
    }
    
    override func flatten() -> [User] {
       return users ?? [User]()
    }
    
    override func newCopy(json: [String:Any]?) -> UserFeed? {
        return Mapper<UserFeed>().map(JSONObject: json)
    }
}
