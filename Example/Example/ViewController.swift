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
        
        //let tapglue = Tapglue(configuration: AppDelegate.config)
        //tapglue.loginUser("pablo", password: "supersecret") { user, error in
        //    print(user?.username ?? "was nil!")
        //    tapglue.retrieveActivitiesByUser(user!.id!) { activities, error in
        //        
        //    }
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

