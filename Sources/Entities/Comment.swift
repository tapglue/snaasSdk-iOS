//
//  Comment.swift
//  Tapglue
//
//  Created by Onur Akpolat on 28/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

open class Comment: Mappable {
    open var id: String?
    open var postId: String?
    open var externalId: String?
    open var userId: String?
    open var contents: [String:String]?
    open var privateFields: String?
    open var createdAt: String?
    open var updatedAt: String?
    open var user: User?
    
    required public init?(_ map: Map) {
        
    }
    
    public init (contents:[String:String], postId: String) {
        self.contents = contents
        self.postId = postId
    }
    
    open func mapping(_ map: Map) {
        id              <- map["id"]
        postId          <- map["post_id"]
        externalId      <- map["external_id"]
        userId          <- map["user_id"]
        contents        <- map["contents"]
        privateFields   <- map["private"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
    
}
