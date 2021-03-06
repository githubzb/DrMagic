//
//  String+ext.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/9.
//

import Foundation

extension String: MagicBoxExt {}

// MARK: - encode and decode
extension MagicBox where T == String {
    
    public var base64Encoding: Self { base64Encoding() }
    
    public func base64Encoding(options: Data.Base64EncodingOptions = []) -> Self {
        guard let data = value.data(using: .utf8) else {
            return self
        }
        return MagicBox(data.base64EncodedString(options: options))
    }
    
    public var base64Decoding: Self { base64Decoding() }
    
    public func base64Decoding(options: Data.Base64DecodingOptions = []) -> Self {
        guard let data = Data(base64Encoded: value), let str = String(data: data, encoding: .utf8) else {
            return self
        }
        return MagicBox(str)
    }
    
    public var urlEncoding: Self {
        var allowedCharactersWithSpace = Self.afURLQueryAllowed
        allowedCharactersWithSpace.insert(charactersIn: " ")
        let str = value.addingPercentEncoding(withAllowedCharacters: allowedCharactersWithSpace) ?? value
        return MagicBox(str)
    }
    
    public var urlQueryEncoding: Self {
        let str = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
        return MagicBox(str)
    }
    
    public func percentEncoding(withAllowedCharacters charset: CharacterSet) -> Self {
        let str = value.addingPercentEncoding(withAllowedCharacters: charset) ?? value
        return MagicBox(str)
    }
    
    public var urlDecoding: Self {
        let str = value.removingPercentEncoding ?? value
        return MagicBox(str)
    }
    
    fileprivate static let afURLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
    
}

// MARK: - hash
extension MagicBox where T == String {
    
    public var md5: Self {
        guard let data = value.data(using: .utf8) else {
            return self
        }
        return MagicBox(data.mg.md5String)
    }
    
    public var sha1: Self {
        guard let data = value.data(using: .utf8) else {
            return self
        }
        return MagicBox(data.mg.sha1String)
    }
    
    public var sha256: Self {
        guard let data = value.data(using: .utf8) else {
            return self
        }
        return MagicBox(data.mg.sha256String)
    }
    
    public var sha384: Self {
        guard let data = value.data(using: .utf8) else {
            return self
        }
        return MagicBox(data.mg.sha384String)
    }
    
    public var sha512: Self {
        guard let data = value.data(using: .utf8) else {
            return self
        }
        return MagicBox(data.mg.sha512String)
    }
    
    public func hmac(type: MagicBox<Data>.HMACType, key: String) -> Self {
        guard let data = value.data(using: .utf8),
              let hmac = data.mg.hmac(type: type, key: key) else {
            return self
        }
        return MagicBox(hmac)
    }
}

// MARK: - JSON??????
extension MagicBox where T == String {
    
    /// ???json?????????????????????
    public var jsonMap: [String: Any]? { toJson([String: Any].self) }
    
    /// json????????????
    public var jsonMapArray: [[String: Any]]? { jsonArray([String: Any].self) }
    
    /// json???????????????????????????????????????
    public func jsonArray<T>(_ elementType: T.Type) -> [T]? { toJson([T].self) }
    
    /// json???????????????????????????
    public func toJson<T>(_ type: T.Type) -> T? { Data(value.utf8).mg.toJson(type) }
}


// MARK: - tools
extension MagicBox where T == String {
    
    /// 16??????Data
    public var hexData: Data {
        let bytes = sequence(state: value.startIndex) { startIndex -> UInt8? in
            guard startIndex < value.endIndex else {
                return nil
            }
            // ???????????????????????????UInt8
            let endIndex = value.index(startIndex, offsetBy: 2, limitedBy: value.endIndex) ?? value.endIndex
            defer {
                startIndex = endIndex
            }
            return UInt8(value[startIndex..<endIndex], radix: 16)
        }
        return Data(bytes)
    }
    
    /// ???????????????????????????
    public var trim: Self { MagicBox(value.trimmingCharacters(in: .whitespacesAndNewlines)) }
    /// ???????????????????????????
    public func trim(_ str: String) -> Self {
        MagicBox(value.trimmingCharacters(in: .init(charactersIn: str)))
    }
    
    /// ????????????????????????
    public func subString(range: NSRange) -> MagicBox? {
            guard 0 <= range.location && range.location < value.count,
                        range.location + range.length < value.count else {
                                return nil
                        }
            let begin = value.index(value.startIndex, offsetBy: range.location)
            let end = value.index(begin, offsetBy: range.length)
            return MagicBox(String(value[begin..<end]))
    }
    
    
}

// MARK: - ?????????html
extension MagicBox where T == String {
    
    /// ??????html?????????????????????????????????
    public var parseHTML: NSAttributedString? {
        guard let data = value.data(using: .utf8) else { return nil }
        if let attr = try? NSMutableAttributedString(data: data,
                                                     options: [
                                                        .documentType: NSAttributedString.DocumentType.html,
                                                        .characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                                                     ],
                                                     documentAttributes: nil) {
            return NSAttributedString(attributedString: attr)
        }
        return nil
    }
}
