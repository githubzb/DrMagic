//
//  Data+ext.swift
//  DrMagic
//
//  Created by admin on 2022/5/10.
//

import Foundation
import CryptoKit

extension Data: MagicBoxExt {}

// MARK: - hash
extension MagicBox where T == Data {
    
    public var md5String: String {
        Insecure.MD5.hash(data: value).map{ String(format: "%02x", $0) }.joined()
    }
    public var md5: Self {
        guard let data = md5String.data(using: .utf8) else {
            return self
        }
        return MagicBox(data)
    }
    
    public var sha1String: String {
        Insecure.SHA1.hash(data: value).map({String(format: "%02x", $0)}).joined()
    }
    public var sha1: Self {
        guard let data = sha1String.data(using: .utf8) else {
            return self
        }
        return MagicBox(data)
    }
    
    public var sha256String: String {
        SHA256.hash(data: value).map({String(format: "%02x", $0)}).joined()
    }
    public var sha256: Self {
        guard let data = sha256String.data(using: .utf8) else {
            return self
        }
        return MagicBox(data)
    }
    
    public var sha384String: String {
        SHA384.hash(data: value).map({String(format: "%02x", $0)}).joined()
    }
    public var sha384: Self {
        guard let data = sha384String.data(using: .utf8) else {
            return self
        }
        return MagicBox(data)
    }
    
    public var sha512String: String {
        SHA512.hash(data: value).map({String(format: "%02x", $0)}).joined()
    }
    public var sha512: Self {
        guard let data = sha512String.data(using: .utf8) else {
            return self
        }
        return MagicBox(data)
    }
    
    public enum HMACType {
        case md5
        case sha1
        case sha256
        case sha384
        case sha512
    }
    
    public func hmac(type: HMACType, key: String) -> String? {
        guard let keyData = key.data(using: .utf8) else {
            return nil
        }
        let _key = SymmetricKey(data: keyData)
        switch type {
        case .md5:
            return HMAC<Insecure.MD5>.authenticationCode(for: value, using: _key)
                .map({String(format: "%02x", $0)}).joined()
            
        case .sha1:
            return HMAC<Insecure.SHA1>.authenticationCode(for: value, using: _key)
                .map({String(format: "%02x", $0)}).joined()
            
        case .sha256:
            return HMAC<SHA256>.authenticationCode(for: value, using: _key)
                .map({String(format: "%02x", $0)}).joined()
            
        case .sha384:
            return HMAC<SHA384>.authenticationCode(for: value, using: _key)
                .map({String(format: "%02x", $0)}).joined()
            
        case .sha512:
            return HMAC<SHA512>.authenticationCode(for: value, using: _key)
                .map({String(format: "%02x", $0)}).joined()
        }
    }
    
}

// MARK: - JSON??????
extension MagicBox where T == Data {
    
    /// ???json????????????????????????
    public func toJson<T>(_ type: T.Type) -> T? {
        guard let json = try? JSONSerialization.jsonObject(with: value, options: .fragmentsAllowed) else {
            return nil
        }
        return json as? T
    }
    
    /// ???json????????????????????????
    public var jsonMap: [String: Any]? { toJson([String: Any].self) }
    
    /// ???json????????????????????????
    public var jsonMapArray: [[String: Any]]? { jsonArray([String: Any].self) }
    
    /// ???json??????????????????????????????????????????????????????
    public func jsonArray<T>(_ elementType: T.Type) -> [T]? { toJson([T].self) }
    
}

// MARK: - tools
extension MagicBox where T == Data {
    
    public var utf8String: String { toString() }
    
    public func toString(encoding: String.Encoding = .utf8) -> String {
        String(data: value, encoding: encoding) ?? ""
    }
    
    /// 16???????????????????????????
    public var hexString: String { value.map({ String(format: "%02x", $0) }).joined() }
    /// 16???????????????????????????
    public var hexStringUpperCase: String { value.map({ String(format: "%02X", $0) }).joined() }
}
