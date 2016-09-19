//
//  Page.swift
//  Tapglue
//
//  Created by John Nilsen on 9/13/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import RxSwift
import ObjectMapper

public class RxPage<T> {
    var data: [T] = [T]()
    public var previous: Observable<RxPage<T>> {
        get {
            return Http().execute(prevPointer!).map { (feed:Mappable) in
                return self.parseFeed(feed: feed)
            }
        }
    }
    
    var prevPointer: NSMutableURLRequest?
    var parseFeed: (feed: Mappable) -> RxPage<T> = { feed in
        return RxPage<T>()
    }

    
 //   var previousPageGenerator: ((observable: Observable<[T]>) -> Observable<RxPage<T>>)?
 //   var url: String?
 //   var previousHash: String?
}
