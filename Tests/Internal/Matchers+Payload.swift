//
//  Matchers+Payload.swift
//  Tapglue
//
//  Created by John Nilsen on 7/7/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import Mockingjay

public func http(method: HTTPMethod, uri: String, payload: Dictionary<String, AnyObject>) -> (request:NSURLRequest) -> Bool {
    return { (request: NSURLRequest) in
        if let body = request.HTTPBody {
        do {
            let dictionary = try NSJSONSerialization.JSONObjectWithData(body, options: .MutableContainers) as? [String: AnyObject]
            if let dictionary = dictionary {
                if !NSDictionary(dictionary: payload).isEqualToDictionary(dictionary) {
                    return false
                }
            } else {
                return false
            }
        } catch {
            return false
        }
            return Mockingjay.http(method, uri: uri)(request:request)
        } else {
            return false
        }
    }
}
