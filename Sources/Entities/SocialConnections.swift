//
//  SocialConnections.swift
//  Tapglue
//
//  Created by John Nilsen on 8/2/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

public class SocialConnections: Mappable {
    var platform: String?
    var type: ConnectionType?
    var userSocialId: String?
    var socialIds: [String]?
    
    public init(platform: String, type: ConnectionType, userSocialId: String, socialIds: [String]) {
        self.platform = platform
        self.type = type
        self.userSocialId = userSocialId
        self.socialIds = socialIds
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        platform        <- map["platform"]
        type        <- map ["type"]
        userSocialId    <- map["platform_user_id"]
        socialIds   <- map["connection_ids"]
    }
}
