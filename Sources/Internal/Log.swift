//
//  Log.swift
//  Tapglue
//
//  Created by John Nilsen on 8/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

class Log {
    static var isDebug = false
}

func log(log: Any...) {
    if Log.isDebug {
        debugPrint(log)
    }
}
