//
//  TapglueError.swift
//  Tapglue
//
//  Created by John Nilsen on 7/21/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import ObjectMapper

public class TapglueError: Mappable, ErrorType {
    public var code: Int?
    public var message: String?
    
    init() {
        
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
