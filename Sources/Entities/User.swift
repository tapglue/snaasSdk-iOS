//
//  User.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

open class User: Mappable {
    open var username: String?
    open var password: String?
    open var email: String?
    open var firstName: String?
    open var lastName: String?
    open var followedCount: Int?
    open var followerCount: Int?
    open var friendCount: Int?
    open var id: String?
    open var about: String?
    open var isFriend: Bool?
    open var isFollowed: Bool?
    open var isFollowing: Bool?
    open var sessionToken: String?
    open var updatedAt: String?
    open var socialIds: [String: String]?
    open var images: [String: Image]?
    
    public init() {
        
    }
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        username    <- map["user_name"]
        password    <- map["password"]
        email       <- map["email"]
        firstName   <- map["first_name"]
        lastName    <- map["last_name"]
        followedCount   <- map["followed_count"]
        followerCount   <- map["follower_count"]
        friendCount <- map["friend_count"]
        id          <- map ["id_string"]
        isFriend    <- map["is_friend"]
        isFollowed  <- map["is_followed"]
        isFollowing <- map["is_following"]
        socialIds   <- map["social_ids"]
        images      <- map["images"]
        about       <- map["about"]
        sessionToken    <- map["session_token"]
        updatedAt   <- map["updated_at"]
    }
    
}

open class Image: Mappable {
    open var url: String?
    open var width: Int?
    open var height: Int?

    public init(url: String) {
        self.url = url
    }

    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        url     <- map["url"]
        width   <- map["width"]
        height  <- map["height"]
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
}
