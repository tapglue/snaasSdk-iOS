//
//  Page.swift
//  Tapglue
//
//  Created by John Nilsen on 9/13/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import RxSwift

public protocol RxPage {
    associatedtype T
    var data: T {get}
    var previous: Observable<Self> {get}
}