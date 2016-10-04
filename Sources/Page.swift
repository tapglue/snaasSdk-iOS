//
//  Page.swift
//  Tapglue
//
//  Created by John Nilsen on 9/22/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

open class Page<T> {
    var rxPage: RxPage<T>
    open var data: [T] {
        get {
            return rxPage.data 
        }
    }
    
    init(rxPage: RxPage<T>) {
        self.rxPage = rxPage
    }

    open func previous(_ completionHandler: @escaping (Page<T>?, Error?) -> ()) {
        rxPage.previous.map { (rxPage: RxPage<T>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }
}
