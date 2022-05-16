//
//  AESTest.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/15.
//

import Foundation
import DrMagic
import CryptoKit

func aesTest() {
    
    let key128 = DrAES.generate128KeyData
    assert(key128.count == 16, "generate128Key fail")
    let key192 = DrAES.generate192KeyData
    assert(key192.count == 24, "generate192Key fail")
    let key256 = DrAES.generate256KeyData
    assert(key256.count == 32, "generate256Key fail")
    
    // 封装加密key，用于封装的key采用128位
    if #available(iOS 15.0, *) {
        do {
            let keyToWrap = DrAES.generate128KeyHex
            let key = DrAES.generate128KeyHex
            
            let wrappedKey = try DrAES.wrap(keyToWrap, byKeyHex: key)
            assert(keyToWrap.count > 0 && wrappedKey.count > 0 && keyToWrap != wrappedKey, "key wrap fail")
            let unwrapKey = try DrAES.unwrap(wrappedKey, byKeyHex: key)
            assert(unwrapKey == keyToWrap, "key unwrap fail")
        } catch {
            assert(false, "aes key wrap fail.\(error)")
        }
    }
    
    // 封装加密key，用于封装的key采用256位
    if #available(iOS 15.0, *) {
        do {
            let keyToWrap = DrAES.generate128KeyHex
            let key = DrAES.generate256KeyHex
            let wrappedKey = try DrAES.wrap(keyToWrap, byKeyHex: key)
            assert(keyToWrap.count > 0 && wrappedKey.count > 0 && keyToWrap != wrappedKey, "key wrap fail")
            let unwrapKey = try DrAES.unwrap(wrappedKey, byKeyHex: key)
            assert(unwrapKey == keyToWrap, "key unwrap fail")
        } catch {
            assert(false, "aes key wrap fail.\(error)")
        }
    }
    
    
    // 测试加解密
    let text = "待加密的明文字符串"
    
    // 带验证的加解密
    do {
        let key = DrAES.generate256KeyHex
        let nonce = DrAES.GCM.nonceHex
        let authStr = "12345sadvdvd"
        let box = try DrAES.GCM.encrypt(message: text, keyHex: key, nonceHex: nonce, authenticating: authStr)
        assert(nonce == box.nonceHexStr, "加密结果nonce与加密参数nonce应该是相等的")
        
        let decryptBox = DrAES.GCM.SealedBox(cipherTextHex: box.cipherTextHexStr, tagHex: box.tagHexStr, nonceHex: box.nonceHexStr)
        let message = try DrAES.GCM.decrypt(sealedBox: decryptBox, keyHex: key, authenticating: authStr)
        assert(message == text, "aes 解密失败")
    } catch {
        assert(false, "aes fail，\(error)")
    }
    
    // 验证失败
    do {
        let key = DrAES.generate256KeyHex
        let nonce = DrAES.GCM.nonceHex
        let authStr = "12345sadvdvd"
        let box = try DrAES.GCM.encrypt(message: text, keyHex: key, nonceHex: nonce, authenticating: authStr)
        assert(nonce == box.nonceHexStr, "加密结果nonce与加密参数nonce应该是相等的")
        
        let failAuthStr = "aaabbbddd"
        let decryptBox = DrAES.GCM.SealedBox(cipherTextHex: box.cipherTextHexStr, tagHex: box.tagHexStr, nonceHex: box.nonceHexStr)
        _ = try DrAES.GCM.decrypt(sealedBox: decryptBox, keyHex: key, authenticating: failAuthStr)
        
        assert(false, "解密验证应该不会通过，应该抛出异常。")
    } catch CryptoKitError.authenticationFailure {
        print("AES auth验证失败")
    } catch {
        assert(false, "aes fail，\(error)")
    }
    
    // 不带验证的加解密
    do {
        let key = DrAES.generate256KeyHex
        let nonce = DrAES.GCM.nonceHex
        let box = try DrAES.GCM.encrypt(message: text, keyHex: key, nonceHex: nonce)
        assert(nonce == box.nonceHexStr, "加密结果nonce与加密参数nonce应该是相等的")
        
        let decryptBox = DrAES.GCM.SealedBox(cipherTextHex: box.cipherTextHexStr, tagHex: box.tagHexStr, nonceHex: box.nonceHexStr)
        let message = try DrAES.GCM.decrypt(sealedBox: decryptBox, keyHex: key)
        assert(message == text, "aes 解密失败")
    } catch {
        assert(false, "aes fail，\(error)")
    }
}
