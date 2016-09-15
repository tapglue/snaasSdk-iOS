//
//  PageFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 9/13/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class PageFeed: Mappable {
    var page: ApiPage?
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        page <- map["paging"]
    }
}

class ApiPage: Mappable {
    var before: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        before <- map["cursors.before"]
    }
}
