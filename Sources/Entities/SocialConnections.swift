//
//  SocialConnections.swift
//  Tapglue
//
//  Created by John Nilsen on 8/2/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

/// Social connections payload used to create social connections from another social network
/// on tapglue.
public class SocialConnections: Mappable {
    var platform: String?
    var type: ConnectionType?
    var userSocialId: String?
    var socialIds: [String]?
    
    /// Social connections payload used to create social connections from another social network
    /// on tapglue.
    /// - parameters:
    ///     - platform: name of the platform the user ids are from
    ///     - type: type of connection to be created, friend of follow
    ///     - userSocialId: the current users social id on the social platform
    ///     - socialIds: ids of the users to which the connections will be created
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
