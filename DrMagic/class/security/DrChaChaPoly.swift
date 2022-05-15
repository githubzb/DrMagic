//
//  DrChaChaPoly.swift
//  DrMagic
//
//  Created by admin on 2022/5/12.
//

import Foundation
import CryptoKit

/// chacha poly1305 加解密（https://en.wikipedia.org/wiki/ChaCha20-Poly1305）
public enum DrChaChaPoly {
    
    /**
     加密
     
     - Parameter message: 待加密的明文字符串（会经过UTF8编码）
     - Parameter keyHex: 秘钥key（16进制字符串，64字节长度）
     - Parameter nonceHex: 随机串，参与加密（16进制字符串，24字节长度）
     - Parameter authenticating: 校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）
     
     - Returns  加密后的结果DrChaChaPoly.SealedBox
     */
    public static func encrypt(message: String, keyHex: String, nonceHex: String?, authenticating: String) throws -> DrChaChaPoly.SealedBox {
        guard let msgData = message.data(using: .utf8) else {
            throw MagicError.invalidParameter("message转UTF8 Data失败")
        }
        return try encrypt(message: msgData, keyHex: keyHex, nonceHex: nonceHex, authenticating: authenticating)
    }
    
    /**
     加密
     
     - Parameter message: 待加密的明文数据
     - Parameter keyHex: 秘钥key（16进制字符串，64字节长度）
     - Parameter nonceHex: 随机串，参与加密（16进制字符串，24字节长度）
     - Parameter authenticating: 校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）
     
     - Returns  加密后的结果DrChaChaPoly.SealedBox
     */
    public static func encrypt(message: Data, keyHex: String, nonceHex: String?, authenticating: String) throws -> DrChaChaPoly.SealedBox {
        guard let authData = authenticating.data(using: .utf8) else {
            throw MagicError.invalidParameter("authenticating转UTF8 Data失败")
        }
        let key = SymmetricKey(data: keyHex.mg.hexData)
        let nonce: ChaChaPoly.Nonce?
        if let nonceHex = nonceHex {
            nonce = try .init(data: nonceHex.mg.hexData)
        }else {
            nonce = nil
        }
        let box = try ChaChaPoly.seal(message, using: key, nonce: nonce, authenticating: authData)
        return .init(ciphertext: box.ciphertext, tag: box.tag, nonce: box.nonce.data)
    }
    
    /**
     加密
     
     - Parameter message: 待加密的明文字符串（会经过UTF8编码）
     - Parameter keyHex: 秘钥key（16进制字符串，64字节长度）
     - Parameter nonceHex: 随机串，参与加密（16进制字符串，24字节长度）
     
     - Returns  加密后的结果DrChaChaPoly.SealedBox
     */
    public static func encrypt(message: String, keyHex: String, nonceHex: String?) throws -> DrChaChaPoly.SealedBox {
        guard let msgData = message.data(using: .utf8) else {
            throw MagicError.invalidParameter("message转UTF8 Data失败")
        }
        return try encrypt(message: msgData, keyHex: keyHex, nonceHex: nonceHex)
    }
    
    /**
     加密
     
     - Parameter message: 待加密的明文数据
     - Parameter keyHex: 秘钥key（16进制字符串，64字节长度）
     - Parameter nonceHex: 随机串，参与加密（16进制字符串，24字节长度）
     
     - Returns  加密后的结果DrChaChaPoly.SealedBox
     */
    public static func encrypt(message: Data, keyHex: String, nonceHex: String?) throws -> DrChaChaPoly.SealedBox {
        let key = SymmetricKey(data: keyHex.mg.hexData)
        let nonce: ChaChaPoly.Nonce?
        if let nonceHex = nonceHex {
            nonce = try .init(data: nonceHex.mg.hexData)
        }else {
            nonce = nil
        }
        let box = try ChaChaPoly.seal(message, using: key, nonce: nonce)
        return .init(ciphertext: box.ciphertext, tag: box.tag, nonce: box.nonce.data)
    }
    
