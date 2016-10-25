//
//  wrror.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//

import Foundation

public enum AsyncError: Error {
    case parse(String)
    case async(String)
    case socketCreation(String)
    case setReUseAddr(String)
    case setNoSigPipeFailed(String)
    case setNonBlockFailed(String)
    case setReuseAddrFailed(String)
    case bindFailed(String)
    case listenFailed(String)
    case writeFailed(String)
    case getPeerNameFailed(String)
    case convertingPeerNameFailed
    case getNameInfoFailed(String)
    case acceptFailed(String)
    case readFailed(String)
    case httpError(String)
}
