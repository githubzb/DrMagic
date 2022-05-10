//
//  Data+ext.swift
//  DrMagic
//
//  Created by admin on 2022/5/10.
//

import Foundation
import CryptoKit

extension Data: MagicBoxExt {}

// MARK: - encode and decode
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
    
    public func isValid(hmac: String, hmacType: HMACType , key: String) -> Bool {
        guard let hmacData = hmac.data(using: .utf8), let keyData = key.data(using: .utf8) else {
            return false
        }
        let _key = SymmetricKey(data: keyData)
        switch hmacType {
        case .md5:
            let _hmac = HashedAuthenticationCode<Insecure.MD5>(bytes)
            return HMAC<Insecure.MD5>.isValidAuthenticationCode(hmacData, authenticating: value, using: _key)
        case .sha1:
            <#code#>
        case .sha256:
            <#code#>
        case .sha384:
            <#code#>
        case .sha512:
            <#code#>
        }
    }
    
}


// MARK: - tools
extension MagicBox where T == Data {
    
    public var utf8String: String { toString() }
    
    public func toString(encoding: String.Encoding = .utf8) -> String {
        String(data: value, encoding: encoding) ?? ""
    }
}
