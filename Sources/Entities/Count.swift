//
//  Count.swift
//  Tapglue
//
//  Created by John Rikard Nilsen on 2017-07-19.
//  Copyright © 2017 Tapglue. All rights reserved.
//

import ObjectMapper

open class Count: Mappable {
    open var count: Int?

    required public init?(map: Map) {

    }

    open func mapping(map: Map) {
        count <- map["value"]
    }
}
