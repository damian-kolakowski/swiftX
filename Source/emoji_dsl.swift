//
//  emoji.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//

import Foundation

public class ScopesHtmlResponse: Response {
    
    public init(_ status: Int = Status.ok.rawValue, _ closure: ((Void) -> Void)) {
        
        super.init(status)
        
        self.headers.append(("Content-Type", "text/html"))
        
        labelGlobalBuffer = ""
        
        closure()
        
        self.body = [UInt8](labelGlobalBuffer.utf8)
    }
}

public func html(_ status: Int = Status.ok.rawValue, _ closure: ((Void) -> Void)? = nil) -> ScopesHtmlResponse {
    return ScopesHtmlResponse(status) {
        🏷("html") {
            if let closure = closure {
                closure()
            }
        }
    }
}

var labelGlobalBuffer = ""

public func 🏷(_ name: String, _ closure: ((Void) -> Void)? = nil) {
    let save = labelGlobalBuffer + "<" + name + ">"
    labelGlobalBuffer = ""
    if let closure = closure {
        closure()
    }
    labelGlobalBuffer = save + labelGlobalBuffer + "</" + name + ">"
}

public func 🏷(_ name: String, inner: String? = nil) {
    let save = labelGlobalBuffer + "<" + name + ">"
    labelGlobalBuffer = inner ?? ""
    labelGlobalBuffer = save + labelGlobalBuffer + "</" + name + ">"
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
