//
//  Connections.swift
//  Tapglue
//
//  Created by John Nilsen on 7/29/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

/// List of connections
public class Connections {
    /// connections that were created by other users
    public var incoming: [Connection]?
    /// connections that were created by current user
    public var outgoing: [Connection]?
    
    init() {
        
    }
}
