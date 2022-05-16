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

extension DrCurve25519 {
    /// 公钥和私钥
    public struct Keys {
        
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
