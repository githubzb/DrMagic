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
    
    
    // 测试共享秘钥（共享秘钥需要通过秘钥协议来生成）
    
    // 服务导出的秘钥协议
    let serverKeyAgreement = DrCurve25519.generateKeyAgreement
    // 客户端导出的秘钥协议
    let appKeyAgreement = DrCurve25519.generateKeyAgreement
    
    // 服务端将秘钥协议中的公钥发送给客户端，客户端生成共享秘钥协议
    let appShareKeyAgreement = DrCurve25519.KeyAgreement(privateKey: appKeyAgreement.privateKeyData, publicKey: serverKeyAgreement.publicKeyData)
    
    // 客户端将秘钥协议中的公钥发送给服务端，服务端生成共享秘钥协议
    let serverShareKeyAgreement = DrCurve25519.KeyAgreement(privateKey: serverKeyAgreement.privateKeyData, publicKey: appKeyAgreement.publicKeyData)
    
    do {
        // 生成客户端的共享秘钥
        let appKey = try appShareKeyAgreement.shareKeyHex()
        // 生成服务端的共享秘钥
        let serverKey = try serverShareKeyAgreement.shareKeyHex()
        
        assert(appKey.count > 0 &&  appKey == serverKey, "两个秘钥不一样")
    }catch {
        assert(false, "共享秘钥出错：\(error)")
    }
    
    
    // 测试生成HKDF推导的秘钥
    do {
        let salt = "abcdfdfewrefdf" // 可以用一个随机字符串
        let shareInfo = "12121zbdfvdv"
        let byteCount = 16
        
        // 生成客户端HKDF共享秘钥
        let appKey = try appShareKeyAgreement.shareHKDFKeyHex(hashFunc: .sha256,
                                                              salt: salt,
                                                              shareInfo: shareInfo,
                                                              byteCount: byteCount)
        
        // 生成服务端HKDF共享秘钥
        let serverKey = try serverShareKeyAgreement.shareHKDFKeyHex(hashFunc: .sha256,
                                                                    salt: salt,
                                                                    shareInfo: shareInfo,
                                                                    byteCount: byteCount)
        assert(appKey.count == byteCount * 2 && appKey == serverKey, "导出共享秘钥有误")
    }catch {
        assert(false, "共享秘钥出错：\(error)")
    }
    
    // 测试生成X9.63
    do {
        let shareInfo = "12121zbdfvdv"
        let byteCount = 16
        
        // 生成客户端X9.63共享秘钥
        let appKey = try appShareKeyAgreement.shareX963KeyHex(hashFunc: .sha256, shareInfo: shareInfo, byteCount: byteCount)
        // 生成服务端X9.63共享秘钥
        let serverKey = try serverShareKeyAgreement.shareX963KeyHex(hashFunc: .sha256, shareInfo: shareInfo, byteCount: byteCount)
        
        assert(appKey.count == byteCount * 2 && appKey == serverKey, "导出共享秘钥有误")
    }catch {
        assert(false, "共享秘钥出错：\(error)")
    }
}
