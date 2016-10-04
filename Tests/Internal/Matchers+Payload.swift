//
//  Matchers+Payload.swift
//  Tapglue
//
//  Created by John Nilsen on 7/7/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import Mockingjay

public func http(_ method: HTTPMethod, uri: String, payload: Dictionary<String, AnyObject>) -> (_ request:URLRequest) -> Bool {
    return { (request: URLRequest) in
        if let body = request.httpBody {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: body, options: .mutableContainers) as? [String: AnyObject]
            if let dictionary = dictionary {
                if !NSDictionary(dictionary: payload).isEqual(to: dictionary) {
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
