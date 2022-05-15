//
//  DrAES.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/14.
//

import Foundation
import CryptoKit

public enum DrAES {
}

extension DrAES {
    
    /// AES in GCM mode with 128-bit tags.
    public enum GCM {
        
        /**
         加密
         
         - Parameter message: 待加密的明文字符串（会经过UTF8编码）
         - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
         - Parameter nonceHex: 随机串，参与加密（16进制字符串，24字节长度）
         - Parameter authenticating: 校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）
         
         - Returns 加密结果GCM.SealedBox
         */
        public static func encrypt(message: String, keyHex: String, nonceHex: String?, authenticating: String) throws -> GCM.SealedBox {
            guard let msgData = message.data(using: .utf8) else {
                throw MagicError.invalidParameter("message转UTF8 Data失败")
            }
            return try encrypt(message: msgData, keyHex: keyHex, nonceHex: nonceHex, authenticating: authenticating)
        }
        
        /**
         加密
         
         - Parameter message: 待加密的明文数据
         - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
         - Parameter nonceHex: 随机串，参与加密（16进制字符串，24字节长度）
         - Parameter authenticating: 校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）
         
         - Returns 加密结果GCM.SealedBox
         */
        public static func encrypt(message: Data, keyHex: String, nonceHex: String?, authenticating: String) throws -> GCM.SealedBox {
            guard let authData = authenticating.data(using: .utf8) else {
                throw MagicError.invalidParameter("authenticating转UTF8 Data失败")
            }
            let key = SymmetricKey(data: keyHex.mg.hexData)
            let nonce: AES.GCM.Nonce?
            if let nonceHex = nonceHex {
                nonce = try .init(data: nonceHex.mg.hexData)
            }else {
                nonce = nil
            }
            let box = try AES.GCM.seal(message, using: key, nonce: nonce, authenticating: authData)
            return .init(ciphertext: box.ciphertext, tag: box.tag, nonce: box.nonce.data)
        }
        
        /**
         加密
         
         - Parameter message: 待加密的明文字符串（会经过UTF8编码）
         - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
         - Parameter nonceHex: 随机串，参与加密（16进制字符串，24字节长度）
         
         - Returns 加密结果GCM.SealedBox
         */
        public static func encrypt(message: String, keyHex: String, nonceHex: String?) throws -> GCM.SealedBox {
            guard let msgData = message.data(using: .utf8) else {
                throw MagicError.invalidParameter("message转UTF8 Data失败")
            }
            return try encrypt(message: msgData, keyHex: keyHex, nonceHex: nonceHex)
        }
        
        /**
         加密
         
         - Parameter message: 待加密的明文数据
         - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
         - Parameter nonceHex: 随机串，参与加密（16进制字符串，24字节长度）
         
         - Returns 加密结果GCM.SealedBox
         */
        public static func encrypt(message: Data, keyHex: String, nonceHex: String?) throws -> GCM.SealedBox {
            let key = SymmetricKey(data: keyHex.mg.hexData)
            let nonce: AES.GCM.Nonce?
            if let nonceHex = nonceHex {
                nonce = try .init(data: nonceHex.mg.hexData)
            }else {
                nonce = nil
            }
            let box = try AES.GCM.seal(message, using: key, nonce: nonce)
            return .init(ciphertext: box.ciphertext, tag: box.tag, nonce: box.nonce.data)
        }
        
        /**
         解密
         
         - Parameter sealedBox: 加密结果
         - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
         - Parameter authenticating: 校验字符串
         
         - Returns 解密后的字符串
         */
        public static func decrypt(sealedBox: GCM.SealedBox, keyHex: String, authenticating: String) throws -> String {
            let data = try decryptData(sealedBox: sealedBox, keyHex: keyHex, authenticating: authenticating)
            return String(data: data, encoding: .utf8) ?? ""
        }
        
        /**
         解密
         
         - Parameter sealedBox: 加密结果
         - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
         - Parameter authenticating: 校验字符串
         
         - Returns 解密后的数据
         */
        public static func decryptData(sealedBox: GCM.SealedBox, keyHex: String, authenticating: String) throws -> Data {
            try sealedBox.decrypt(keyHex: keyHex, authenticating: authenticating)
        }
        
        /**
         解密
         
         - Parameter sealedBox: 加密结果
         - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
         
         - Returns 解密后的字符串
         */
        public static func decrypt(sealedBox: GCM.SealedBox, keyHex: String) throws -> String {
            let data = try decryptData(sealedBox: sealedBox, keyHex: keyHex)
            return String(data: data, encoding: .utf8) ?? ""
        }
        
        /**
         解密
         
         - Parameter sealedBox: 加密结果
         - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
         
         - Returns 解密后的数据
         */
        public static func decryptData(sealedBox: GCM.SealedBox, keyHex: String) throws -> Data {
            try sealedBox.decrypt(keyHex: keyHex)
        }
    }
}


extension DrAES.GCM.SealedBox {
    
