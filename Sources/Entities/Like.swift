//
//  Comment.swift
//  Tapglue
//
//  Created by Onur Akpolat on 28/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

open class Like: NSObject, Mappable {
    open var id: String?
    open var postId: String?
    open var externalId: String?
    open var userId: String?
    open var createdAt: String?
    open var updatedAt: String?
    open var user: User?
    open var post: Post?
    
    required public init?(map: Map) {
        
    }
    
    public init (postId: String) {
        self.postId = postId
    }
    
    open func mapping(map: Map) {
        id              <- map["id"]
        postId          <- map["post_id"]
        externalId      <- map["external_id"]
        userId          <- map["user_id"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
    
}
