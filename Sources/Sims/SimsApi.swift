//
//  SimsApi.swift
//  simsTest
//
//  Created by John Nilsen on 5/19/16.
//  Copyright © 2016 John Nilsen. All rights reserved.
//

import Foundation

protocol SimsApi {
    func registerDevice(_ appToken: String, deviceToken: String, sessionToken: String)
}
