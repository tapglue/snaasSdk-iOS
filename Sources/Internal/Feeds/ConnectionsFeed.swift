//
//  ConnectionsFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/29/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class ConnectionsFeed: NullableFeed {
    
    var incoming: [Connection]?
    var outgoing: [Connection]?
    var users: [User]?
    
    required init() {
        incoming = [Connection]()
        outgoing = [Connection]()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        incoming <- map["incoming"]
        outgoing <- map["outgoing"]
        users <- map["users"]
    }
}