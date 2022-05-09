//
//  CGRect+ext.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/9.
//

import UIKit

extension CGRect: MagicBoxExt {}
extension MagicBox where T == CGRect {
    
    public func setX(_ x: CGFloat) -> Self {
        var rect = value
        rect.origin.x = x
        return MagicBox(rect)
    }
    
    public func setY(_ y: CGFloat) -> Self {
        var rect = value
        rect.origin.y = y
        return MagicBox(rect)
    }
    
    public func setXY(x: CGFloat, y: CGFloat) -> Self {
        return setXY(point: CGPoint(x: x, y: y))
    }
    
    public func setXY(point: CGPoint) -> Self {
        var rect = value
        rect.origin = point
        return MagicBox(rect)
    }
    
    public func setWidth(_ width: CGFloat) -> Self {
        var rect = value
        rect.size.width = width
        return MagicBox(rect)
    }
    
    public func setHeight(_ height: CGFloat) -> Self {
        var rect = value
        rect.size.height = height
        return MagicBox(rect)
    }
    
    public func setSize(width: CGFloat, height: CGFloat) -> Self {
        setSize(CGSize(width: width, height: height))
    }
    
    public func setSize(_ size: CGSize) -> Self {
        var rect = value
        rect.size = size
        return MagicBox(rect)
    }
    
    public func offsetBy(dx: CGFloat, dy: CGFloat) -> Self {
        return MagicBox(value.offsetBy(dx: dx, dy: dy))
    }
    
    public func insetBy(dx: CGFloat, dy: CGFloat) -> Self {
        return MagicBox(value.insetBy(dx: dx, dy: dy))
    }
    
    public func inset(by edge: UIEdgeInsets) -> Self {
        return MagicBox(value.inset(by: edge))
    }
}
