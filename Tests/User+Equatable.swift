//
//  User+Equatable.swift
//  Tapglue
//
//  Created by John Nilsen on 7/8/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
@testable import Tapglue


func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
}
