//
//  Post.swift
//  Tapglue
//
//  Created by Onur Akpolat on 21/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

public extension Encodable {
	func toJSON() -> [String: Any]? {
		let encoder = JSONEncoder()
		let encoded = try? encoder.encode(self)

		if let data = encoded,
			let json = try? JSONSerialization
				.jsonObject(with: data,
				            options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
			return json
		}
		return nil
	}

	func toJSONString() -> String? {
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(self) {
			return String(data: encoded, encoding: String.Encoding.utf8)
		}
		return nil
	}
}

public extension Decodable {
	static func fromJSON(with string: String) -> Self? {
		if let data = string.data(using: String.Encoding.utf8) {
			let decoder = JSONDecoder()
			return try? decoder.decode(self, from: data)
		}
		return nil
	}
}

open class Post: Codable {

	fileprivate enum CodingKeys: String, CodingKey {
		case id
		case visibility
		case tags
		case attachments
		case userId = "user_id"
		case counts
		case rawOwnReactions = "has_reacted"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case isLiked = "is_liked"
	}

	fileprivate enum CountsCodingKeys: String, CodingKey {
		case reactions
		case likes
		case comments
	}

    open var id: String?
    open var visibility: Visibility?
    open var tags: [String]?
    open var attachments: [Attachment]?
    open var userId: String?
    open var user: User?
    open var counts: [String: Int]?
    private var rawReactions: [String: Int]?
    private var rawOwnReactions: [String: Bool]?
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
    open var hasReacted: [Reaction:Bool]? {
        get {
            var returnValue = [Reaction:Bool]()
            if let raw = rawOwnReactions {
                for (reaction, isSet) in raw {
                    if let reaction = Reaction(rawValue: reaction) {
                        returnValue[reaction] = isSet
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

    public func setUserReactionLocally(_ reaction: Reaction, _ value: Bool) {
        rawOwnReactions?[reaction.rawValue] = value
    }

    public func increaseReactionCountLocally(_ reaction: Reaction) {
        rawReactions?[reaction.rawValue] = (rawReactions?[reaction.rawValue] ?? 0) + 1
    }

    public func decreaseReactionCountLocally(_ reaction: Reaction) {
        rawReactions?[reaction.rawValue] = max((rawReactions?[reaction.rawValue] ?? 0) - 1, 0)
    }

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decodeIfPresent(String.self, forKey: CodingKeys.id)
		visibility = try container.decodeIfPresent(Visibility.self, forKey: CodingKeys.visibility)
		tags = try container.decodeIfPresent([String].self, forKey: CodingKeys.tags)
		attachments = try container.decodeIfPresent([Attachment].self, forKey: CodingKeys.attachments)
		userId = try container.decodeIfPresent(String.self, forKey: CodingKeys.userId)
		rawOwnReactions = try container.decodeIfPresent([String: Bool].self, forKey: CodingKeys.rawOwnReactions)
		createdAt = try container.decodeIfPresent(String.self, forKey: CodingKeys.createdAt)
		updatedAt = try container.decodeIfPresent(String.self, forKey: CodingKeys.updatedAt)
		isLiked = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.isLiked)

		let countsContainer = try container.nestedContainer(keyedBy: CountsCodingKeys.self,
		                                                    forKey: CodingKeys.counts)

		rawReactions = try countsContainer.decodeIfPresent([String: Int].self, forKey: CountsCodingKeys.reactions)
		likeCount = try countsContainer.decodeIfPresent(Int.self, forKey: CountsCodingKeys.likes)
		commentCount = try countsContainer.decodeIfPresent(Int.self, forKey: CountsCodingKeys.comments)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(id, forKey: CodingKeys.id)
		try container.encodeIfPresent(visibility, forKey: CodingKeys.visibility)
		try container.encodeIfPresent(tags, forKey: CodingKeys.tags)
		try container.encodeIfPresent(attachments, forKey: CodingKeys.attachments)
		try container.encodeIfPresent(userId, forKey: CodingKeys.userId)
		try container.encodeIfPresent(rawOwnReactions, forKey: CodingKeys.rawOwnReactions)
		try container.encodeIfPresent(createdAt, forKey: CodingKeys.createdAt)
		try container.encodeIfPresent(updatedAt, forKey: CodingKeys.updatedAt)
		try container.encodeIfPresent(isLiked, forKey: CodingKeys.isLiked)

		var countsContainer = container.nestedContainer(keyedBy: CountsCodingKeys.self,
		                                                forKey: Post.CodingKeys.counts)

		try countsContainer.encodeIfPresent(rawReactions, forKey: CountsCodingKeys.reactions)
		try countsContainer.encodeIfPresent(likeCount, forKey: CountsCodingKeys.likes)
		try countsContainer.encodeIfPresent(commentCount, forKey: CountsCodingKeys.comments)


	}
}

open class Attachment: Codable {

	fileprivate enum CodingKeys: String, CodingKey {
		case contents
		case name
		case type
	}

    open var contents: [String: String]?
    open var name: String?
    open var type: Type?
    
    public init (contents: [String: String], name: String, type: Type) {
        self.contents = contents
        self.name = name
        self.type = type
    }

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decodeIfPresent(String.self, forKey: CodingKeys.name)
		type = try container.decodeIfPresent(Type.self, forKey: CodingKeys.type)
		contents = try container.decodeIfPresent([String: String].self, forKey: CodingKeys.contents)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(contents, forKey: CodingKeys.contents)
		try container.encode(name, forKey: CodingKeys.name)
		try container.encode(type, forKey: CodingKeys.type)
	}
}

public enum Visibility: Int, Codable {
    case `private` = 10, connections = 20, `public` = 30
}

public enum Type: String, Codable {
    case Text = "text", URL = "url", Image = "image"
}
