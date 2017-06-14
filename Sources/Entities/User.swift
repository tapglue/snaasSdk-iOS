//
//  User.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

open class User: Codable {
	fileprivate enum CodingKeys: String, CodingKey {
		case username = "user_name"
		case password
		case email
		case firstName = "first_name"
		case lastName = "last_name"
		case followedCount = "followed_count"
		case followerCount = "follower_count"
		case friendCount = "friend_count"
		case id = "id_string"
		case isFriend = "is_friend"
		case isFollowed = "is_followed"
		case isFollowing = "is_following"
		case socialIds = "social_ids"
		case images
		case about
		case sessionToken = "session_token"
		case updatedAt = "updated_at"
		case metadata
		case privateUserData = "private"
	}

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
    open var metadata: [String: String]?
    open var privateUserData: Private?
    
    public init() {
        
    }

	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		username = try values.decodeIfPresent(String.self, forKey: CodingKeys.username)
		password = try values.decodeIfPresent(String.self, forKey: CodingKeys.password)
		email = try values.decodeIfPresent(String.self, forKey: CodingKeys.email)
		firstName = try values.decodeIfPresent(String.self, forKey: CodingKeys.firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: CodingKeys.lastName)
		followedCount = try values.decodeIfPresent(Int.self, forKey: CodingKeys.followedCount)
		followerCount = try values.decodeIfPresent(Int.self, forKey: CodingKeys.followerCount)
		friendCount = try values.decodeIfPresent(Int.self, forKey: CodingKeys.friendCount)
		id = try values.decodeIfPresent(String.self, forKey: CodingKeys.id)
		isFriend = try values.decodeIfPresent(Bool.self, forKey: CodingKeys.isFriend)
		isFollowed = try values.decodeIfPresent(Bool.self, forKey: CodingKeys.isFollowed)
		isFollowing = try values.decodeIfPresent(Bool.self, forKey: CodingKeys.isFollowing)
		socialIds = try values.decodeIfPresent([String: String].self, forKey: CodingKeys.socialIds)
		images = try values.decodeIfPresent([String: Image].self, forKey: CodingKeys.images)
		about = try values.decodeIfPresent(String.self, forKey: CodingKeys.about)
		sessionToken = try values.decodeIfPresent(String.self, forKey: CodingKeys.sessionToken)
		updatedAt = try values.decodeIfPresent(String.self, forKey: CodingKeys.updatedAt)
		metadata = try values.decodeIfPresent([String: String].self, forKey: CodingKeys.metadata)
		privateUserData = try values.decodeIfPresent(Private.self, forKey: CodingKeys.privateUserData)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(username, forKey: CodingKeys.username)
		try container.encodeIfPresent(password, forKey: CodingKeys.password)
		try container.encodeIfPresent(email, forKey: CodingKeys.email)
		try container.encodeIfPresent(firstName, forKey: CodingKeys.firstName)
		try container.encodeIfPresent(lastName, forKey: CodingKeys.lastName)
		try container.encodeIfPresent(followedCount, forKey: CodingKeys.followedCount)
		try container.encodeIfPresent(followerCount, forKey: CodingKeys.followerCount)
		try container.encodeIfPresent(friendCount, forKey: CodingKeys.friendCount)
		try container.encodeIfPresent(id, forKey: CodingKeys.id)
		try container.encodeIfPresent(isFriend, forKey: CodingKeys.isFriend)
		try container.encodeIfPresent(isFollowed, forKey: CodingKeys.isFollowed)
		try container.encodeIfPresent(isFollowing, forKey: CodingKeys.isFollowing)
		try container.encodeIfPresent(socialIds, forKey: CodingKeys.socialIds)
		try container.encodeIfPresent(images, forKey: CodingKeys.images)
		try container.encodeIfPresent(about, forKey: CodingKeys.about)
		try container.encodeIfPresent(sessionToken, forKey: CodingKeys.sessionToken)
		try container.encodeIfPresent(updatedAt, forKey: CodingKeys.updatedAt)
		try container.encodeIfPresent(metadata, forKey: CodingKeys.metadata)
		try container.encodeIfPresent(privateUserData, forKey: CodingKeys.privateUserData)
	}
}

open class Image: Codable {

    open var url: String?
    open var width: Int?
    open var height: Int?

    public init(url: String) {
        self.url = url
    }
}

open class Private: Codable {
    open var type: String?
    open var verified: Bool?
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
}
