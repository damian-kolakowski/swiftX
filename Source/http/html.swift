//
//  emoji.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//

import Foundation

var globalBuffer = [UInt64: [UInt8]]()

public func html(_ status: Int = Status.ok.rawValue, _ closure: (() -> Void)? = nil) -> ScopesHtmlResponse {
    return ScopesHtmlResponse(status) {
        globalBuffer[Process.tid] = [UInt8]()
        globalBuffer[Process.tid]?.reserveCapacity(1024)
        globalBuffer[Process.tid]?.append(contentsOf: "<!DOCTYPE html>".utf8)
        "html" ~ {
            if let closure = closure {
                closure()
            }
        }
    }
}

public class ScopesHtmlResponse: Response {
    
    public init(_ status: Int = Status.ok.rawValue, _ closure: (() -> Void)) {
        
        super.init(status)
        
        self.headers.append(("Content-Type", "text/html"))
        
        globalBuffer.removeAll(keepingCapacity: true)
        
        closure()
        
        if let buffer = globalBuffer[Process.tid] {
            self.body = Array<UInt8>(buffer)
        }
    }
}

infix operator ~

func ~ (_ left: String, _ closure: (() -> Void)?) {
    
    globalBuffer[Process.tid]?.append(UInt8.lessThan)
    
    var tagName = [UInt8]()
    var tagEnd = false
    
    for c in left.utf8 {
        switch c {
        case UInt8.openingParenthesis:
            tagEnd = true
            globalBuffer[Process.tid]?.append(.space)
        case UInt8.closingParenthesis:
            globalBuffer[Process.tid]?.append(.doubleQuotes)
        case UInt8.equal:
            globalBuffer[Process.tid]?.append(.equal)
            globalBuffer[Process.tid]?.append(.doubleQuotes)
        case UInt8.comma:
            globalBuffer[Process.tid]?.append(.doubleQuotes)
            globalBuffer[Process.tid]?.append(.space)
        default:
            globalBuffer[Process.tid]?.append(c)
        }
        if !tagEnd {
            tagName.append(c)
        }
    }
    
    globalBuffer[Process.tid]?.append(UInt8.greaterThan)
    
    if let closure = closure {
        closure()
    }
    
    globalBuffer[Process.tid]?.append(UInt8.lessThan)
    globalBuffer[Process.tid]?.append(UInt8.slash)
    globalBuffer[Process.tid]?.append(contentsOf: tagName)
    globalBuffer[Process.tid]?.append(UInt8.greaterThan)
}

func ~ (_ left: String, _ right: String) {
    
    globalBuffer[Process.tid]?.append(UInt8.lessThan)
    
    var tagName = [UInt8]()
    var tagEnd = false
    
    for c in left.utf8 {
        switch c {
        case UInt8.openingParenthesis:
            tagEnd = true
            globalBuffer[Process.tid]?.append(.space)
        case UInt8.closingParenthesis:
            globalBuffer[Process.tid]?.append(.doubleQuotes)
        case UInt8.equal:
            globalBuffer[Process.tid]?.append(.equal)
            globalBuffer[Process.tid]?.append(.doubleQuotes)
        case UInt8.comma:
            globalBuffer[Process.tid]?.append(.doubleQuotes)
            globalBuffer[Process.tid]?.append(.space)
        default:
            globalBuffer[Process.tid]?.append(c)
        }
        if !tagEnd {
            tagName.append(c)
        }
    }
    
    globalBuffer[Process.tid]?.append(UInt8.greaterThan)
    globalBuffer[Process.tid]?.append(contentsOf: right.utf8)
    globalBuffer[Process.tid]?.append(UInt8.lessThan)
    globalBuffer[Process.tid]?.append(UInt8.slash)
    globalBuffer[Process.tid]?.append(contentsOf: tagName)
    globalBuffer[Process.tid]?.append(UInt8.greaterThan)
}

public func 🦄(port: Int, closure: @escaping (((Response) -> Void) -> Void)) {
    do {
        let server = try Server()
        while true {
            try server.serve { (request, responder) in
                closure(responder)
            }
        }
    } catch {
        print(error)
    }
}

public func 🚀(_ responder: ((Response) -> Void), _ text: String? = nil) {
    if let text = text {
        responder(Response([UInt8](text.utf8)))
    } else {
        responder(Response(404))
    }
}
