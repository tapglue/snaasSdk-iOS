//
//  CompositeFlattenableFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 9/30/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

class CompositeFlattenableFeed<T: DefaultInstanceEntity>: NullableFeed, Codable {
    var page: ApiPage?
    
    required init() {
        
    }
 
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//
//    }

    func flatten() -> T {
        return T()
    }
    
    func newCopy(json: [String:Any]?) -> CompositeFlattenableFeed<T>? {
        return nil
    }
}
