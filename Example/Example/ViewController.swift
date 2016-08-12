//
//  ViewController.swift
//  Example
//
//  Created by John Nilsen on 6/30/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import UIKit
import Tapglue
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let tapglue = RxTapglue(configuration: AppDelegate.config)
//        let pedro = User()
//        pedro.username = "pablo"
//        pedro.password = "supersecret"
//        
//        tapglue.createUser(pedro).doOnCompleted {
//            tapglue.loginUser("pablo", password: "supersecret").subscribeNext { user in
//                    print("logged in!")
//                }.addDisposableTo(self.disposeBag)
//        }.subscribe().addDisposableTo(disposeBag)
        
        
        
        
        
        
//        let tapglue = RxTapglue(configuration: Configuration())
//
//        let user = User()
//        user.username = "kdkjnkcaklsdmalksdav amcal"
//        user.password = "1234"
//        _ = tapglue.createUser(user).subscribeNext { user in
//            _ = tapglue.loginUser("kdkjnkcaklsdmalksdav amcal", password: "1234").subscribeNext { user in
//                print(tapglue.currentUser?.username)
//            }
//            
//        }
//        
//        print(tapglue.currentUser?.username)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

