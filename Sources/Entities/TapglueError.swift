//
//  TapglueError.swift
//  Tapglue
//
//  Created by John Nilsen on 7/21/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

open class TapglueError: Mappable, Error {
    open var code: Int?
    open var message: String?
    
    init() {
        
    }
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
