//
//  AcitivityFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 8/3/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

class ActivityFeed: FlattenableFeed<Activity> {

	fileprivate enum CodingKeys: String, CodingKey {
		case users
		case posts = "post_map"
		case activities = "events"
	}

    var activities: [Activity]?
    var users: [String: User]?
    var posts: [String: Post]?
    
    
    required init() {
        activities = [Activity]()
        super.init()
    }
//    
//    required init?(map: Map) {
//        super.init()
//    }
    
//    override func mapping(map: Map) {
//        activities  <- map["events"]
//        users       <- map["users"]
//        posts       <- map["post_map"]
//    }

    override func flatten() -> [Activity] {
        let mappedActivities = activities?.map {activity -> Activity in
            activity.user = users?[activity.userId ?? ""]
            activity.post = posts?[activity.postId ?? ""]
            activity.post?.user = users?[activity.post?.userId ?? ""]
            if activity.target?.type == "tg_user" {
                activity.targetUser = users?[activity.target!.id ?? ""]
            }
            return activity
        }
        return mappedActivities ?? [Activity]()
    }
    
    override func newCopy(json: [String:Any]?) -> ActivityFeed? {
		if let json = json,
			let jsonData = try? JSONSerialization.data(withJSONObject: json,
			                                           options: JSONSerialization.WritingOptions.prettyPrinted){
			let decoder = JSONDecoder()
			return try? decoder.decode(ActivityFeed.self, from: jsonData)

		}
		return nil
    }

	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		users = try container.decodeIfPresent([String: User].self, forKey: CodingKeys.users)
		posts = try container.decodeIfPresent([String: Post].self, forKey: CodingKeys.posts)
		activities = try container.decodeIfPresent([Activity].self, forKey: CodingKeys.activities)
	}

	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(users, forKey: CodingKeys.users)
		try container.encodeIfPresent(posts, forKey: CodingKeys.posts)
		try container.encodeIfPresent(activities, forKey: CodingKeys.activities)
	}
}
