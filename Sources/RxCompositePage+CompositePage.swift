//
//  RxCompositePage+CompositePage.swift
//  Tapglue
//
//  Created by John Nilsen on 10/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

extension RxCompositePage {
    func page() -> CompositePage<T> {
        return CompositePage<T>(rxPage: self)
    }
}
