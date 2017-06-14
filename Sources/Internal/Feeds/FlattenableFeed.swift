//
//  FlattenableFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 9/20/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class FlattenableFeed<T>: NullableFeed, Codable {
    var page: ApiPage?
    
    func flatten() -> [T] {
        return [T]()
    }
    
    required init() {
        
    }
    
    func newCopy(json: [String:Any]?) -> FlattenableFeed<T>? {
        return nil
    }

	required init(from decoder: Decoder) throws { }

	func encode(to encoder: Encoder) throws { }
}
