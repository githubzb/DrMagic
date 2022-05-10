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
    
}
