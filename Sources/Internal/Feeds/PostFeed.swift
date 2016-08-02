//
//  File.swift
//  Tapglue
//
//  Created by John Nilsen on 8/2/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class PostFeed: NullableFeed {
    var posts: [Post]?
    var users: [String: User]?
    
    required init() {
        self.posts = [Post]()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        posts   <- map["posts"]
        users   <- map["users"]
    }
}