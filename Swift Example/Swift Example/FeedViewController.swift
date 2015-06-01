//
//  FeedViewController.swift
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

class FeedViewController: UITableViewController {

    var events : [TGEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "loadFeed", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshControl?.beginRefreshing()
        self.loadFeed()
    }

    func loadFeed () {
        self.events = Tapglue.cachedFeedForCurrentUser() as? [TGEvent] ?? []
        self.tableView.reloadData()
        Tapglue.retrieveFeedForCurrentUserWithCompletionBlock { (feed : [AnyObject]!, unreadCound : Int, error : NSError!) -> Void in
            print("finished loading feed")
            if error != nil {
                UIAlertView(title: "error", message: "failed to load feed", delegate: nil, cancelButtonTitle: "Dismiss").show()
            }
            else {
                self.events = feed as! [TGEvent]
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FeedEventCell") as! CustomCell
        var event = self.events[indexPath.row]
        cell.configureWithEvent(event)
        return cell
    }
}
