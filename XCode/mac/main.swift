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
                resp(html {
                    "body" ~ "test"
                })
            
        default:
            resp(Response(404))
        }
    }
}



