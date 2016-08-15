//
//  Event.swift
//  Tapglue
//
//  Created by John Nilsen on 8/3/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

public class Activity: Mappable {
    public var id: String?
    public var type: String?
    public var language: String?
    public var priority: String?
    public var location: String?
    public var latitude: Double?
    public var longitude: Double?
    public var visibility: Visibility?
    public var images: [String: Image]?
    public var userId: String?
    public var tgObjectId: String?
    public var target: ActivityObject?
    public var object: ActivityObject?
    public var user: User?
    public var postId: String?
    public var post: Post?

    init(){}

    required public init?(_ map: Map) {
    }
    
    public func mapping(map: Map) {
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
    }
}

public class ActivityObject: Mappable {
    public var id: String?
    public var type: String?
    public var url: String?
    public var displayNames: [String: String]?

    required public init?(_ map: Map) {
    }
    
    public func mapping(map: Map) {
        id      <- map["id"]
        type    <- map["type"]
        url     <- map["url"]
        displayNames    <- map["display_name"]
    }
}
