//
//  NSInputStream+String.swift
//  Tapglue
//
//  Created by John Nilsen on 7/7/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

extension InputStream
{
    public func readString(_ length:Int) -> String {
        
        var str = ""
        
        if length > 0 {
            let readBuffer = UnsafeMutablePointer<UInt8>(allocatingCapacity: length+1)
            
            let numberOfBytesRead = self.read(readBuffer, maxLength: length)
            if numberOfBytesRead == length {
                
                let buf = UnsafeMutablePointer<CChar>(readBuffer)
                buf[length] = 0
                // the C String must be null terminated
                if let utf8String = String(validatingUTF8: buf) {
                    str = utf8String
                }
            }
            readBuffer.deallocate(capacity: length)
        }
        return str
        
    }
}
