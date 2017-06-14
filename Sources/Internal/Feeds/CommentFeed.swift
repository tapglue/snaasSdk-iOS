//
//  CommentFeed.swift
//  Tapglue
//
//  Created by Onur Akpolat on 28/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

class CommentFeed: FlattenableFeed<Comment> {

	fileprivate enum CodingKeys: String, CodingKey {
		case comments
		case users
	}

    var comments: [Comment]?
    var users: [String: User]?

    required init() {
        self.comments = [Comment]()
        super.init()
    }

    override func flatten() -> [Comment] {
        let mappedComments = comments?.map { comment -> Comment in
            comment.user = users?[comment.userId ?? ""]
            return comment
        }
        return mappedComments ?? [Comment]()
    }
    
    override func newCopy(json: [String:Any]?) -> CommentFeed? {
		if let json = json,
			let jsonData = try? JSONSerialization.data(withJSONObject: json,
			                                           options: JSONSerialization.WritingOptions.prettyPrinted){
			let decoder = JSONDecoder()
			return try? decoder.decode(CommentFeed.self, from: jsonData)

		}
		return nil
    }

	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		comments = try container.decodeIfPresent([Comment].self, forKey: CodingKeys.comments)
		users = try container.decodeIfPresent([String: User].self, forKey: CodingKeys.users)
	}

	override func encode(to encoder: Encoder) throws {
		try super.encode(to: encoder)
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(users, forKey: CodingKeys.users)
		try container.encodeIfPresent(comments, forKey: CodingKeys.comments)
	}
}
