//
//  PostTagFilter.swift
//  Tapglue
//
//  Created by John Nilsen on 8/9/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class PostTagFilter: Mappable {
    
    var tags: [String]?
    
    init(tags: [String]) {
        self.tags = tags
    }
    
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map) {
        tags <- map["tags"]
    }
}

