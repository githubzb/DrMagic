//
//  DrCurve25519.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/15.
//

import Foundation
import CryptoKit

public enum DrCurve25519 {
}


// MARK: - 签名操作
extension DrCurve25519 {
    
    /// Curve25519 签名操作
    public enum Signing {
        
        /// 生成签名秘钥对儿（私钥用于本地生成签名，公钥发给第三方，用于验证签名）
        public static var generateKey: SignKey {
            let privateKey = Curve25519.Signing.PrivateKey()
            let publicKey = privateKey.publicKey
            return .init(privateKey: privateKey.rawRepresentation, publicKey: publicKey.rawRepresentation)
        }
        
        /// 用于签名和验签的秘钥对儿
        @frozen public struct SignKey {
            
            /// 私钥（用于生成签名）
            public let privateKeyData: Data
            /// 私钥（用于生成签名，16进制字符串）
            public var privateKeyHex: String { privateKeyData.mg.hexString }
            /// 公钥（用于验证签名）
            public let publicKeyData: Data
            /// 公钥（用于验证签名，16进制字符串）
            public var publicKeyHex: String { publicKeyData.mg.hexString }
            
            /**
             初始化
             
             - Parameter privateKeyHex: 私钥
             - Parameter publicKeyHex: 公钥
             
             - Returns Keys（公钥私钥对儿）
             */
            public init(privateKey: Data, publicKey: Data) {
                self.privateKeyData = privateKey
                self.publicKeyData = publicKey
            }
            /**
             初始化
             
             - Parameter privateKeyHex: 私钥（16进制字符串）
             - Parameter publicKeyHex: 公钥（16进制字符串）
             
             - Returns Keys（公钥私钥对儿）
             */
            public init(privateKeyHex: String, publicKeyHex: String) {
                self.privateKeyData = privateKeyHex.mg.hexData
                self.publicKeyData = publicKeyHex.mg.hexData
            }
        }
    }
}

extension DrCurve25519.Signing.SignKey {
    
    /**
     生成签名
     
     - Parameter message: 待生成签名的内容数据
     
     - Returns 签名字符串（16进制字符串）
     */
    public func signature(message: Data) throws -> String {
        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
        return try privateKey.signature(for: message).mg.hexString
    }
    
    /**
     生成签名
     
     - Parameter message: 待生成签名的内容字符串（会经过UTF8编码）
     
     - Returns 签名字符串（16进制字符串）
     */
    public func signature(message: String) throws -> String {
        guard let msgData = message.data(using: .utf8) else {
            throw MagicError.invalidParameter("message 转 Data失败")
        }
        return try signature(message: msgData)
    }
    
    /**
     验证签名
     
     - Parameter signHex: 签名字符串（16进制字符串）
     - Parameter message: 签名对应的内容数据
     
     - Returns true: 签名验证通过
     */
    public func isValidSignature(signHex: String, message: Data) throws -> Bool {
        let publicKey = try Curve25519.Signing.PublicKey(rawRepresentation: publicKeyData)
        return publicKey.isValidSignature(signHex.mg.hexData, for: message)
    }
    
    /**
     验证签名
     
     - Parameter signHex: 签名字符串（16进制字符串）
     - Parameter message: 签名对应的内容字符串（会经过UTF8编码）
     
     - Returns true: 签名验证通过
     */
    public func isValidSignature(signHex: String, message: String) throws -> Bool {
        guard let msgData = message.data(using: .utf8) else {
            throw MagicError.invalidParameter("message 转 Data失败")
        }
        return try isValidSignature(signHex: signHex, message: msgData)
    }
}


// MARK: - 共享秘钥操作
extension DrCurve25519 {
    
    /// 生成共享秘钥协议（私钥客户端保存，公钥提供给第三方）
    public static var generateKeyAgreement: DrCurve25519.KeyAgreement {
        let privateKey = Curve25519.KeyAgreement.PrivateKey()
        return.init(privateKey: privateKey.rawRepresentation, publicKey: privateKey.publicKey.rawRepresentation)
    }
    
    /// 共享秘钥协议，用于生成共享秘钥
    @frozen public struct KeyAgreement {
        
        /// 私钥（用于生成签名）
        public let privateKeyData: Data
        /// 私钥（用于生成签名，16进制字符串）
        public var privateKeyHex: String { privateKeyData.mg.hexString }
        /// 公钥（用于验证签名）
        public let publicKeyData: Data
        public var publicKeyHex: String { publicKeyData.mg.hexString }
        
