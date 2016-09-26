//
//  Encoder.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

class Encoder {
    static func encode(_ appToken: String, sessionToken: String) -> String {
        let input = appToken + ":" + sessionToken
        let utf8Input = input.data(using: String.Encoding.utf8)
        return utf8Input?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) ?? ""
    }
}
