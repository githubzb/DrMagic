//
//  Curve25519Test.swift
//  MagicTest
//
//  Created by admin on 2022/5/16.
//

import Foundation
import DrMagic


func curve25519Test() {
    
    let signKey = DrCurve25519.Signing.generateKey
    assert(signKey.privateKeyData.count > 0 && signKey.publicKeyData.count > 0, "生成签名秘钥对儿失败")
    
    let message = "这里是待签名的内容"
    // 签名成功测试
    do {
        let sign = try signKey.signature(message: message)
        assert(sign.count > 0, "签名不能为空")
        let res = try signKey.isValidSignature(signHex: sign, message: message)
        assert(res, "验证签名失败，此时不应该失败")
        
    }catch {
        assert(false, "签名操作失败: \(error)")
    }
    
    // 签名失败测试
    do {
        let sign = try signKey.signature(message: message)
        assert(sign.count > 0,  "签名不能为空")
        
        // 采用非对称的公钥验签，此时应该失败才对
        let signKey2 = DrCurve25519.Signing.generateKey
        let res = try signKey2.isValidSignature(signHex: sign, message: message)
        assert(!res, "验证签名此时应该失败才对")
    }catch {
        assert(false, "签名操作失败: \(error)")
    }
    
    
    // 模拟服务端与客户端通信
    // 这里是服务端秘钥
    let serverKey = DrCurve25519.Signing.generateKey
    // 这里是客户端秘钥
    let appKey = DrCurve25519.Signing.generateKey
    
    // 服务端签名操作（私钥：服务端的，用于生成签名；公钥：客户端的，用于验证客户端的签名）
    let serverSign = DrCurve25519.Signing.SignKey(privateKey: serverKey.privateKeyData, publicKey: appKey.publicKeyData)
    // 客户端签名操作（私钥：客户端的，用于生成签名；公钥：服务端的，用于验证服务端的签名）
    let appSign = DrCurve25519.Signing.SignKey(privateKey: appKey.privateKeyData, publicKey: serverKey.publicKeyData)
    
    do {
        // 服务端发送内容给客户端
        let serverMsg = "服务端发送内容"
        let serverSignStr = try serverSign.signature(message: serverMsg)
        assert(serverSignStr.count > 0 , "服务端生成签名失败")
        
        // 客户端接收数据，验证签名
        let isValid1 = try appSign.isValidSignature(signHex: serverSignStr, message: serverMsg)
        assert(isValid1, "客户端验证服务端的签名失败，此时应该通过才对")
        
        // 客户端向服务端发送内容
        let appMsg = "客户端发送内容"
        let appSignStr = try appSign.signature(message: appMsg)
        assert(appSignStr.count > 0, "客户端生成签名失败")
        
        // 服务端接收数据，验证签名
        let isValid2 = try serverSign.isValidSignature(signHex: appSignStr, message: appMsg)
        assert(isValid2, "服务端验证客户端的签名失败，此时应该通过才对")
        
    }catch {
        assert(false, "签名操作失败: \(error)")
    }
    
}
