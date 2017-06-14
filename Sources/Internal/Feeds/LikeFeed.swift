//
//  LikeFeed.swift
//  Tapglue
//
//  Created by Onur Akpolat on 29/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import ObjectMapper

class LikeFeed: FlattenableFeed<Like> {

	fileprivate enum CodingKeys: String, CodingKey {
		case likes
		case users
		case posts = "post_map"
	}

    var likes: [Like]?
    var users: [String: User]?
    var posts: [String: Post]?
    
    required init?(map: Map) {
        super.init()
    }
    
    required init() {
        self.likes = [Like]()
        super.init()
    }
    
//    override func mapping(map: Map) {
//        likes <- map["likes"]
//        users <- map["users"]
//        posts <- map["post_map"]
//    }

    override func flatten() -> [Like] {
        let mappedLikes = likes?.map { like -> Like in
            like.user = users?[like.userId ?? ""]
            like.post = posts?[like.postId ?? ""]
            return like
        }
        return mappedLikes ?? [Like]()
    }
    
    override func newCopy(json: [String: Any]?) -> LikeFeed? {
		if let json = json,
			let jsonData = try? JSONSerialization.data(withJSONObject: json,
			                                           options: JSONSerialization.WritingOptions.prettyPrinted){
			let decoder = JSONDecoder()
			return try? decoder.decode(LikeFeed.self, from: jsonData)

		}
		return nil
    }

	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		likes = try container.decodeIfPresent([Like].self, forKey: CodingKeys.likes)
		users = try container.decodeIfPresent([String: User].self, forKey: CodingKeys.users)
		posts = try container.decodeIfPresent([String: Post].self, forKey: CodingKeys.posts)
	}

	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(likes, forKey: CodingKeys.likes)
		try container.encodeIfPresent(users, forKey: CodingKeys.users)
		try container.encodeIfPresent(posts, forKey: CodingKeys.posts)
	}
}
