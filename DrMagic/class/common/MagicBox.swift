//
//  MagicBox.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/9.
//

import Foundation

public protocol MagicBoxExt {
    
    var mg: MagicBox<Self> { get }
    static var mg: MagicBox<Self.Type> { get }
}

public struct MagicBox<T> {
    public let value: T
    init(_ value: T) {
        self.value = value
    }
}

extension MagicBoxExt {
    
    public var mg: MagicBox<Self> { MagicBox(self) }
    public static var mg: MagicBox<Self.Type> { MagicBox(self) }
}
