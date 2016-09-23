//
//  FlattenableFeed+RxPage.swift
//  Tapglue
//
//  Created by John Nilsen on 9/23/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

extension FlattenableFeed {
    func rxPage() -> RxPage<T> {
        let page = RxPage<T>()
        page.feed = self
        page.prevPointer = self.page?.before
        return page
    }

    func rxPage(payload: [String: AnyObject]) -> RxPage<T> {
        let page = rxPage()
        page.payload = payload
        return page
    }
}
