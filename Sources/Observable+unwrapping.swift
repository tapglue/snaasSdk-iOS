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
    func unwrap(_ completionHandler: (_ object: Element?, _ error: ErrorProtocol?) -> ()) {
        initDisposeBag()
        self.subscribe { event in
            switch(event) {
            case .next(let object):
                completionHandler(object:object, error: nil)
            case .Error(let error):
                completionHandler(object:nil, error: error)
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
            case .Error(let error):
                completionHandler(success: false, error: error)
            case .completed:
                completionHandler(success: true, error: nil)
            }
        }.addDisposableTo(disposeBag)
    }
}
