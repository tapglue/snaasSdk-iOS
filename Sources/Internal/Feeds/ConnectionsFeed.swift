//
//  ConnectionsFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/29/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class ConnectionsFeed: CompositeFlattenableFeed<Connections> {
    
    var incoming: [Connection]?
    var outgoing: [Connection]?
    var users: [User]?
    
    required init() {
        incoming = [Connection]()
        outgoing = [Connection]()
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        incoming <- map["incoming"]
        outgoing <- map["outgoing"]
        users <- map["users"]
        page <- map["paging"]
    }
    
    override func flatten() -> Connections {
        let connections = Connections()
        connections.incoming = incoming?.map { connection -> Connection in
            connection.userFrom = users?.filter { user -> Bool in
                user.id == connection.userFromId
                }.first
            return connection
        }
        connections.outgoing = outgoing?.map { connection -> Connection in
            connection.userTo = users?.filter { user -> Bool in
                user.id == connection.userToId
                }.first
            return connection
        }
        return connections
    }
    
    override func newCopy(json: [String : Any]?) -> ConnectionsFeed? {
         return Mapper<ConnectionsFeed>().map(JSONObject: json)
    }
}
