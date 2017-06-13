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
        return RxPage<T>(feed: self, previousPointer: self.page?.before)
    }

    func rxPage(_ payload: [String: Any]?) -> RxPage<T> {
        let page = rxPage()
        page.payload = payload
        return page
    }
}
