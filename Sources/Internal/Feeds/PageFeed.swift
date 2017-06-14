//
//  PageFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 9/13/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

class PageFeed: Codable {
	fileprivate enum CodingKeys: String, CodingKey {
		case page = "paging"
	}

    var page: ApiPage?

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		page = try container.decodeIfPresent(ApiPage.self, forKey: CodingKeys.page)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(page, forKey: CodingKeys.page)
	}
	
}

class ApiPage: Codable {

	fileprivate enum CodingKeys: String, CodingKey {
		case before = "previous"
	}
	
    var before: String?

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		before = try container.decodeIfPresent(String.self, forKey: CodingKeys.before)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(before, forKey: CodingKeys.before)
	}
}
