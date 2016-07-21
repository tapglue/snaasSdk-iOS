//
//  ErrorFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/21/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class ErrorFeed: Mappable {
    var errors: [TapglueError]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        errors <- map["errors"]
    }
}
