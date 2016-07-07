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
        let tapglue = Tapglue()
        
//        tapglue.createUser("paco", password: "1234")
        tapglue.loginUser("paco", password: "1234").subscribe()
        // Do any additional setup after loading the view, typically from a nib.
        print("refreshing current user...")
        tapglue.refreshCurrentUser().subscribe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

