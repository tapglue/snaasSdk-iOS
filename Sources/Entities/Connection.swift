//
//  Connection.swift
//  Tapglue
//
//  Created by John Nilsen on 7/26/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

/// Entity that represents a connection on tapglue.
open class Connection: Codable {
	fileprivate enum CodingKeys: String, CodingKey {
		case userToId = "user_to_id_string"
		case userFromId = "user_from_id_string"
		case type
		case state
	}

    open var userToId: String?
    open var userFromId: String?
    open var type: ConnectionType?
    open var state: ConnectionState?
    open var userTo: User?
    open var userFrom: User?

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

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		userToId = try container.decodeIfPresent(String.self, forKey: CodingKeys.userToId)
		userFromId = try container.decodeIfPresent(String.self, forKey: CodingKeys.userFromId)
		type = try container.decodeIfPresent(ConnectionType.self, forKey: CodingKeys.type)
		state = try container.decodeIfPresent(ConnectionState.self, forKey: CodingKeys.state)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(userToId, forKey: CodingKeys.userToId)
		try container.encodeIfPresent(userFromId, forKey: CodingKeys.userFromId)
		try container.encodeIfPresent(type, forKey: CodingKeys.type)
		try container.encodeIfPresent(state, forKey: CodingKeys.state)
	}
}

/// ConnectionState represents the states a connection can go through.
/// - Pending: a connection that is jet to be confirmed
/// - Confirmed: a confirmed connection
/// - Rejected: a rejected connection
public enum ConnectionState: String, Codable {
    case Pending = "pending", Confirmed = "confirmed", Rejected = "rejected"
}
