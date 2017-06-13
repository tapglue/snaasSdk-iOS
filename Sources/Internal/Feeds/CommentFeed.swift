//
//  CommentFeed.swift
//  Tapglue
//
//  Created by Onur Akpolat on 28/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

class CommentFeed: FlattenableFeed<Comment> {
    var comments: [Comment]?
    var users: [String: User]?
    
//    required init?(map: Map) {
//        super.init()
//    }
    
    required init() {
        self.comments = [Comment]()
        super.init()
    }
    
//    override func mapping(map: Map) {
//        comments <- map["comments"]
//        users <- map["users"]
//    }

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
}
