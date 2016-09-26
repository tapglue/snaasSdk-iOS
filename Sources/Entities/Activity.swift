//
//  Event.swift
//  Tapglue
//
//  Created by John Nilsen on 8/3/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

open class Activity: Mappable {
    open var id: String?
    open var type: String?
    open var language: String?
    open var priority: String?
    open var location: String?
    open var latitude: Double?
    open var longitude: Double?
    open var visibility: Visibility?
    open var images: [String: Image]?
    open var userId: String?
    open var tgObjectId: String?
    open var target: ActivityObject?
    open var object: ActivityObject?
    open var user: User?
    open var postId: String?
    open var post: Post?
    open var targetUser: User?
    open var createdAt: String?
    open var updatedAt: String?

    init(){}

    required public init?(_ map: Map) {
    }
    
    open func mapping(_ map: Map) {
        id      <- map["id_string"]
        type    <- map["type"]
        language    <- map["language"]
        priority    <- map["priority"]
        location    <- map["location"]
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
        visibility  <- map["visibility"]
        images      <- map["images"]
        userId      <- map["user_id_string"]
        tgObjectId  <- map["tgObjectId"]
        postId      <- map["post_id"]
        target      <- map["target"]
        object      <- map["object"]
        createdAt   <- map["created_at"]
        updatedAt   <- map["updated_at"]
    }
}

open class ActivityObject: Mappable {
    open var id: String?
    open var type: String?
    open var url: String?
    open var displayNames: [String: String]?

    required public init?(_ map: Map) {
    }
    
    open func mapping(_ map: Map) {
        id      <- map["id"]
        type    <- map["type"]
        url     <- map["url"]
        displayNames    <- map["display_name"]
    }
}
