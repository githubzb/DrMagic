//
//  DataTest.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/10.
//

import Foundation
import DrMagic

func dataTest() {
    
    let data = "abcedfg".data(using: .utf8)!
    let md5String = data.mg.md5String
    assert(md5String == "dde50653382d72db9168912af1f8c01e", "md5 fail")
    let sha1String = data.mg.sha1String
    assert(sha1String == "470e2dac6d8e0b17412cceb91442659a9d561e02", "sha1 fail")
    let sha256String = data.mg.sha256String
    assert(sha256String == "34541528206d252e76bb2597687112b53aff7f70dd1da1d763dab4c59095bf89", "sha256 fail")
    let sha384String = data.mg.sha384String
    assert(sha384String == "dcaa9ac74ca7251ee8c542fcc0af18841805900e29f2710da977d67e051f506efd253e5a77560a0971f7d72e334c25c7", "sha384 fail")
    let sha512String = data.mg.sha512String
    assert(sha512String == "10198395787e056f03c721e12087f83c117ea5d3bbec7430c1fec143c24f056830661d400df57a1c73191a43a9960bbdf3417a43b0245faa462e439d1e84be7b", "sha512 fail")
    
    let hmacMd5Str = data.mg.hmac(type: .md5, key: "1234567890")
    assert(hmacMd5Str == "c240e1562e4855a25e43e42382a2b1b0", "hmac_md5 fail")
    let hmacSha1Str = data.mg.hmac(type: .sha1, key: "1234567890")
    assert(hmacSha1Str == "c0247cb040f4f97012119e6a863e10b5ef73d431", "hmac_sha1 fail")
    let hmacSha256Str = data.mg.hmac(type: .sha256, key: "1234567890")
    assert(hmacSha256Str == "d88f9d7bf4b5ed7591a61a13d4c65a6b6517d3cb323dc1a319f18ba27ba0f418", "hmac_sha256 fail")
    let hmacSha384Str = data.mg.hmac(type: .sha384, key: "1234567890")
    assert(hmacSha384Str == "d517b76e6ddeeba9fe7dee4af1fd935d8c20374a13e3495e1a5822bb89662fbb1bcc6137ac1a915b1e3a221fdda5cfd0", "hmac_sha384 fail")
    let hmacSha512Str = data.mg.hmac(type: .sha512, key: "1234567890")
    assert(hmacSha512Str == "1b9d7e0b49d34ccf7eccfc9b60f24709e59ce4fc4f5b6ee4321f8885d309ca7f7e42f6b427ffee19ee23e717b4afff68c40ebb415260f568034f5f8592876939", "hmac_sha512 fail")
    
    let data2 = "12345".data(using: .utf8)!
    let data2Str = data2.mg.utf8String
    assert(data2Str == "12345", "utf8String fail")
    
}
