//
//  Page.swift
//  Tapglue
//
//  Created by John Nilsen on 9/22/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

public class Page<T> {
    var rxPage: RxPage<T>
    public var data: [T] {
        get {
            return rxPage.data ?? [T]()
        }
    }
    
    init(rxPage: RxPage<T>) {
        self.rxPage = rxPage
    }

    public func previous(completionHandler: (page: Page<T>?, error:ErrorType?) -> ()) {
        rxPage.previous.map { (rxPage: RxPage<T>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }
}
