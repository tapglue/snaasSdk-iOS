//
//  SecondViewController.swift
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

class SecondViewController: BaseViewController {

    // Buttons

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let likeNormal = UIImage(named: "like") as UIImage!
        likeButton.setTitle("", forState: .Normal)
        likeButton.setImage(likeNormal, forState: .Normal)

        let starNormal = UIImage(named: "star") as UIImage!
        starButton.setTitle("", forState: .Normal)
        starButton.setImage(starNormal, forState: .Normal)

        let checkInNormal = UIImage(named: "checkin") as UIImage!
        checkInButton.setTitle("", forState: .Normal)
        checkInButton.setImage(checkInNormal, forState: .Normal)

    }

    @IBAction func likeSomethingRandom(sender: AnyObject) {
        self.createEventWithType("liked")
    }

    @IBAction func favSomethingRandom(sender: AnyObject) {
        self.createEventWithType("starred")
    }

    @IBAction func checkInRandom(sender: AnyObject) {
        self.createEventWithType("checked in")
    }

    func createEventWithType(type : String!) {
        Tapglue.createEventWithType(type, onObject: nil)
    }

}

