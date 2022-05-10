//
//  CGRectTest.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/9.
//

import UIKit
import DrMagic

func rectTest() {
    let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
    let modifyRect = rect.mg
        .setX(10)
        .setY(10)
        .setWidth(50)
        .setHeight(50)
        .value
    assert(modifyRect == CGRect(x: 10, y: 10, width: 50, height: 50), "CGRect test fail.")
    let modifyRect2 = modifyRect.mg
        .setXY(x: 20, y: 30)
        .setSize(width: 80, height: 80)
        .value
    assert(modifyRect2 == CGRect(x: 20, y: 30, width: 80, height: 80), "CGRect test fail.")
    
    let modifyRect3 = rect.mg
        .offsetBy(dx: 10, dy: 10)
        .value
    assert(modifyRect3 == CGRect(x: 10, y: 10, width: 100, height: 100), "CGRect test fail.")
    
    let modifyRect4 = rect.mg
        .insetBy(dx: 10, dy: 10)
        .value
    assert(modifyRect4 == CGRect(x: 10, y: 10, width: 80, height: 80), "CGRect test fail.")
    
    let modifyRect5 = rect.mg
        .inset(by: UIEdgeInsets(top: 10, left: 30, bottom: 20, right: 20))
        .value
    assert(modifyRect5 == CGRect(x: 30, y: 10, width: 50, height: 70), "CGRect test fail.")
    
}
