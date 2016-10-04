//
//  RxCompositePage.swift
//  Tapglue
//
//  Created by John Nilsen on 9/30/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import RxSwift

public class RxCompositePage<T: DefaultInstanceEntity> {
    public var data: T {
        get {
            return feed.flatten() ?? T()
        }
    }
    
    public var previous: Observable<RxCompositePage<T>> {
        get {
            return generatePreviousObservable()
        }
    }
    
    private var feed: CompositeFlattenableFeed<T>
    private var prevPointer: String?
    
    init(feed: CompositeFlattenableFeed<T>, previousPointer: String?) {
        self.feed = feed
        self.prevPointer = previousPointer
    }
    
    
    func generatePreviousObservable() -> Observable<RxCompositePage<T>> {
        guard let prevPointer = prevPointer else {
            return Observable.just(RxCompositePage<T>(feed: CompositeFlattenableFeed<T>(), previousPointer: nil))
        }
        var request: NSMutableURLRequest
        request = Router.getOnURL(prevPointer)
        
        return Http().execute(request).map { (feed: CompositeFlattenableFeed<T>) in
            let page = RxCompositePage<T>(feed: feed, previousPointer: feed.page?.before)
            return page
        }
    }
}
