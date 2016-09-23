//
//  FlattenableFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 9/20/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class FlattenableFeed<T>: NullableFeed {
    var page: ApiPage?
    
    func flatten() -> [T] {
        return [T]()
    }
    
    required init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}
