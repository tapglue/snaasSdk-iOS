//
//  UserFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/8/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

class UserFeed: FlattenableFeed<User> {

	fileprivate enum CodingKeys: String, CodingKey {
		case users
		case page = "paging"
	}

    var users: [User]?

    required init() {
        self.users = [User]()
        super.init()
    }

    override func flatten() -> [User] {
       return users ?? [User]()
    }
    
    override func newCopy(json: [String:Any]?) -> UserFeed? {
		if let json = json,
			let jsonData = try? JSONSerialization.data(withJSONObject: json,
		                                              options: JSONSerialization.WritingOptions.prettyPrinted){
			let decoder = JSONDecoder()
			return try? decoder.decode(UserFeed.self, from: jsonData)
        	
		}
		return nil
    }

	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		users = try container.decodeIfPresent([User].self, forKey: CodingKeys.users)
		self.page = try container.decodeIfPresent(ApiPage.self, forKey: CodingKeys.page)
	}

	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(users, forKey: CodingKeys.users)
		try container.encodeIfPresent(page, forKey: CodingKeys.page)
	}
}
