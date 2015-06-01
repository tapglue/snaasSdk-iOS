//
//  BaseViewController.swift
//  Swift Example
//
//  Created by Martin Stemmle on 05/06/15.
//  Copyright (c) 2015 Tapglue. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var loadingAlertView = UIAlertView(title: "loading", message: nil, delegate: nil, cancelButtonTitle: nil)

    func showLoadingView() {
        self.loadingAlertView.show()
    }
    
    func hideLoadingView() {
        self.loadingAlertView.dismissWithClickedButtonIndex(0, animated: true)
    }
}
