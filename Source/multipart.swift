//
//  multipart.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//


public extension Request {
    
    public func parseUrlencodedForm() -> [(String, String)] {
        guard let contentTypeHeader = headers.filter({ $0.0 == "content-type" }).first?.1 else {
            return []
        }
        let contentTypeHeaderTokens = contentTypeHeader.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        guard let contentType = contentTypeHeaderTokens.first, contentType == "application/x-www-form-urlencoded" else {
            return []
        }
        return self.body.split(separator: .ampersand).map { param -> (String, String) in
            let tokens = param.split(separator: 61)
            if let name = tokens.first, let value = tokens.last, tokens.count == 2 {
                let nameString = String(bytes: name, encoding: .ascii)?.removingPercentEncoding ?? ""
                let valueString = String(bytes: value, encoding: .ascii)?.removingPercentEncoding ?? ""
                return (nameString.replacingOccurrences(of: "+", with: " "),
                        valueString.replacingOccurrences(of: "+", with: " "))
            }
            return ("","")
        }
    }
    
    subscript(name: String) -> String? {
        get {
            let fields = parseUrlencodedForm()
            return fields.filter({ $0.0 == name }).first?.1
        }
        set(newValue) {
            
        }
    }
}
