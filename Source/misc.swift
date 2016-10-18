//
//  misc.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//

import Foundation

public extension UInt8 {
    
    public static var lf: UInt8 = 10, cr: UInt8 = 13, space: UInt8 = 32, colon: UInt8 = 58
}

public struct Process {
    
    public static var pid: Int {
        return Int(getpid())
    }
    
    public static var tid: UInt64 {
        #if os(Linux)
            return UInt64(pthread_self())
        #else
            var tid: __uint64_t = 0
            pthread_threadid_np(nil, &tid);
            return UInt64(tid)
        #endif
    }
    
    public static var error: String {
        return String(cString: UnsafePointer(strerror(errno)))
    }
}
