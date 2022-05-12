//
//  Error.swift
//  DrMagic
//
//  Created by admin on 2022/5/12.
//

import Foundation

public enum MagicError: Error {
    
    // 无效参数
    case invalidParameter(String)
    
}

extension MagicError:  CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .invalidParameter(let msg):
            return "【参数错误】\(msg)"
        }
    }
}
