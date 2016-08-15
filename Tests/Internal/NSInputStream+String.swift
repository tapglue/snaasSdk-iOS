//
//  NSInputStream+String.swift
//  Tapglue
//
//  Created by John Nilsen on 7/7/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

extension NSInputStream
{
    public func readString(length:Int) -> String {
        
        var str = ""
        
        if length > 0 {
            let readBuffer = UnsafeMutablePointer<UInt8>.alloc(length+1)
            
            let numberOfBytesRead = self.read(readBuffer, maxLength: length)
            if numberOfBytesRead == length {
                
                let buf = UnsafeMutablePointer<CChar>(readBuffer)
                buf[length] = 0
                // the C String must be null terminated
                if let utf8String = String.fromCString(buf) {
                    str = utf8String
                }
            }
            readBuffer.dealloc(length)
        }
        return str
        
    }
}