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
    public var data: [T] {
        get {
            return feed?.flatten() ?? [T]()
        }
    }
    public var previous: Observable<RxPage<T>> {
        get {
            return generatePreviousObservable()
        }
    }
    
    var feed: FlattenableFeed<T>?
    var prevPointer: String?
    var payload: [String: AnyObject]?
    
    func generatePreviousObservable() -> Observable<RxPage<T>> {
        guard let prevPointer = prevPointer else {
            return Observable.just(RxPage<T>())
        }
        var request: NSMutableURLRequest
        if let payload = payload {
            request = Router.postOnURL(prevPointer, payload: payload)
        } else {
            request = Router.getOnURL(prevPointer)
        }
        
        return Http().execute(request).map { (feed: FlattenableFeed<T>) in
            let page = RxPage<T>()
            page.feed = feed
            page.prevPointer = feed.page?.before
            page.payload = self.payload
            return page
        }
    }
}
