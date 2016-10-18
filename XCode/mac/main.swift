//
//  main.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//

import Foundation

let server = try Server()

while true {
    try server.serve { req, resp in
        switch req.path {
            case "/test":
                resp(ScopesResponse(200) {
                    🏷("html") {
                        🏷("body") {
                            🏷("div", inner: "hello world")
                            for i in 0...1000 {
                                🏷("div", inner: "hello world \(i)")
                            }
                        }
                    }
                })
            
        default:
            resp(Response(404))
        }
    }
}



