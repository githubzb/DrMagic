//
//  StringTest.swift
//  MagicTest
//
//  Created by admin on 2022/5/10.
//

import Foundation
import DrMagic

func stringTest() {
    
    let str = "base64加解密"
    let base64EncodingStr = str.mg.base64Encoding.value
    let base64DecodingStr = base64EncodingStr.mg.base64Decoding.value
    assert(base64EncodingStr.count > 0 && str == base64DecodingStr, "base64加解密失败")
    
    let urlStr = "https://www.baidu.com?keyword=URL编码"
    guard let _ = URL(string: urlStr.mg.urlQueryEncoding.value) else {
        assert(false, "urlQueryEncoding fail")
    }
    let urlEncodingStr = urlStr.mg.urlEncoding.value
    let urlDecodingStr = urlEncodingStr.mg.urlDecoding.value
    assert(urlEncodingStr != urlStr && urlStr == urlDecodingStr, "url编解码失败")
    
    let text = "abcedfg"
    let md5String = text.mg.md5.value
    assert(md5String == "dde50653382d72db9168912af1f8c01e", "md5 fail")
    let sha1String = text.mg.sha1.value
    assert(sha1String == "470e2dac6d8e0b17412cceb91442659a9d561e02", "sha1 fail")
    let sha256String = text.mg.sha256.value
    assert(sha256String == "34541528206d252e76bb2597687112b53aff7f70dd1da1d763dab4c59095bf89", "sha256 fail")
    let sha384String = text.mg.sha384.value
    assert(sha384String == "dcaa9ac74ca7251ee8c542fcc0af18841805900e29f2710da977d67e051f506efd253e5a77560a0971f7d72e334c25c7", "sha384 fail")
    let sha512String = text.mg.sha512.value
    assert(sha512String == "10198395787e056f03c721e12087f83c117ea5d3bbec7430c1fec143c24f056830661d400df57a1c73191a43a9960bbdf3417a43b0245faa462e439d1e84be7b", "sha512 fail")
}
