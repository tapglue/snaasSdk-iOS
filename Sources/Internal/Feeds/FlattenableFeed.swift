//
//  FlattenableFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 9/20/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class FlattenableFeed<T>: NullableFeed, Codable {

	fileprivate enum CodingKeys: String, CodingKey {
		case page = "paging"
	}

    var page: ApiPage?
    
    func flatten() -> [T] {
        return [T]()
    }
    
    required init() {
        
    }
    
    func newCopy(json: [String:Any]?) -> FlattenableFeed<T>? {
        return nil
    }

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		page = try container.decodeIfPresent(ApiPage.self, forKey: CodingKeys.page)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(page, forKey: CodingKeys.page)
	}
}
