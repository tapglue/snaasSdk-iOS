//
//  CommentFeed.swift
//  Tapglue
//
//  Created by Onur Akpolat on 28/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import ObjectMapper

class CommentFeed: FlattenableFeed<Comment> {
    var comments: [Comment]?
    var users: [String: User]?
    
    required init?(_ map: Map) {
        super.init()
    }
    
    required init() {
        self.comments = [Comment]()
        super.init()
    }
    
    override func mapping(map: Map) {
        comments <- map["comments"]
        users <- map["users"]
    }

    override func flatten() -> [Comment] {
        let mappedComments = comments?.map { comment -> Comment in
            comment.user = users?[comment.userId ?? ""]
            return comment
        }
        return mappedComments ?? [Comment]()
    }
}
