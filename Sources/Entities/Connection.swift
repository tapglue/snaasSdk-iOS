//
//  Connection.swift
//  Tapglue
//
//  Created by John Nilsen on 7/26/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

public class Connection: Mappable {
    public var userToId: String?
    public var userFromId: String?
    public var type: ConnectionType?
    public var state: ConnectionState?
    public var userTo: User?
    public var userFrom: User?

    public init(toUserId userId: String, type: ConnectionType, state: ConnectionState) {
        self.userToId = userId
        self.type = type
        self.state = state
    }
    
    required public init?(_ map: Map) {
        
    }
    public func mapping(map: Map) {
        userToId <- map["user_to_id_string"]
        userFromId <- map["user_from_id_string"]
        type <- map["type"]
        state <- map["state"]
    }
}

public enum ConnectionState: String {
    case Pending = "pending", Confirmed = "confirmed", Rejected = "rejected"
}