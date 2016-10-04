//
//  CompositeFlattenableFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 9/30/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

class CompositeFlattenableFeed<T: DefaultInstanceEntity>: NullableFeed {
    var page: ApiPage?
    
    required init() {
        
    }
 
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
    func flatten() -> T {
        return T()
    }
}
