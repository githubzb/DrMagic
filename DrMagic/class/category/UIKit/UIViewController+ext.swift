//
//  UIViewController+ext.swift
//  DrMagic
//
//  Created by dr.box on 2022/6/17.
//

import UIKit

extension UIViewController: MagicBoxObjExt {}

extension MagicBox where T: UIViewController {
    
    /**
     显示模态视图
     
     - Parameter modalVc: 模态视图控制器
     - Parameter type: 模态样式，默认：fullScreen
     - Parameter animated: 是否执行动画，默认：true
     - Parameter completion: 动画执行完毕回调，默认：nil
     */
    public func showModal(_ modalVc: UIViewController,
                          type: UIModalPresentationStyle = .fullScreen,
                          animated: Bool = true,
                          completion: (()->Void)? = nil) {
        modalVc.modalPresentationStyle = .fullScreen
        _present(modalVc, animated: animated, completion: completion)
    }
    
    private func _present(_ page: UIViewController, animated: Bool, completion: (()->Void)?) {
        var presented = value as UIViewController
        while presented.presentedViewController != nil {
            presented = presented.presentedViewController!
        }
        if presented === page { // 防止重复显示同一个视图控制器
            return
        }
        if presented.isBeingDismissed || presented.isBeingPresented { // 当root控制器处于这两种状态时，执行present将失败
            // 加入队列，当root动画结束后在展示
            presentQueue.push(root: value,
                              modalVc: page,
                              animated: animated,
                              completion: completion)
            return
        }
        presented.present(page, animated: animated) {
            completion?()
            self.presentQueue.next()
        }
    }
    
    
}


// MARK: - DrPresentQueue getter
extension MagicBox where T: UIViewController {
    
    private var presentQueue: DrPresentQueue {
        guard let queue = objc_getAssociatedObject(value, &DrPresentQueue.identifier) as? DrPresentQueue else {
            let queue = DrPresentQueue()
            objc_setAssociatedObject(value, &DrPresentQueue.identifier, queue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return queue
        }
        return queue
    }
    
}



// 视图控制器执行present的队列
fileprivate final class DrPresentQueue: NSObject {
    
    private var tasks: [DrPresentQueue.Task] = []
    private var state: DrPresentQueue.State = .pending
    
    deinit {
        tasks.removeAll()
        print("---deinit")
    }
    
    func push(root: UIViewController, modalVc: UIViewController, animated: Bool, completion: (()->Void)?) {
        let task = DrPresentQueue.Task(root: root,
                                       modalVc: modalVc,
                                       animated: animated,
                                       completion: completion)
        tasks.append(task)
        if state == .pending {
            state = .waiting
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(300)) {
                self.next()
            }
        }
    }
    
    func pop() {
        tasks.removeFirst()
    }
    
    func next() {
        guard state != .doing, let task = tasks.first else {
            return
        }
        state = .doing
        task.present { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                self.pop()
                if self.tasks.count > 0 {
                    self.state = .waiting
                    self.next()
                }else {
                    self.state = .pending
                }
            }else {
                // 定时执行下一次
                self.state = .waiting
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(300)) {
                    self.next()
                }
            }
        }
    }
    
    
    
    private enum State {
        case pending
        case waiting
        case doing
    }
    
    private final class Task {
        weak var root: UIViewController?
        let modalVc: UIViewController
        let animated: Bool
        let completion: (()->Void)?
        
        init(root: UIViewController, modalVc: UIViewController, animated: Bool, completion: (()->Void)?) {
            self.root = root
            self.modalVc = modalVc
            self.animated = animated
            self.completion = completion
        }
        
        func present(completion: @escaping (_ finished: Bool) -> Void) {
            guard let root = root else {
                completion(true)
                return
            }
            var presented = root
            while presented.presentedViewController != nil {
                presented = presented.presentedViewController!
            }
            if presented.isBeingPresented || presented.isBeingDismissed {
                completion(false)
                return
            }
            presented.present(modalVc, animated: animated) { [weak self] in
                self?.completion?()
                completion(true)
            }
        }
    }
    
    static var identifier = "drbox.present.queue"
}
