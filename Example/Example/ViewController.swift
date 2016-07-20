//
//  ViewController.swift
//  Example
//
//  Created by John Nilsen on 6/30/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import UIKit
import Tapglue

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapglue = RxTapglue(configuration: Configuration())
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

