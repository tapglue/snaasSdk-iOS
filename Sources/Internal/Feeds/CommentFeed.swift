//
//  CommentFeed.swift
//  Tapglue
//
//  Created by Onur Akpolat on 28/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import ObjectMapper

class CommentFeed: NullableFeed {
    var comments: [Comment]?
    var users: [String: User]?
    
    required init?(_ map: Map) {
        
    }
    
    required init() {
        self.comments = [Comment]()
    }
    
    func mapping(map: Map) {
        comments <- map["comments"]
        users <- map["users"]
    }
}
