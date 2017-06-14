//
//  NewsFeedEndpoint.swift
//  Tapglue
//
//  Created by John Nilsen on 8/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

class NewsFeedEndpoint: CompositeFlattenableFeed<NewsFeed> {

	fileprivate enum CodingKeys: String, CodingKey {
		case posts
		case users
		case activities = "events"
		case postMap = "post_map"
	}

    var activities: [Activity]?
    var posts: [Post]?
    var users: [String: User]?
    var postMap: [String: Post]?
    
    required init() {
        posts = [Post]()
        activities = [Activity]()
        super.init()
    }

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

	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		users = try container.decodeIfPresent([String: User].self, forKey: CodingKeys.users)
		posts = try container.decodeIfPresent([Post].self, forKey: CodingKeys.posts)
		activities = try container.decodeIfPresent([Activity].self, forKey: CodingKeys.activities)
		postMap = try container.decodeIfPresent([String: Post].self, forKey: CodingKeys.postMap)
	}

	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(users, forKey: CodingKeys.users)
		try container.encodeIfPresent(posts, forKey: CodingKeys.posts)
		try container.encodeIfPresent(activities, forKey: CodingKeys.activities)
		try container.encodeIfPresent(postMap, forKey: CodingKeys.postMap)
	}
}
