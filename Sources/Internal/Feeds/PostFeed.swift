//
//  File.swift
//  Tapglue
//
//  Created by John Nilsen on 8/2/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class PostFeed: FlattenableFeed<Post> {

	fileprivate enum CodingKeys: String, CodingKey {
		case posts
		case users
	}

    var posts: [Post]?
    var users: [String: User]?
    
    required init() {
        self.posts = [Post]()
        super.init()
    }

    override func flatten() -> [Post] {
        let mappedPosts = posts?.map { post -> Post in
            post.user = users?[post.userId ?? ""]
            return post
        }
        return mappedPosts ?? [Post]()
    }

    override func newCopy(json: [String:Any]?) -> PostFeed? {
		if let json = json,
			let jsonData = try? JSONSerialization.data(withJSONObject: json,
			                                           options: JSONSerialization.WritingOptions.prettyPrinted){
			let decoder = JSONDecoder()
			return try? decoder.decode(PostFeed.self, from: jsonData)

		}
		return nil
    }

	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		posts = try container.decodeIfPresent([Post].self, forKey: CodingKeys.posts)
		users = try container.decodeIfPresent([String: User].self, forKey: CodingKeys.users)
	}

	override func encode(to encoder: Encoder) throws {
		try super.encode(to: encoder)
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(posts, forKey: CodingKeys.posts)
		try container.encodeIfPresent(users, forKey: CodingKeys.users)
	}
}
