//
//  CompositePage.swift
//  Tapglue
//
//  Created by John Nilsen on 10/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

public class CompositePage<T: DefaultInstanceEntity> {
    public var data: T {
        get {
            return rxPage.data 
        }
    }
    
    var rxPage: RxCompositePage<T>
    
    init(rxPage: RxCompositePage<T>) {
        self.rxPage = rxPage
    }
    
    public func previous(completionHandler: (_ page: CompositePage<T>?, error:ErrorType?) -> ()) {
        rxPage.previous.map { (rxPage: RxCompositePage<T>) in
            return rxPage.page()
            }.unwrap(completionHandler)
    }
}
