//
//  User.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

public class User: Mappable {
    var username: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var followedCount: Int?
    var followerCount: Int?
    var friendCount: Int?
    var id: String?
    var isFriend: Bool?
    var isFollowed: Bool?
    var isFollowing: Bool?
    var sessionToken: String?
    var updatedAt: String?
    
    init() {
        
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        username    <- map["user_name"]
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
        sessionToken    <- map["sessionToken"]
        updatedAt   <- map["updated_at"]
    }
    
}