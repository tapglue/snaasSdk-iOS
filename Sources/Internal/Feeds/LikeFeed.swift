//
//  LikeFeed.swift
//  Tapglue
//
//  Created by Onur Akpolat on 29/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import ObjectMapper

class LikeFeed: FlattenableFeed<Like> {
    var likes: [Like]?
    var users: [String: User]?
    var posts: [String: Post]?
    
    required init?(map: Map) {
        super.init()
    }
    
    required init() {
        self.likes = [Like]()
        super.init()
    }
    
    override func mapping(map: Map) {
        likes <- map["likes"]
        users <- map["users"]
        posts <- map["post_map"]
    }

    override func flatten() -> [Like] {
        let mappedLikes = likes?.map { like -> Like in
            like.user = users?[like.userId ?? ""]
            like.post = posts?[like.postId ?? ""]
            return like
        }
        return mappedLikes ?? [Like]()
    }
}
