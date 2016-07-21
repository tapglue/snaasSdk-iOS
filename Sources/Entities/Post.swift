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
    public var visibility: Int?
    public var tags: [String]?
    public var attachments: Attachment?
    public var counts: [String:Int]?
    public var createdAt: String?
    public var updatedAt: String?
    
    public init() {
        
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        id          <- map["id"]
        visibility  <- map["visibility"]
        tags        <- map["tags"]
        attachments <- map["attachments"]
        counts      <- map["counts"]
        createdAt   <- map["created_at"]
        updatedAt   <- map["updated_at"]
    }
    
}

public class Attachment: Mappable {
    public var contents: [String:String]?
    public var name: String?
    public var type: String?
    
    public init() {
        
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        contents    <- map["contents"]
        name        <- map["name"]
        type        <- map["type"]
    }
}