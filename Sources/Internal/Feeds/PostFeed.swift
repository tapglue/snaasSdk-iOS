//
//  File.swift
//  Tapglue
//
//  Created by John Nilsen on 8/2/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class PostFeed: FlattenableFeed<Post> {
    var posts: [Post]?
    var users: [String: User]?
    
    required init() {
        self.posts = [Post]()
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        posts   <- map["posts"]
        users   <- map["users"]
        page    <- map["paging"]
    }

    override func flatten() -> [Post] {
        let mappedPosts = posts?.map { post -> Post in
            post.user = users?[post.userId ?? ""]
            return post
        }
        return mappedPosts ?? [Post]()
    }
}
