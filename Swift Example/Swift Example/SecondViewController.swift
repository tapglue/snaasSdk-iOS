
//
//  SecondViewController.swift
//  Swift Example
//
//  Created by Martin Stemmle on 05/06/15.
//  Copyright (c) 2015 Tapglue. All rights reserved.
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

