//
//  Post.swift
//  Tapglue
//
//  Created by Onur Akpolat on 21/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

open class Post: Mappable {
    open var id: String?
    open var visibility: Visibility?
    open var tags: [String]?
    open var attachments: [Attachment]?
    open var userId: String?
    open var user: User?
    open var counts: [String:Int]?
    private var rawReactions: [String: Int]?
    open var isLiked: Bool?
    open var likeCount: Int?
    open var commentCount: Int?
    open var createdAt: String?
    open var updatedAt: String?
    open var reactions: [Reaction: Int]? {
        get {
            var returnValue = [Reaction:Int]()
            if let rawReactions = rawReactions {
                for (rawReaction, count) in rawReactions {
                    if let reaction = Reaction(rawValue: rawReaction) {
                        returnValue[reaction] = count
                    }
                }
            }
            return returnValue
        }
    }
    
    public init(visibility: Visibility, attachments: [Attachment]) {
        self.visibility = visibility
        self.attachments = attachments
    }
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        id          <- map["id"]
        visibility  <- map["visibility"]
        tags        <- map["tags"]
        attachments <- map["attachments"]
        userId      <- map["user_id"]
        counts      <- map["counts"]
        rawReactions   <- map["counts.reactions"]
        createdAt   <- map["created_at"]
        updatedAt   <- map["updated_at"]
        isLiked     <- map["is_liked"]
        likeCount   <- map["counts.likes"]
        commentCount    <- map["counts.comments"]
    }
    
}

open class Attachment: Mappable {
    open var contents: [String:String]?
    open var name: String?
    open var type: Type?
    
    public init (contents:[String:String], name: String, type: Type) {
        self.contents = contents
        self.name = name
        self.type = type
    }
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        contents    <- map["contents"]
        name        <- map["name"]
        type        <- map["type"]
    }
}

public enum Visibility: Int {
    case `private` = 10, connections = 20, `public` = 30
}

public enum Type: String {
    case Text = "text", URL = "url", Image = "image"
}
