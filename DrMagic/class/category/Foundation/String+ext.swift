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
