//
//  Post.swift
//  Tapglue
//
//  Created by Onur Akpolat on 21/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

extension Encodable {
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

extension Decodable {
	static func fromJSON(with string: String) -> Self? {
		if let data = string.data(using: String.Encoding.utf8) {
			let decoder = JSONDecoder()
			return try? decoder.decode(self, from: data)
		}
		return nil
	}
}

open class Post: Codable {
    open var id: String?
    open var visibility: Visibility?
    open var tags: [String]?
    open var attachments: [Attachment]?
    open var userId: String?
    open var user: User?
    open var counts: [String:Int]?
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

	}

	public func encode(to encoder: Encoder) throws {

	}
    
//    required public init?(map: Map) {
//
//    }
//
//    open func mapping(map: Map) {
//        id          <- map["id"]
//        visibility  <- map["visibility"]
//        tags        <- map["tags"]
//        attachments <- map["attachments"]
//        userId      <- map["user_id"]
//        counts      <- map["counts"]
//        rawReactions   <- map["counts.reactions"]
//        rawOwnReactions <- map["has_reacted"]
//        createdAt   <- map["created_at"]
//        updatedAt   <- map["updated_at"]
//        isLiked     <- map["is_liked"]
//        likeCount   <- map["counts.likes"]
//        commentCount    <- map["counts.comments"]
//    }
}

open class Attachment: Codable {
    open var contents: [String:String]?
    open var name: String?
    open var type: Type?
    
    public init (contents:[String:String], name: String, type: Type) {
        self.contents = contents
        self.name = name
        self.type = type
    }

	public required init(from decoder: Decoder) throws {

	}

	public func encode(to encoder: Encoder) throws {

	}
    
//    required public init?(map: Map) {
//
//    }

//    open func mapping(map: Map) {
//        contents    <- map["contents"]
//        name        <- map["name"]
//        type        <- map["type"]
//    }
}

public enum Visibility: Int {
    case `private` = 10, connections = 20, `public` = 30
}

public enum Type: String {
    case Text = "text", URL = "url", Image = "image"
}