    /**
     解密
     
     - Parameter sealedBox: 加密结果
     - Parameter keyHex: 秘钥key（16进制字符串，64字节长度）
     - Parameter authenticating: 校验字符串
     
     - Returns 解密后的字符串
     */
    public static func decrypt(sealedBox: DrChaChaPoly.SealedBox, keyHex: String, authenticating: String) throws -> String {
        let data = try decryptData(sealedBox: sealedBox, keyHex: keyHex, authenticating: authenticating)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    /**
     解密
     
     - Parameter sealedBox: 加密结果
     - Parameter keyHex: 秘钥key（16进制字符串，64字节长度）
     - Parameter authenticating: 校验字符串
     
     - Returns 解密后的数据
     */
    public static func decryptData(sealedBox: DrChaChaPoly.SealedBox, keyHex: String, authenticating: String) throws -> Data {
        try sealedBox.decrypt(keyHex: keyHex, authenticating: authenticating)
    }
    
    /**
     解密
     
     - Parameter sealedBox: 加密结果
     - Parameter keyHex: 秘钥key（16进制字符串，64字节长度）
     
     - Returns 解密后的字符串
     */
    public static func decrypt(sealedBox: DrChaChaPoly.SealedBox, keyHex: String) throws -> String {
        let data = try decryptData(sealedBox: sealedBox, keyHex: keyHex)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    /**
     解密
     
     - Parameter sealedBox: 加密结果
     - Parameter keyHex: 秘钥key（16进制字符串，64字节长度）
     
     - Returns 解密后的数据
     */
    public static func decryptData(sealedBox: DrChaChaPoly.SealedBox, keyHex: String) throws -> Data {
        try sealedBox.decrypt(keyHex: keyHex)
    }
    
}

fileprivate extension DrChaChaPoly.SealedBox {
    
    /**
     解密
     
     - Parameter keyHex: 秘钥key（16进制字符串）
     - Parameter authenticating: 校验字符串
     
     - Returns 解密后的数据
     */
    func decrypt(keyHex: String, authenticating: String) throws -> Data {
        guard let authData = authenticating.data(using: .utf8) else {
            throw MagicError.invalidParameter("authenticating转UTF8 Data失败")
        }
        let key = SymmetricKey(data: keyHex.mg.hexData)
        let nonce = try ChaChaPoly.Nonce(data: nonce)
        let box = try ChaChaPoly.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        return try ChaChaPoly.open(box, using: key, authenticating: authData)
    }
    
    /**
     解密
     
     - Parameter keyHex: 秘钥key（16进制字符串）
     
     - Returns 解密后的数据
     */
    func decrypt(keyHex: String) throws -> Data {
        let key = SymmetricKey(data: keyHex.mg.hexData)
        let nonce = try ChaChaPoly.Nonce(data: nonce)
        let box = try ChaChaPoly.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        return try ChaChaPoly.open(box, using: key)
    }
}

fileprivate extension ChaChaPoly.Nonce {
    
    var data: Data {
        withUnsafeBytes { bf in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
}

extension DrChaChaPoly {
    
    /// 生成chacha poly1305 加密 key
    public static var generateKeyData: Data {
        SymmetricKey(size: .bits256).withUnsafeBytes { bf in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
    /// 生成chacha poly1305 加密 key（16进制字符串）
    public static var generateKeyHex: String { generateKeyData.mg.hexString }
    
    /// 生成随机串（16进制字符串）
    public static var nonceHex: String {
        ChaChaPoly.Nonce().withUnsafeBytes { bf -> Data in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }.mg.hexString
    }
}

extension DrChaChaPoly {
    
    /// chacha poly1305 加密结果
    @frozen public struct SealedBox {
        
        /// The combined representation ( nonce || ciphertext || tag)
        public var combined: Data { nonce + ciphertext + tag }
        public var combinedHexStr: String { combined.mg.hexString }

        /// The authentication tag
        public let tag: Data
        public var tagHexStr: String { tag.mg.hexString }

        /// The ciphertext
        public let ciphertext: Data
        public var cipherTextHexStr: String { ciphertext.mg.hexString }

        /// The Nonce
        public let nonce: Data
        public var nonceHexStr: String { nonce.mg.hexString }
        
        /**
         初始化SealedBox
         
         - Parameter cipherTextHex: 密文16进制字符串
         - Parameter tagHex: tag 16进制字符串
         - Parameter nonceHex: nonce 16进制字符串，24字节长度
         
         - Returns SealedBox
         */
        public init(cipherTextHex: String, tagHex: String, nonceHex: String) {
            self.ciphertext = cipherTextHex.mg.hexData
            self.tag = tagHex.mg.hexData
            self.nonce = nonceHex.mg.hexData
        }
        
        /**
         初始化SealedBox
         
         - Parameter ciphertext: 密文数据
         - Parameter tag: tag数据
         - Parameter nonce: nonce数据，12字节长度
         
         - Returns SealedBox
         */
        public init(ciphertext: Data, tag: Data, nonce: Data) {
            self.ciphertext = ciphertext
            self.tag = tag
            self.nonce = nonce
        }
    }
}


extension DrChaChaPoly.SealedBox: CustomStringConvertible {
    
    public var description: String { "tag: \(tagHexStr)\nciphertext: \(cipherTextHexStr)\nnonce: \(nonceHexStr)" }
}
