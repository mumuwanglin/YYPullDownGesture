//
//  UIViewController+PanDown.swift
//  PanDowmPresent
//
//  Created by mumu on 2020/6/13.
//  Copyright © 2020 mumu. All rights reserved.
//

import UIKit

private var YYPresentAnimation = "YYPresentAnimation"
private var YYPresentKey = "YMStandardDefaultsTableName"

protocol UIViewControllerPanDwom {
    var yy_presentAnimation: Bool? { get set }
    var yy_presentKey: String? { get set }
    func yy_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?);
    func removePresentAnimator()
}

extension UIViewController {
    ///是否存在这个present自定义动画，如果不是调用bd_present的方式则为no
    private var yy_presentAnimation: Bool? {
        set {
            objc_setAssociatedObject(self, &YYPresentAnimation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &YYPresentAnimation) as? Bool
        }
    }
    ///默认为nil ,如果调用了bd_present后，则被presnent的控制器则存在这个Key值，方便在delloc的时候将animator销毁
    var yy_presentKey: String? {
        set {
            objc_setAssociatedObject(self, &YYPresentKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &YYPresentKey) as? String
        }
    }
    
    func yy_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil){
        // 动画执行器
        let animator = YYPresentAnimator(controller: viewControllerToPresent)
        viewControllerToPresent.transitioningDelegate = animator
        viewControllerToPresent.yy_presentAnimation = true
        
        let className = NSStringFromClass(viewControllerToPresent.classForCoder)
        let sourceKey = "\(className)_\(viewControllerToPresent)"
        viewControllerToPresent.yy_presentKey = sourceKey
        
        // 保存动画
        YYPresentAnimatorManager.shared.addAnimtor(animator: animator, key: sourceKey)
        // 添加手势
        addViewControllerGesture(viewControllerToPresent, animator: animator)
        // 执行present方法
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    private func addViewControllerGesture(_ viewControllerToPresent: UIViewController,animator: YYPresentAnimator) {
        // 只给ViewController 添加手势,防止下滑手势影响后续的页面
        if let topNav = (viewControllerToPresent as? UINavigationController), let topVc = topNav.topViewController, topVc is YYViewController {
            // 下滑手势
           let panDowm = UIPanGestureRecognizer(target: animator, action: #selector(YYPresentAnimator.dowmPanAction(gesture:)))
           topVc.view.addGestureRecognizer(panDowm)

           // 侧滑手势
           let leftPan = UIScreenEdgePanGestureRecognizer(target: animator, action: #selector(YYPresentAnimator.leftEdgePanAction(gesture:)))
           leftPan.edges = .left
           topVc.view.addGestureRecognizer(leftPan)
        }
    }
    
    func removePresentAnimator() {
        // 如果是preent过来的是viewcontroller
        if let sourceKey = self.yy_presentKey {
            YYPresentAnimatorManager.shared.removeAnimator(key: sourceKey)
        }
        // 如果是preent过来的是navigationcontroller
        if let sourceKey = self.navigationController?.yy_presentKey {
            YYPresentAnimatorManager.shared.removeAnimator(key: sourceKey)
        }
    }
    
}


