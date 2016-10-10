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
    
    func execute<T:Mappable>(_ request: URLRequestConvertible) -> Observable<T> {
        return Observable.create {observer in
            Alamofire.request(request)
                .validate()
                .debugLog()
                .responseJSON { (response:DataResponse<Any>) in
                    log(response.response?.statusCode)
                    log(response.result.value)
                    switch(response.result) {
                    case .success(let value):
                        log(value)
                        if let object = Mapper<T>().map(JSONObject: value) {
                            observer.on(.next(object))
                        } else {
                            if let nf = T.self as? NullableFeed.Type {
                                let defaultObject = nf.init()
                                observer.on(.next(defaultObject as! T))
                            }
                        }
                        observer.on(.completed)
                    case .failure(let error):
                        self.handleError(response.data, onObserver: observer, withDefaultError:error)
                }
            }
            return Disposables.create()
        }
    }
    
    func execute(_ request:URLRequestConvertible) -> Observable<Void> {
        return Observable.create {observer in
            Alamofire.request(request)
                .validate()
                .debugLog()
                .responseJSON { response in
                    log(response.response?.statusCode)
                    switch(response.result) {
                    case .success:
                        observer.on(.completed)
                    case .failure(let error):
                        self.handleError(response.data, onObserver: observer, withDefaultError: error)
                    }
            }
            return Disposables.create()
        }
    }

    fileprivate func handleError<T>(_ data: Data?, onObserver observer: AnyObserver<T>,
                                withDefaultError error: Error) {
        if let data = data {
            let json = String(data: data, encoding: String.Encoding.utf8)!
            if let errorFeed = Mapper<ErrorFeed>().map(JSONString: json) {
                log(errorFeed.toJSONString())
                if let tapglueErrors = errorFeed.errors {
                    observer.on(.error(tapglueErrors[0]))
                } else {
                    observer.on(.error(error ?? TapglueError()))
                }
            } else {
                observer.on(.error(error ?? TapglueError()))
            }
        }
    }
}
