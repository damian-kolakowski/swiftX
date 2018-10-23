//
//  net.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//

import Foundation

public protocol TcpServer {
    
    init(_ port: in_port_t) throws
    
    func wait(_ callback: ((TcpServerEvent) -> Void)) throws
    
    func write(_ socket: Int32, _ data: Array<UInt8>, _ done: @escaping (() -> TcpWriteDoneAction)) throws
    
    func finish(_ socket: Int32)
}

public enum TcpWriteDoneAction {
    
    case `continue`
    
    case terminate
}

public enum TcpServerEvent {
    
    case connect(String, Int32)
    
    case disconnect(String, Int32)
    
    case data(String, Int32, ArraySlice<UInt8>)
}
