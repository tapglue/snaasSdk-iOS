//
//  Alamofire+Logging.swift
//  Tapglue
//
//  Created by John Nilsen on 7/1/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Alamofire

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            log(self)
        #endif
        return self
    }
}