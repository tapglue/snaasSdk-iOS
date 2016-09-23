//
//  RxPage+Page.swift
//  Tapglue
//
//  Created by John Nilsen on 9/22/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

extension RxPage {
    func page() -> Page<T> {
        let page = Page<T>()
        page.rxPage = self
        return page
    }
}
