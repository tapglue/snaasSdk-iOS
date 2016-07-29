//
//  Comment.swift
//  Tapglue
//
//  Created by Onur Akpolat on 28/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

public class Like: Mappable {
    public var id: String?
    public var postId: String?
    public var externalId: String?
    public var userId: String?
    public var createdAt: String?
    public var updatedAt: String?
    public var user: User?
    
    required public init?(_ map: Map) {
        
    }
    
    public init (postId: String) {
        self.postId = postId
    }
    
    public func mapping(map: Map) {
        id              <- map["id"]
        postId          <- map["post_id"]
        externalId      <- map["external_id"]
        userId          <- map["user_id"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
    
}