//
//  Page.swift
//  Tapglue
//
//  Created by John Nilsen on 9/13/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import RxSwift
import ObjectMapper

class RxPage<T, F: NullableFeed> {
    var data: [T] = [T]()
    typealias Feed = Mappable
    var previous: Observable<RxPage<T, F>> {
        get {
            return Http().execute(prevPointer!).map { (feed: F) in
                return self.parseFeed(feed: feed)
            }
        }
    }
    
    var prevPointer: NSMutableURLRequest?
    var parseFeed: (feed: F) -> RxPage<T, F> = { feed in
        return RxPage<T, F>()
    }
    
 //   var previousPageGenerator: ((observable: Observable<[T]>) -> Observable<RxPage<T>>)?
 //   var url: String?
 //   var previousHash: String?
}
