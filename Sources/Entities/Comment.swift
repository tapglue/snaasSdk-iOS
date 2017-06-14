//
//  Comment.swift
//  Tapglue
//
//  Created by Onur Akpolat on 28/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

open class Comment: Codable {
	fileprivate enum CodingKeys: String, CodingKey {
		case id
		case postId = "post_id"
		case externalId = "external_id"
		case userId = "user_id"
		case contents
		case privateFields = "private"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

    open var id: String?
    open var postId: String?
    open var externalId: String?
    open var userId: String?
    open var contents: [String:String]?
    open var privateFields: String?
    open var createdAt: String?
    open var updatedAt: String?
    open var user: User?

    public init (contents:[String:String], postId: String) {
        self.contents = contents
        self.postId = postId
    }
    
//    open func mapping(map: Map) {
//        id              <- map["id"]
//        postId          <- map["post_id"]
//        externalId      <- map["external_id"]
//        userId          <- map["user_id"]
//        contents        <- map["contents"]
//        privateFields   <- map["private"]
//        createdAt       <- map["created_at"]
//        updatedAt       <- map["updated_at"]
//    }

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decodeIfPresent(String.self, forKey: CodingKeys.id)
		postId = try container.decodeIfPresent(String.self, forKey: CodingKeys.postId)
		externalId = try container.decodeIfPresent(String.self, forKey: CodingKeys.externalId)
		userId = try container.decodeIfPresent(String.self, forKey: CodingKeys.userId)
		contents = try container.decodeIfPresent([String: String].self, forKey: CodingKeys.contents)
		privateFields = try container.decodeIfPresent(String.self, forKey: CodingKeys.privateFields)
		createdAt = try container.decodeIfPresent(String.self, forKey: CodingKeys.createdAt)
		updatedAt = try container.decodeIfPresent(String.self, forKey: CodingKeys.updatedAt)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(id, forKey: CodingKeys.id)
		try container.encodeIfPresent(postId, forKey: CodingKeys.postId)
		try container.encodeIfPresent(externalId, forKey: CodingKeys.externalId)
		try container.encodeIfPresent(userId, forKey: CodingKeys.userId)
		try container.encodeIfPresent(contents, forKey: CodingKeys.contents)
		try container.encodeIfPresent(privateFields, forKey: CodingKeys.privateFields)
		try container.encodeIfPresent(createdAt, forKey: CodingKeys.createdAt)
		try container.encodeIfPresent(updatedAt, forKey: CodingKeys.updatedAt)
	}
}
