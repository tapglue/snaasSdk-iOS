//
//  NullableFeed.swift
//  Tapglue
//
//  Created by John Nilsen on 7/26/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NullableFeed: Mappable {
    //use this init to construct a default feed representation. Useful for 204 responses
    init()
}