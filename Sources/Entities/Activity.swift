//
//  Event.swift
//  Tapglue
//
//  Created by John Nilsen on 8/3/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

open class Activity: Codable {

	fileprivate enum CodingKeys: String, CodingKey {
		case id = "id_string"
		case type
		case language
		case priority
		case location
		case latitude
		case longitude
		case visibility
		case images
		case userId = "user_id_string"
		case tgObjectId
		case postId = "post_id"
		case target
		case object
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

    open var id: String?
    open var type: String?
    open var language: String?
    open var priority: String?
    open var location: String?
    open var latitude: Double?
    open var longitude: Double?
    open var visibility: Visibility?
    open var images: [String: Image]?
    open var userId: String?
    open var tgObjectId: String?
    open var target: ActivityObject?
    open var object: ActivityObject?
    open var user: User?
    open var postId: String?
    open var post: Post?
    open var targetUser: User?
    open var createdAt: String?
    open var updatedAt: String?

    init(){}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decodeIfPresent(String.self, forKey: CodingKeys.id)
		type = try container.decodeIfPresent(String.self, forKey: CodingKeys.type)
		language = try container.decodeIfPresent(String.self, forKey: CodingKeys.language)
		priority = try container.decodeIfPresent(String.self, forKey: CodingKeys.priority)
		location = try container.decodeIfPresent(String.self, forKey: CodingKeys.location)
		latitude = try container.decodeIfPresent(Double.self, forKey: CodingKeys.latitude)
		longitude = try container.decodeIfPresent(Double.self, forKey: CodingKeys.longitude)
		visibility = try container.decodeIfPresent(Visibility.self, forKey: CodingKeys.visibility)
		images = try container.decodeIfPresent([String: Image].self, forKey: CodingKeys.images)
		userId = try container.decodeIfPresent(String.self, forKey: CodingKeys.userId)
		tgObjectId = try container.decodeIfPresent(String.self, forKey: CodingKeys.tgObjectId)
		postId = try container.decodeIfPresent(String.self, forKey: CodingKeys.postId)
		target = try container.decodeIfPresent(ActivityObject.self, forKey: CodingKeys.target)
		object = try container.decodeIfPresent(ActivityObject.self, forKey: CodingKeys.object)
		createdAt = try container.decodeIfPresent(String.self, forKey: CodingKeys.createdAt)
		updatedAt = try container.decodeIfPresent(String.self, forKey: CodingKeys.updatedAt)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(id, forKey: CodingKeys.id)
		try container.encodeIfPresent(type, forKey: CodingKeys.type)
		try container.encodeIfPresent(language, forKey: CodingKeys.language)
		try container.encodeIfPresent(priority, forKey: CodingKeys.priority)
		try container.encodeIfPresent(location, forKey: CodingKeys.location)
		try container.encodeIfPresent(latitude, forKey: CodingKeys.latitude)
		try container.encodeIfPresent(longitude, forKey: CodingKeys.longitude)
		try container.encodeIfPresent(visibility, forKey: CodingKeys.visibility)
		try container.encodeIfPresent(images, forKey: CodingKeys.images)
		try container.encodeIfPresent(userId, forKey: CodingKeys.userId)
		try container.encodeIfPresent(tgObjectId, forKey: CodingKeys.tgObjectId)
		try container.encodeIfPresent(postId, forKey: CodingKeys.postId)
		try container.encodeIfPresent(target, forKey: CodingKeys.target)
		try container.encodeIfPresent(object, forKey: CodingKeys.object)
		try container.encodeIfPresent(createdAt, forKey: CodingKeys.createdAt)
		try container.encodeIfPresent(updatedAt, forKey: CodingKeys.updatedAt)
	}
}

open class ActivityObject: Codable {

	fileprivate enum CodingKeys: String, CodingKey {
		case id
		case type
		case url
		case displayNames = "display_name"
	}

    open var id: String?
    open var type: String?
    open var url: String?
    open var displayNames: [String: String]?

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decodeIfPresent(String.self, forKey: CodingKeys.id)
		type = try container.decodeIfPresent(String.self, forKey: CodingKeys.type)
		url = try container.decodeIfPresent(String.self, forKey: CodingKeys.url)
		displayNames = try container.decodeIfPresent([String: String].self, forKey: CodingKeys.displayNames)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: CodingKeys.id)
		try container.encode(type, forKey: CodingKeys.type)
		try container.encode(url, forKey: CodingKeys.url)
		try container.encode(displayNames, forKey: CodingKeys.displayNames)
	}
}
