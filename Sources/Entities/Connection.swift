//
//  Connection.swift
//  Tapglue
//
//  Created by John Nilsen on 7/26/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

/// Entity that represents a connection on tapglue.
public class Connection: Mappable {
    public var userToId: String?
    public var userFromId: String?
    public var type: ConnectionType?
    public var state: ConnectionState?
    public var userTo: User?
    public var userFrom: User?

    /// Creates an entity representing a connection on tapglue. Connections can be of two types,
    /// Follow or Friend, and can go through three states: Pending, Confirmed, Rejected. 
    ///
    /// A classic Friend request would look like: user1 created a pending connection of type
    /// friend to user2, this user can then confirm or reject the request.
    /// - parameters:
    ///     - userId: id of the user to which the connection is created
    ///     - type: Friend or Follow
    ///     - state: Pending, Confirmed or Rejected
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

/// ConnectionState represents the states a connection can go through.
/// - Pending: a connection that is jet to be confirmed
/// - Confirmed: a confirmed connection
/// - Rejected: a rejected connection
public enum ConnectionState: String {
    case Pending = "pending", Confirmed = "confirmed", Rejected = "rejected"
}