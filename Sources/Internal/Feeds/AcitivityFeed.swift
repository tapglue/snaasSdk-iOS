//
//  AcitivityFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 8/3/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class ActivityFeed: NullableFeed {
    var activities: [Activity]?
    var users: [String: User]?
    var posts: [String: Post]?
    
    
    required init() {
        activities = [Activity]()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        activities  <- map["events"]
        users       <- map["users"]
        posts       <- map["post_map"]
    }
}
