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
    func unwrap(_ completionHandler: @escaping (_ object: Element?, _ error: Error?) -> ()) {
        initDisposeBag()
        self.subscribe { event in
            switch(event) {
            case .next(let object):
                completionHandler(object, nil)
            case .error(let error):
                completionHandler(nil, error)
            case .completed:
                break
            }
        }.addDisposableTo(disposeBag)
    }
    
    func unwrap(_ completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        initDisposeBag()
        self.subscribe { event in
            switch(event) {
            case .next:
                break
            case .error(let error):
                completionHandler(false, error)
            case .completed:
                completionHandler(true, nil)
            }
        }.addDisposableTo(disposeBag)
    }
}
