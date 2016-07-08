//
//  Http.swift
//  Tapglue
//
//  Created by John Nilsen on 7/8/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import ObjectMapper

class Http {
    func execute<T:Mappable>(request: NSMutableURLRequest) -> Observable<T> {
        return Observable.create {observer in
            Alamofire.request(request)
                .validate()
                .debugLog()
                .responseObject { (response: Response<T, NSError>) in
                    switch(response.result) {
                    case .Success(let value):
                        print(value)
                        observer.on(.Next(value))
                        observer.on(.Completed)
                    case .Failure(let error):
                        observer.on(.Error(error))
                        if let data = response.data {
                            let json = String(data: data, encoding: NSUTF8StringEncoding)
                            print("Failure Response: \(json)")
                        }
                    }
                }
            return NopDisposable.instance
        }
    }
    
    func execute(request:NSMutableURLRequest) -> Observable<Void> {
        return Observable.create {observer in
            Alamofire.request(request)
                .validate()
                .debugLog()
                .responseJSON { response in
                    switch(response.result) {
                    case .Success:
                        observer.on(.Completed)
                    case .Failure(let error):
                        observer.on(.Error(error))
                        if let data = response.data {
                            let json = String(data: data, encoding: NSUTF8StringEncoding)
                            print("Failure Response: \(json)")
                        }
                    }
            }
            return NopDisposable.instance
        }
    }
}