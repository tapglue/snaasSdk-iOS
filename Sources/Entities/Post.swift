//
//  Post.swift
//  Tapglue
//
//  Created by Onur Akpolat on 21/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

public class Post: Mappable {
    public var id: String?
    public var visibility: Visibility?
    public var tags: [String]?
    public var attachments: [Attachment]?
    public var userId: String?
    public var user: User?
    public var counts: [String:Int]?
    public var isLiked: Bool?
    public var createdAt: String?
    public var updatedAt: String?
    
    public init(visibility: Visibility, attachments: [Attachment]) {
        self.visibility = visibility
        self.attachments = attachments
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        id          <- map["id"]
        visibility  <- map["visibility"]
        tags        <- map["tags"]
        attachments <- map["attachments"]
        userId      <- map["user_id"]
        counts      <- map["counts"]
        createdAt   <- map["created_at"]
        updatedAt   <- map["updated_at"]
        isLiked     <- map["is_liked"]
    }
    
}

public class Attachment: Mappable {
    public var contents: [String:String]?
    public var name: String?
    public var type: Type?
    
    public init (contents:[String:String], name: String, type: Type) {
        self.contents = contents
        self.name = name
        self.type = type
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        contents    <- map["contents"]
        name        <- map["name"]
        type        <- map["type"]
    }
}

public enum Visibility: Int {
    case Private = 10, Connections = 20, Public = 30
}

public enum Type: String {
    case Text = "text", URL = "url", Image = "image"
}