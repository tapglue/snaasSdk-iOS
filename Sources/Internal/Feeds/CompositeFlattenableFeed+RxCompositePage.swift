//
//  CompositeFlattenableFeed+RxCompositePage.swift
//  Tapglue
//
//  Created by John Nilsen on 9/30/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

extension CompositeFlattenableFeed {
    func rxPage() -> RxCompositePage<T> {
        return RxCompositePage(feed: self, previousPointer: self.page?.before)
    }
}