    /**
     解密
     
     - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
     - Parameter authenticating: 校验字符串
     
     - Returns 解密后的数据
     */
    func decrypt(keyHex: String, authenticating: String) throws -> Data {
        guard let authData = authenticating.data(using: .utf8) else {
            throw MagicError.invalidParameter("authenticating转UTF8 Data失败")
        }
        let key = SymmetricKey(data: keyHex.mg.hexData)
        let nonce = try AES.GCM.Nonce(data: nonce)
        let box = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        return try AES.GCM.open(box, using: key, authenticating: authData)
    }
    
    /**
     解密
     
     - Parameter keyHex: 秘钥key（16进制字符串，16字节、24字节、32字节）
     
     - Returns 解密后的数据
     */
    func decrypt(keyHex: String) throws -> Data {
        let key = SymmetricKey(data: keyHex.mg.hexData)
        let nonce = try AES.GCM.Nonce(data: nonce)
        let box = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        return try AES.GCM.open(box, using: key)
    }
}


// MARK: - 秘钥Key
extension DrAES {
    
    /// 生成AES 加密 key（128bit）
    public static var generate128KeyData: Data {
        generateKeyData(size: .bits128)
    }
    /// 生成AES 加密 key（192bit）
    public static var generate192KeyData: Data {
        generateKeyData(size: .bits192)
    }
    /// 生成AES 加密 key（256bit）
    public static var generate256KeyData: Data {
        generateKeyData(size: .bits256)
    }
    
    /// 生成AES 加密  16进制key字符串（128bit）
    public static var generate128KeyHex: String {
        generate128KeyData.mg.hexString
    }
    /// 生成AES 加密  16进制key字符串（192bit）
    public static var generate192KeyHex: String {
        generate192KeyData.mg.hexString
    }
    /// 生成AES 加密  16进制key字符串（256bit）
    public static var generate256KeyHex: String {
        generate256KeyData.mg.hexString
    }
    
    /**
     根据IETF RFC 3394规范，密钥封装模块提供了AES密钥封装。
     
     - Parameter keyToWrap: 待封装的秘钥
     - Parameter byKey: 用于封装秘钥的秘钥
     - Returns 返回封装后的秘钥。
     */
    @available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
    public static func wrap(_ keyToWrap: Data, byKey: Data) throws -> Data {
        try AES.KeyWrap.wrap(SymmetricKey(data: keyToWrap), using: SymmetricKey(data: byKey))
    }
    /**
     根据IETF RFC 3394规范，密钥封装模块提供了AES密钥封装。
     
     - Parameter keyToWrapHex: 待封装的秘钥（16进制字符串）
     - Parameter byKeyHex: 用于封装秘钥的秘钥（16进制字符串）
     
     - Returns 返回封装后的秘钥。（16进制字符串）
     */
    @available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
    public static func wrap(_ keyToWrapHex: String, byKeyHex: String) throws -> String {
        try wrap(keyToWrapHex.mg.hexData, byKey: byKeyHex.mg.hexData).mg.hexString
    }
    
    /**
     根据IETF RFC 3394规范，密钥封装模块提供了AES密钥解封装。
     
     - Parameter wrappedKey: 封装后的秘钥
     - Parameter byKey: 用于解封秘钥的秘钥（需要与封装时的秘钥对称）
     
     - Returns 返回解封装后的秘钥。
     */
    @available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
    public static func unwrap(_ wrappedKey: Data, byKey: Data) throws -> Data {
        try AES.KeyWrap.unwrap(wrappedKey, using: SymmetricKey(data: byKey))
            .withUnsafeBytes({ bf -> Data in
                guard let base = bf.baseAddress else {
                    return Data()
                }
                return Data(bytes: base, count: bf.count)
            })
    }
    /**
     根据IETF RFC 3394规范，密钥封装模块提供了AES密钥解封装。
     
     - Parameter wrappedKeyHex: 封装后的秘钥（16进制字符串）
     - Parameter byKeyHex: 用于解封秘钥的秘钥（需要与封装时的秘钥对称，16进制字符串）
     
     - Returns 返回解封装后的秘钥。（16进制字符串）
     */
    @available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
    public static func unwrap(_ wrappedKeyHex: String, byKeyHex: String) throws -> String {
        try unwrap(wrappedKeyHex.mg.hexData, byKey: byKeyHex.mg.hexData).mg.hexString
    }
    
    /// 生成指定size的AES 加密 key
    private static func generateKeyData(size: SymmetricKeySize) -> Data {
        SymmetricKey(size: size).withUnsafeBytes { bf in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
}

// MARK: - GCM 随机串
extension DrAES.GCM {
    
    /// 生成AES.GCM加密随机串（16进制字符串）
    public static var nonceHex: String {
        AES.GCM.Nonce().withUnsafeBytes { bf -> Data in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }.mg.hexString
    }
}

fileprivate extension AES.GCM.Nonce {
    
    var data: Data {
        withUnsafeBytes { bf in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
}


// MARK: - 加密结果
extension DrAES.GCM {
    
    /// AES in GCM mode with 128-bit tags. 加密结果
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

extension DrAES.GCM.SealedBox: CustomStringConvertible {
    
    public var description: String { "tag: \(tagHexStr)\nciphertext: \(cipherTextHexStr)\nnonce: \(nonceHexStr)" }
}
