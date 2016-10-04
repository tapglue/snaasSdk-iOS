//
//  CompositePage.swift
//  Tapglue
//
//  Created by John Nilsen on 10/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

open class CompositePage<T: DefaultInstanceEntity> {
    open var data: T {
        get {
            return rxPage.data 
        }
    }
    
    var rxPage: RxCompositePage<T>
    
    init(rxPage: RxCompositePage<T>) {
        self.rxPage = rxPage
    }
    
    open func previous(_ completionHandler: @escaping (_ page: CompositePage<T>?, _ error:Error?) -> ()) {
        rxPage.previous.map { (rxPage: RxCompositePage<T>) in
            return rxPage.page()
            }.unwrap(completionHandler)
    }
}
