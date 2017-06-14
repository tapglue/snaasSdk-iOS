//
//  ConnectionsFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/29/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

class ConnectionsFeed: CompositeFlattenableFeed<Connections> {

	fileprivate enum CodingKeys: String, CodingKey {
		case incoming
		case outgoing
		case users
		case page = "paging"
	}
    
    var incoming: [Connection]?
    var outgoing: [Connection]?
    var users: [User]?
    
    required init() {
        incoming = [Connection]()
        outgoing = [Connection]()
        super.init()
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
		if let json = json,
			let jsonData = try? JSONSerialization.data(withJSONObject: json,
			                                           options: JSONSerialization.WritingOptions.prettyPrinted){
			let decoder = JSONDecoder()
			return try? decoder.decode(ConnectionsFeed.self, from: jsonData)

		}
		return nil
    }

	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		users = try container.decodeIfPresent([User].self, forKey: CodingKeys.users)
		page = try container.decodeIfPresent(ApiPage.self, forKey: CodingKeys.page)
		incoming = try container.decodeIfPresent([Connection].self, forKey: CodingKeys.incoming)
		outgoing = try container.decodeIfPresent([Connection].self, forKey: CodingKeys.outgoing)
	}

	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(users, forKey: CodingKeys.users)
		try container.encodeIfPresent(page, forKey: CodingKeys.page)
		try container.encodeIfPresent(incoming, forKey: CodingKeys.incoming)
		try container.encodeIfPresent(outgoing, forKey: CodingKeys.outgoing)
	}
}
