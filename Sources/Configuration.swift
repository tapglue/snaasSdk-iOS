//
//  Configuration.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

/// Configuration of the tapglue SDK
open class Configuration {
    /// base url given to you by taplgue, default value is [https://api.tapglue.com](https://api.tapglue.com)
    open var baseUrl = "https://api.tapglue.com"
    /// app token given to you by tapglue
    open var appToken = "365612c09fc7d75eb1dc2bee9f127c6d"
    /// when true http requests and responses will be printed to the console
    open var log = true
    
    public init() {
        
    }
}
