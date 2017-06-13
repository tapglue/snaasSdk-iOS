//
//  ErrorFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/21/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class ErrorFeed: Codable {
    var errors: [TapglueError]?
    
//    required init?(map: Map) {
//        
//    }
//    
//    func mapping(map: Map) {
//        errors <- map["errors"]
//    }
}
