//
//  NewsFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 8/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

open class NewsFeed: DefaultInstanceEntity, Codable {
    var activities: [Activity]?
    var posts: [Post]?
    
    required public init() {
        activities = [Activity]()
        posts = [Post]()
    }
}
