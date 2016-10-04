//
//  AcitivityFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 8/3/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class ActivityFeed: FlattenableFeed<Activity> {
    var activities: [Activity]?
    var users: [String: User]?
    var posts: [String: Post]?
    
    
    required init() {
        activities = [Activity]()
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        activities  <- map["events"]
        users       <- map["users"]
        posts       <- map["post_map"]
    }

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
}
