//
//  NewsFeedEndpoint.swift
//  Tapglue
//
//  Created by John Nilsen on 8/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

class NewsFeedEndpoint: CompositeFlattenableFeed<NewsFeed> {
    var activities: [Activity]?
    var posts: [Post]?
    var users: [String: User]?
    var postMap: [String: Post]?
    
    required init() {
        posts = [Post]()
        activities = [Activity]()
        super.init()
    }
    
//    required init?(map: Map) {
//        super.init()
//    }
//
//    override func mapping(map: Map) {
//        activities  <- map["events"]
//        posts       <- map["posts"]
//        users       <- map["users"]
//        postMap     <- map["post_map"]
//        page        <- map["paging"]
//    }

    override func flatten() -> NewsFeed {
        let newsFeed = NewsFeed()
        newsFeed.posts = posts?.map { post -> Post in
            post.user = users?[post.userId ?? ""]
            return post
        }
        newsFeed.activities = activities?.map { activity -> Activity in
            activity.user = users?[activity.userId ?? ""]
            activity.post = postMap?[activity.postId ?? ""]
            activity.post?.user = users?[activity.post?.userId ?? ""]
            if activity.target?.type == "tg_user" {
                activity.targetUser = users?[activity.target!.id ?? ""]
            }
            return activity
        }
        return newsFeed
    }
    
    override func newCopy(json: [String : Any]?) -> NewsFeedEndpoint? {
		if let json = json,
			let jsonData = try? JSONSerialization.data(withJSONObject: json,
			                                           options: JSONSerialization.WritingOptions.prettyPrinted){
			let decoder = JSONDecoder()
			return try? decoder.decode(NewsFeedEndpoint.self, from: jsonData)

		}
		return nil
    }
}
