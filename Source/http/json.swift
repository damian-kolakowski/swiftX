//
//  json.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//

import Foundation

public class JsonResponse: Response {
    
    private func commonInit() {
        self.headers.append(("Content-Type", "application/json"))
    }
    
    public init(_ status: Int = Status.ok.rawValue, _ dictionary: Dictionary<String, Any>) {
        super.init(status)
        self.commonInit()
        self.body = dictionary.toJson()
    }
 
    public init(_ status: Int = Status.ok.rawValue, _ array: Array<Any>) {
        super.init(status)
        self.commonInit()
        self.body = array.toJson()
    }
}

extension Dictionary {
    
    public func toJson() -> [UInt8] {
        var result = [UInt8]()
        result.append(0x7B)
        for (key, value) in self {
            if let stringKey = key as? String {
                result.append(contentsOf: escapeJSONString(stringKey))
                result.append(0x3A)
                result.append(contentsOf: asJsonValue(value))
            }
            result.append(0x2C)
        }
        if !self.isEmpty {
            result.removeLast()
        }
        result.append(0x7D)
        return result
    }
}

extension Array {
    
    public func toJson() -> [UInt8] {
        var result = [UInt8]()
        result.append(0x5B)
        for item in self {
            result.append(contentsOf: asJsonValue(item))
            result.append(0x2C)
        }
        if !self.isEmpty {
            result.removeLast()
        }
        result.append(0x5D)
        return result
    }
}

private func escapeJSONString(_ string: String) -> [UInt8] {
    var result = [UInt8]()
    result.append(0x22)
    for scalar in string.unicodeScalars {
        switch scalar.value {
        case 0 : result.append(contentsOf: [UInt8]("\\0".utf8))
        case 7 : result.append(contentsOf: [UInt8]("\\a".utf8))
        case 8 : result.append(contentsOf: [UInt8]("\\b".utf8))
        case 9 : result.append(contentsOf: [UInt8]("\\t".utf8))
        case 10: result.append(contentsOf: [UInt8]("\\n".utf8))
        case 11: result.append(contentsOf: [UInt8]("\\v".utf8))
        case 12: result.append(contentsOf: [UInt8]("\\f".utf8))
        case 13: result.append(contentsOf: [UInt8]("\\r".utf8))
        case 34: result.append(contentsOf: [UInt8]("\\\"".utf8))
        case 39: result.append(contentsOf: [UInt8]("\\'".utf8))
        case 47: result.append(contentsOf: [UInt8]("\\/".utf8))
        case 92: result.append(contentsOf: [UInt8]("\\\\".utf8))
        case let n where n > 127:
            result.append(contentsOf: [UInt8]("\\u".utf8))
            result.append(contentsOf: [UInt8](String(format:"%04X", n).utf8))
        default:
            result.append(UInt8(scalar.value))
        }
    }
    result.append(0x22)
    return result
}

private func asJsonValue(_ value: Any?) -> [UInt8] {
    if let value = value {
        switch value {
        case let int as Int8: return [UInt8](String(int).utf8)
        case let int as UInt8: return [UInt8](String(int).utf8)
        case let int as Int16: return [UInt8](String(int).utf8)
        case let int as UInt16: return [UInt8](String(int).utf8)
        case let int as Int32: return [UInt8](String(int).utf8)
        case let int as UInt32: return [UInt8](String(int).utf8)
        case let int as Int64: return [UInt8](String(int).utf8)
        case let int as UInt64: return [UInt8](String(int).utf8)
        case let int as Int: return [UInt8](String(int).utf8)
        case let int as UInt: return [UInt8](String(int).utf8)
        case let int as Float: return [UInt8](String(int).utf8)
        case let int as Double: return [UInt8](String(int).utf8)
        case let bool as Bool: return bool ? [0x74, 0x72, 0x75, 0x65] : [0x66, 0x61, 0x6C, 0x73, 0x65]
        case let dict as Dictionary<String, Any>: return dict.toJson()
        case let dict as Dictionary<String, Any?>: return dict.toJson()
        case let array as Array<Any>: return array.toJson()
        case let array as Array<Any?>: return array.toJson()
        case let string as String: return escapeJSONString(string)
        default:
            return [0x6E, 0x75, 0x6C, 0x6C]
        }
    }
    return [0x6E, 0x75, 0x6C, 0x6C]
}
