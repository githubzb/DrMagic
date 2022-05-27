//
//  MagicBox.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/9.
//

import UIKit

public protocol MagicBoxExt {}
public protocol MagicBoxObjExt: AnyObject {}

public struct MagicBox<T> {
    public let value: T
    init(_ value: T) {
        self.value = value
    }
}

extension MagicBoxExt {
    
    public var mg: MagicBox<Self> { MagicBox(self) }
    public static var mg: MagicBox<Self>.Type { MagicBox<Self>.self }
}

extension MagicBoxObjExt {
    
    public var mg: MagicBox<Self> { MagicBox(self) }
    public static var mg: MagicBox<Self>.Type { MagicBox<Self>.self }
}

extension MagicBox where T: Equatable {
    
    static func ==(hls: MagicBox, rls: MagicBox) -> Bool {
        hls.value == rls.value
    }
}