        /**
         初始化
         
         - Parameter privateKeyHex: 私钥
         - Parameter publicKeyHex: 公钥
         
         - Returns Keys（公钥私钥对儿）
         */
        public init(privateKey: Data, publicKey: Data) {
            self.privateKeyData = privateKey
            self.publicKeyData = publicKey
        }
        /**
         初始化
         
         - Parameter privateKeyHex: 私钥（16进制字符串）
         - Parameter publicKeyHex: 公钥（16进制字符串）
         
         - Returns Keys（公钥私钥对儿）
         */
        public init(privateKeyHex: String, publicKeyHex: String) {
            self.privateKeyData = privateKeyHex.mg.hexData
            self.publicKeyData = publicKeyHex.mg.hexData
        }
    }
}

// 未处理的共享秘钥与HKDF推导的共享秘钥
extension DrCurve25519.KeyAgreement {
    
    /// 获取共享秘钥
    public func shareKey() throws -> Data {
        try shareSecretKey().withUnsafeBytes({ bf -> Data in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        })
    }
    /// 获取共享秘钥（16进制字符串）
    public func shareKeyHex() throws -> String {
        try shareKey().mg.hexString
    }
    
    /**
     使用HKDF密钥推导算法生成对称加密共享密钥
     
     - Parameter hashFunc: 用于生成秘钥的hash函数算法
     - Parameter salt: 用于生成秘钥的盐（https://zh.m.wikipedia.org/zh-hans/%E7%9B%90_(%E5%AF%86%E7%A0%81%E5%AD%A6)）
     - Parameter shareInfo: 用于生成秘钥的shareInfo
     - Parameter byteCount: 生成秘钥的字节长度
     
     - Returns  HKDF算法推导出的共享秘钥
     */
    public func shareHKDFKey(hashFunc: DrCurve25519.KeyAgreement.HashFunc, salt: Data, shareInfo: Data, byteCount: Int) throws -> Data {
        let shareKey: SymmetricKey
        switch hashFunc {
        case .md5:
            shareKey = try shareSecretKey().hkdfDerivedSymmetricKey(using: Insecure.MD5.self,
                                                                    salt: salt,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
            
        case .sha1:
            shareKey = try shareSecretKey().hkdfDerivedSymmetricKey(using: Insecure.SHA1.self,
                                                                    salt: salt,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
            
        case .sha256:
            shareKey = try shareSecretKey().hkdfDerivedSymmetricKey(using: SHA256.self,
                                                                    salt: salt,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
            
        case .sha384:
            shareKey = try shareSecretKey().hkdfDerivedSymmetricKey(using: SHA384.self,
                                                                    salt: salt,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
            
        case .sha512:
            shareKey = try shareSecretKey().hkdfDerivedSymmetricKey(using: SHA512.self,
                                                                    salt: salt,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
        }
        return shareKey.withUnsafeBytes { bf -> Data in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
    
    /**
     使用HKDF密钥推导算法生成对称加密共享密钥
     
     - Parameter hashFunc: 用于生成秘钥的hash函数算法
     - Parameter salt: 用于生成秘钥的盐（https://zh.m.wikipedia.org/zh-hans/%E7%9B%90_(%E5%AF%86%E7%A0%81%E5%AD%A6)）
     - Parameter shareInfo: 用于生成秘钥的shareInfo
     - Parameter byteCount: 生成秘钥的字节长度
     
     - Returns  HKDF算法推导出的共享秘钥（16进制字符串）
     */
    public func shareHKDFKeyHex(hashFunc: DrCurve25519.KeyAgreement.HashFunc, salt: Data, shareInfo: Data, byteCount: Int) throws -> String {
        try shareHKDFKey(hashFunc: hashFunc, salt: salt, shareInfo: shareInfo, byteCount: byteCount).mg.hexString
    }
    
    /**
     使用HKDF密钥推导算法生成对称加密共享密钥
     
     - Parameter hashFunc: 用于生成秘钥的hash函数算法
     - Parameter salt: 用于生成秘钥的盐字符串（https://zh.m.wikipedia.org/zh-hans/%E7%9B%90_(%E5%AF%86%E7%A0%81%E5%AD%A6)）
     - Parameter shareInfo: 用于生成秘钥的shareInfo字符串
     - Parameter byteCount: 生成秘钥的字节长度
     
     - Returns  HKDF算法推导出的共享秘钥
     */
    public func shareHKDFKey(hashFunc: DrCurve25519.KeyAgreement.HashFunc, salt: String, shareInfo: String, byteCount: Int) throws -> Data {
        guard let saltData = salt.data(using: .utf8) else {
            throw MagicError.invalidParameter("salt转Data失败")
        }
        guard let shareInfoData = shareInfo.data(using: .utf8) else {
            throw MagicError.invalidParameter("shareInfo转Data失败")
        }
        return try shareHKDFKey(hashFunc: hashFunc, salt: saltData, shareInfo: shareInfoData, byteCount: byteCount)
    }
    
    /**
     使用HKDF密钥推导算法生成对称加密共享密钥
     
     - Parameter hashFunc: 用于生成秘钥的hash函数算法
     - Parameter salt: 用于生成秘钥的盐字符串（https://zh.m.wikipedia.org/zh-hans/%E7%9B%90_(%E5%AF%86%E7%A0%81%E5%AD%A6)）
     - Parameter shareInfo: 用于生成秘钥的shareInfo字符串
     - Parameter byteCount: 生成秘钥的字节长度
     
     - Returns  HKDF算法推导出的共享秘钥（16进制字符串）
     */
    public func shareHKDFKeyHex(hashFunc: DrCurve25519.KeyAgreement.HashFunc, salt: String, shareInfo: String, byteCount: Int) throws -> String {
        try shareHKDFKey(hashFunc: hashFunc, salt: salt, shareInfo: shareInfo, byteCount: byteCount).mg.hexString
    }
    
    
    
    private func shareSecretKey() throws -> SharedSecret {
        let privateKey = try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: privateKeyData)
        let publicKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: publicKeyData)
        return try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
    }
    
    
    /// HKDF秘钥派生所需的hash函数
    public enum HashFunc {
        case md5
        case sha1
        case sha256
        case sha384
        case sha512
    }
}


// X9.63算法推导的共享秘钥
extension DrCurve25519.KeyAgreement {
    
    /**
     使用X9.63算法生成对称加密共享密钥
     
     - Parameter hashFunc: 用于生成秘钥的hash函数算法
     - Parameter shareInfo: 用于生成秘钥的shareInfo字符串
     - Parameter byteCount: 生成秘钥的字节长度
     
     - Returns X9.63算法推导出的共享秘钥（16进制字符串）
     */
    public func shareX963KeyHex(hashFunc: DrCurve25519.KeyAgreement.HashFunc, shareInfo: String, byteCount: Int) throws -> String {
        try shareX963Key(hashFunc: hashFunc, shareInfo: shareInfo, byteCount: byteCount).mg.hexString
    }
    
    /**
     使用X9.63算法生成对称加密共享密钥
     
     - Parameter hashFunc: 用于生成秘钥的hash函数算法
     - Parameter shareInfo: 用于生成秘钥的shareInfo
     - Parameter byteCount: 生成秘钥的字节长度
     
     - Returns X9.63算法推导出的共享秘钥（16进制字符串）
     */
    public func shareX963KeyHex(hashFunc: DrCurve25519.KeyAgreement.HashFunc, shareInfo: Data, byteCount: Int) throws -> String {
        try shareX963Key(hashFunc: hashFunc, shareInfo: shareInfo, byteCount: byteCount).mg.hexString
    }
    
    /**
     使用X9.63算法生成对称加密共享密钥
     
     - Parameter hashFunc: 用于生成秘钥的hash函数算法
     - Parameter shareInfo: 用于生成秘钥的shareInfo字符串
     - Parameter byteCount: 生成秘钥的字节长度
     
     - Returns X9.63算法推导出的共享秘钥
     */
    public func shareX963Key(hashFunc: DrCurve25519.KeyAgreement.HashFunc, shareInfo: String, byteCount: Int) throws -> Data {
        guard let shareInfoData = shareInfo.data(using: .utf8) else {
            throw MagicError.invalidParameter("shareInfo转Data失败")
        }
        return try shareX963Key(hashFunc: hashFunc, shareInfo: shareInfoData, byteCount: byteCount)
    }
    
    /**
     使用X9.63算法生成对称加密共享密钥
     
     - Parameter hashFunc: 用于生成秘钥的hash函数算法
     - Parameter shareInfo: 用于生成秘钥的shareInfo
     - Parameter byteCount: 生成秘钥的字节长度
     
     - Returns X9.63算法推导出的共享秘钥
     */
    public func shareX963Key(hashFunc: DrCurve25519.KeyAgreement.HashFunc, shareInfo: Data, byteCount: Int) throws -> Data {
        let shareKey: SymmetricKey
        switch hashFunc {
        case .md5:
            shareKey = try shareSecretKey().x963DerivedSymmetricKey(using: Insecure.MD5.self,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
            
        case .sha1:
            shareKey = try shareSecretKey().x963DerivedSymmetricKey(using: Insecure.SHA1.self,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
            
        case .sha256:
            shareKey = try shareSecretKey().x963DerivedSymmetricKey(using: SHA256.self,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
            
        case .sha384:
            shareKey = try shareSecretKey().x963DerivedSymmetricKey(using: SHA384.self,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
            
        case .sha512:
            shareKey = try shareSecretKey().x963DerivedSymmetricKey(using: SHA512.self,
                                                                    sharedInfo: shareInfo,
                                                                    outputByteCount: byteCount)
        }
        return shareKey.withUnsafeBytes { bf -> Data in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
}
