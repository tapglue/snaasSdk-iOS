//
//  Connections.swift
//  Tapglue
//
//  Created by John Nilsen on 7/29/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

/// List of connections
open class Connections: NSObject, DefaultInstanceEntity {
    /// connections that were created by other users
    open var incoming: [Connection]?
    /// connections that were created by current user
    open var outgoing: [Connection]?
    
    required public override init() {
        
    }
}
