//
//  SocialConnections.swift
//  Tapglue
//
//  Created by John Nilsen on 8/2/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

/// Social connections payload used to create social connections from another social network
/// on tapglue.
open class SocialConnections: Codable {

	fileprivate enum CodingKeys: String, CodingKey {
		case platform
		case type
		case userSocialId = "platform_user_id"
		case socialIds = "connection_ids"
	}

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

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		platform = try container.decodeIfPresent(String.self, forKey: CodingKeys.platform)
		type = try container.decodeIfPresent(ConnectionType.self, forKey: CodingKeys.type)
		userSocialId = try container.decodeIfPresent(String.self, forKey: CodingKeys.userSocialId)
		socialIds = try container.decodeIfPresent([String].self, forKey: CodingKeys.socialIds)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(platform, forKey: CodingKeys.platform)
		try container.encodeIfPresent(type, forKey: CodingKeys.type)
		try container.encodeIfPresent(userSocialId, forKey: CodingKeys.userSocialId)
		try container.encodeIfPresent(socialIds, forKey: CodingKeys.socialIds)
	}
}
