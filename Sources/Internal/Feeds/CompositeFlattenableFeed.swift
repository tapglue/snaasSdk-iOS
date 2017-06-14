//
//  CompositeFlattenableFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 9/30/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

class CompositeFlattenableFeed<T: DefaultInstanceEntity>: NullableFeed, Codable {

	fileprivate enum CodingKeys: String, CodingKey {
		case incoming
		case outgoing
		case users
		case page = "paging"
	}
	
    var page: ApiPage?
    
    required init() {
        
    }

    func flatten() -> T {
        return T()
    }
    
    func newCopy(json: [String:Any]?) -> CompositeFlattenableFeed<T>? {
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
