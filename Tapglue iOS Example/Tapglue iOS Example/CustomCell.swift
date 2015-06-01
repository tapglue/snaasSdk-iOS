//
//  CustomCell.swift
//  Tapglue iOS Example
//
//  Created by Onur Akpolat on 09/06/15.
//  Copyright (c) 2015 Tapglue. All rights reserved.
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
        
        var text = String(format: "%@ %@ %@", event.user.firstName, event.user.lastName, event.type)
        
        var durationText = String(format: "%d seconds ago", duration)
        
        self.activityLabel.text = text
        self.secondsLabel.text = durationText
        
        
        
        var dateFormatter = NSDateFormatter()
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
