//
//  ArrayTest.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/17.
//

import Foundation
import DrMagic

struct People {
    var name: String
    var age: Int
}

func arrayTest() {
    
    let strList = ["a", "b", "c"]
    let strListJson = strList.mg.jsonString
    assert(strListJson == "[\"a\",\"b\",\"c\"]", "jsonString fail")
    
    let mapList = [["name": "drbox"], ["name": "jack"]]
    let mapListStr = mapList.mg.jsonString
    assert(mapListStr == "[{\"name\":\"drbox\"},{\"name\":\"jack\"}]", "jsonString fail")
    
    let intList = [1, 2, 3]
    let intListStr = intList.mg.jsonString
    assert(intListStr == "[1,2,3]", "jsonString fail")
    
    // 下面的会导致crash
//    let list = [People(name: "drbox", age: 30),People(name: "jack", age: 35)]
//    let listStr = list.mg.jsonString
//    assert(listStr == nil, "不能将非序列化的对象转成json字符串")
}
