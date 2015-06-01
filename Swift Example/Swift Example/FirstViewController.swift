//
//  FirstViewController.swift
//  Swift Example
//
//  Created by Martin Stemmle on 05/06/15.
//  Copyright (c) 2015 Tapglue (https://www.tapglue.com/). All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

class FirstViewController: BaseViewController {

    // Labels
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!

    // Images
    @IBOutlet weak var firstUserImage: UIImageView!
    @IBOutlet weak var secondUserImage: UIImageView!
    @IBOutlet weak var thirdUserImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.firstUserImage.highlighted = true;
        self.updateUserData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAsUser1(sender: AnyObject) {
        self.loginWithEmail("norman.test@tapglue.com", andPassword: "password")

        self.firstUserImage.highlighted = true;
        self.secondUserImage.highlighted = false;
        self.thirdUserImage.highlighted = false;
    }

    @IBAction func loginAsUser2(sender: AnyObject) {
        self.loginWithEmail("martin.test@tapglue.com", andPassword: "password")

        self.firstUserImage.highlighted = false;
        self.secondUserImage.highlighted = true;
        self.thirdUserImage.highlighted = false;
    }

    @IBAction func loginAsUser3(sender: AnyObject) {
        self.loginWithEmail("onur.test@tapglue.com", andPassword: "password")

        self.firstUserImage.highlighted = false;
        self.secondUserImage.highlighted = false;
        self.thirdUserImage.highlighted = true;
    }

    func loginWithEmail(email : String!, andPassword password : String!) {
        self.showLoadingView()
        Tapglue.loginWithUsernameOrEmail(email, andPasswort: password) { (success : Bool, error : NSError!) -> Void in
            print("login done: success=\(success), error=\(error)")

            if (NSThread.isMainThread()) {
                self.updateUserData()
                self.hideLoadingView()
            }
            else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.updateUserData()
                    self.hideLoadingView()
                })
            }
        }
    }

    func updateUserData() {
        if let curUser = TGUser.currentUser() {
            self.userNameLabel.text = curUser.username
            self.userEmailLabel.text = curUser.email
            self.firstNameLabel.text = curUser.firstName
            self.lastNameLabel.text = curUser.lastName
            self.userIdLabel.text = curUser.userId

            self.view.setNeedsDisplay()
        }
    }

}

