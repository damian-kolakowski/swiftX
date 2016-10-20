//
//  emoji.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//

import Foundation

public func html(_ status: Int = Status.ok.rawValue, _ closure: ((Void) -> Void)? = nil) -> ScopesHtmlResponse {
    return ScopesHtmlResponse(status) {
        "html" ➜ {
            if let closure = closure {
                closure()
            }
        }
    }
}

public class ScopesHtmlResponse: Response {
    
    public init(_ status: Int = Status.ok.rawValue, _ closure: ((Void) -> Void)) {
        
        super.init(status)
        
        self.headers.append(("Content-Type", "text/html"))
        
        globalBuffer.removeAll(keepingCapacity: true)
        
        closure()
        
        self.body = Array<UInt8>(globalBuffer)
    }
}

infix operator ➜

func ➜ (_ left: String, _ closure: ((Void) -> Void)?) {
    
    globalBuffer.append(UInt8.lessThan)
    
    var tagName = [UInt8]()
    var tagEnd = false
    
    for c in left.utf8 {
        switch c {
        case UInt8.openingParenthesis:
            tagEnd = true
            globalBuffer.append(.space)
        case UInt8.closingParenthesis:
            globalBuffer.append(.doubleQuotes)
        case UInt8.equal:
            globalBuffer.append(.equal)
            globalBuffer.append(.doubleQuotes)
        case UInt8.comma:
            globalBuffer.append(.doubleQuotes)
            globalBuffer.append(.space)
        default:
            globalBuffer.append(c)
        }
        if !tagEnd {
            tagName.append(c)
        }
    }
    
    globalBuffer.append(UInt8.greaterThan)
    
    if let closure = closure {
        closure()
    }
    
    globalBuffer.append(UInt8.lessThan)
    globalBuffer.append(UInt8.slash)
    globalBuffer.append(contentsOf: tagName)
    globalBuffer.append(UInt8.greaterThan)
}

func ➜ (_ left: String, _ right: String) {
    globalBuffer.append(UInt8.lessThan)
    
    var tagName = [UInt8]()
    var tagEnd = false
    
    for c in left.utf8 {
        switch c {
        case UInt8.openingParenthesis:
            tagEnd = true
            globalBuffer.append(.space)
        case UInt8.closingParenthesis:
            globalBuffer.append(.doubleQuotes)
        case UInt8.equal:
            globalBuffer.append(.equal)
            globalBuffer.append(.doubleQuotes)
        case UInt8.comma:
            globalBuffer.append(.doubleQuotes)
            globalBuffer.append(.space)
        default:
            globalBuffer.append(c)
        }
        if !tagEnd {
            tagName.append(c)
        }
    }
    
    globalBuffer.append(UInt8.greaterThan)
    globalBuffer.append(contentsOf: right.utf8)
    globalBuffer.append(UInt8.lessThan)
    globalBuffer.append(UInt8.slash)
    globalBuffer.append(contentsOf: tagName)
    globalBuffer.append(UInt8.greaterThan)
}

var globalBuffer = [UInt8]()

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
