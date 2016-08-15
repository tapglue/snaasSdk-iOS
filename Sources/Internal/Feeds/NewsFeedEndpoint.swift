//
//  NewsFeedEndpoint.swift
//  Tapglue
//
//  Created by John Nilsen on 8/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class NewsFeedEndpoint: NullableFeed {
    var activities: [Activity]?
    var posts: [Post]?
    var users: [String: User]?
    var postMap: [String: Post]?
    
    required init() {
        posts = [Post]()
        activities = [Activity]()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        activities  <- map["events"]
        posts       <- map["posts"]
        users       <- map["users"]
        postMap     <- map["post_map"]
    }
}
