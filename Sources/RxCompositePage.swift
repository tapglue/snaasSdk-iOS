//
//  RxCompositePage.swift
//  Tapglue
//
//  Created by John Nilsen on 9/30/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import RxSwift

open class RxCompositePage<T: DefaultInstanceEntity> {
    open var data: T {
        get {
            return feed.flatten() 
        }
    }
    
    open var previous: Observable<RxCompositePage<T>> {
        get {
            return generatePreviousObservable()
        }
    }
    
    fileprivate var feed: CompositeFlattenableFeed<T>
    fileprivate var prevPointer: String?
    
    init(feed: CompositeFlattenableFeed<T>, previousPointer: String?) {
        self.feed = feed
        self.prevPointer = previousPointer
    }
    
    
    func generatePreviousObservable() -> Observable<RxCompositePage<T>> {
        guard let prevPointer = prevPointer else {
            return Observable.just(RxCompositePage<T>(feed: CompositeFlattenableFeed<T>(), previousPointer: nil))
        }
        var request: URLRequest
        request = Router.getOnURL(prevPointer)
        
        return Http().execute(request).map { (json: [String: Any]) in
            let newFeed = self.feed.newCopy(json: json)
            let page = RxCompositePage<T>(feed: newFeed!, previousPointer: newFeed!.page?.before)
            return page
        }
    }
}
