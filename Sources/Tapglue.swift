//
//  File.swift
//  Tapglue
//
//  Created by John Nilsen on 7/12/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import RxSwift

public class Tapglue {
    let disposeBag = DisposeBag()
    let rxTapglue: RxTapglue
    
    public init(configuration: Configuration) {
        rxTapglue = RxTapglue(configuration: configuration)
    }
    
    public func loginUser(username: String, password: String, completionHandler: (user: User?, error: ErrorType?) -> ()) {
        rxTapglue.loginUser(username, password: password).unwrap(completionHandler)
    }
}