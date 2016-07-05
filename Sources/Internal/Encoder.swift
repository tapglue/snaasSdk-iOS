//
//  Encoder.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

class Encoder {
    static func encode(appToken: String, sessionToken: String) -> String {
        let input = appToken + ":" + sessionToken
        let utf8Input = input.dataUsingEncoding(NSUTF8StringEncoding)
        return utf8Input?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) ?? ""
    }
}
