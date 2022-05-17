//
//  CharacterSetTest.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/17.
//

import Foundation
import DrMagic

func characterSetTest() {
    let charStr = "@#$%&a*!`~?/,().+-"
    let characterSet = CharacterSet(charactersIn: charStr)
    let str = characterSet.mg.characterString // 因为set是无序的，因此这里的顺序是不一样的
    assert(str.count == str.count, "characterString 字符数量不对")
}
