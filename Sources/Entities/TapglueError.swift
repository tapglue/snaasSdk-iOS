//
//  TapglueError.swift
//  Tapglue
//
//  Created by John Nilsen on 7/21/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

open class TapglueError: Codable, Error {
    open var code: Int?
    open var message: String = "unknown error"
    
    init() {
        
    }

	public required init(from decoder: Decoder) throws {

	}

	public func encode(to encoder: Encoder) throws {

	}
    
//    required public init?(map: Map) {
//
//    }
//
//    open func mapping(map: Map) {
//        code <- map["code"]
//        message <- map["message"]
//    }
}
