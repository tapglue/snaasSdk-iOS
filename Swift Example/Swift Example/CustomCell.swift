//
//  CustomCell.swift
//  Swift Example
//
//  Created by Onur Akpolat on 09/06/15.
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

class CustomCell: UITableViewCell {

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWithEvent(event : TGEvent!) {

        let elapsedTime = NSDate().timeIntervalSinceDate(event.createdAt)

        let duration = Int(elapsedTime)

        let text = String(format: "%@ %@ %@", event.user.firstName, event.user.lastName, event.type)

        let durationText = String(format: "%d seconds ago", duration)

        self.activityLabel.text = text
        self.secondsLabel.text = durationText



        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.doesRelativeDateFormatting = true


        self.secondsLabel.text = dateFormatter.stringFromDate(event.createdAt)

        if event.type == "liked" {
            self.typeImage.image = UIImage(named: "like") as UIImage!
        } else if event.type == "starred" {
            self.typeImage.image = UIImage(named: "star") as UIImage!

        } else if event.type == "checked in" {
            self.typeImage.image = UIImage(named: "checkin") as UIImage!
        }

    }

}
