//
//  Observable+unwrapping.swift
//  Tapglue
//
//  Created by John Nilsen on 7/12/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import RxSwift

var disposeBag: DisposeBag!

private func initDisposeBag() {
    if disposeBag == nil {
        disposeBag = DisposeBag()
    }
}

extension Observable {
    func unwrap(completionHandler: (object: Element?, error: ErrorType?) -> ()) {
        initDisposeBag()
        self.subscribe { event in
            switch(event) {
            case .Next(let object):
                completionHandler(object:object, error: nil)
            case .Error(let error):
                completionHandler(object:nil, error: error)
            case .Completed:
                break
            }
        }.addDisposableTo(disposeBag)
    }
    
    func unwrap(completionHandler: (success: Bool, error: ErrorType?) -> ()) {
        initDisposeBag()
        self.subscribe { event in
            switch(event) {
            case .Next:
                break
            case .Error(let error):
                completionHandler(success: false, error: error)
            case .Completed:
                completionHandler(success: true, error: nil)
            }
        }.addDisposableTo(disposeBag)
    }
}