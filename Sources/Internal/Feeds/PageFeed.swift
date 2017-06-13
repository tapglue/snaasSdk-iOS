//
//  PageFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 9/13/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

class PageFeed: Codable {
    var page: ApiPage?
//    required init?(map: Map) {
//
//    }

//    func mapping(map: Map) {
//        page <- map["paging"]
//    }
}

class ApiPage: Codable {
    var before: String?


//    required init?(map: Map) {
//
//    }

//    func mapping(map: Map) {
//        before <- map["previous"]
//    }
}
