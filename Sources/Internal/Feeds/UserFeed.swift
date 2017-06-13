//
//  UserFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/8/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

class UserFeed: FlattenableFeed<User> {
    var users: [User]?
    
//    required init?(map: Map) {
//        super.init()
//    }

    required init() {
        self.users = [User]()
        super.init()
    }
    
//    override func mapping(map: Map) {
//        users <- map["users"]
//        page <- map["paging"]
//    }

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
}
