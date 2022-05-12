//
//  ChaChaPolyTest.swift
//  MagicTest
//
//  Created by admin on 2022/5/12.
//

import Foundation
import DrMagic

func chachaPolyTest() {
    
    let message = "加密文本内容"
    let key = DrChaChaPoly.generateKeyHex
    let nonce = DrChaChaPoly.nonceHex
    let auth = "12345667890"
    do {
        let res = try DrChaChaPoly.encrypt(message: message, keyHex: key, nonceHex: nonce, authenticating: auth)
        let msg = try DrChaChaPoly.decrypt(sealedBox: res, keyHex: key, authenticating: auth)
        
        print("chachaPoly- \(res)")
        assert(message == msg, "ChaChaPoly fail")
    }catch {
        print("ChaChaPoly encrypt fail: \(error)")
        assert(false, "ChaChaPoly fail")
    }
    
    do {
        let res = try DrChaChaPoly.encrypt(message: message, keyHex: key, nonceHex: nonce)
        let msg = try DrChaChaPoly.decrypt(sealedBox: res, keyHex: key)
        
        print("chachaPoly- \(res)")
        assert(message == msg, "ChaChaPoly fail")
    }catch {
        print("ChaChaPoly encrypt fail: \(error)")
        assert(false, "ChaChaPoly fail")
    }
}
