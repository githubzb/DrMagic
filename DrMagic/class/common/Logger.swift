//
//  Logger.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/25.
//

import Foundation

/// log日志输出
public func drLog<T>(_ msg: @autoclosure ()->T, file: String = #file, line: UInt = #line) {
    #if DEBUG
    let filePath: String
    if let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
       let path = file.components(separatedBy: name).last{
        filePath = path
    }else {
        filePath = file
    }
    print("[Dr.log]: ",
          "\(filePath)->",
          "[line:\(line)]->: ",
          msg(),
          separator: "",
          terminator: "\n")
    #endif
}
