//
//  YYPresentAnimator.swift
//  PanDowmPresent
//
//  Created by mumu on 2020/6/13.
//  Copyright © 2020 mumu. All rights reserved.
//

import UIKit

class YYPresentAnimator: NSObject {
    // 保存presentVC
    private var controller: UIViewController?
    
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    
    private var presentAnimator: YYPresentAnminatorAction = YYPresentAnminatorAction()
    //是否正在执行动画, 保证两个动画不同时执行
    private var isAnimating: Bool = false
    
    convenience init(controller: UIViewController) {
        self.init()
        self.controller = controller
    }
    override init() {
        super.init()
    }
}

extension YYPresentAnimator {
    // 处理侧滑和下拉手势
    @objc func leftEdgePanAction(gesture: UIScreenEdgePanGestureRecognizer) {
        let view = controller?.view
        let translation = gesture.translation(in: gesture.view)
        let fraction = abs(translation.x / (view?.bounds.size.height ?? 0))
        
        switch gesture.state {
        case .began:
            isAnimating = true
            percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            controller?.dismiss(animated: true, completion: nil)
        case .changed:
            percentDrivenTransition?.update(fraction)
        case .ended:
            // 超出屏幕比例0.3动画完成
            if fraction > 0.3 {
                percentDrivenTransition?.finish()
                // 获取当前需要dismiss的控制器
                if let topVc = (controller as? UINavigationController)?.topViewController, topVc is ViewController {
                    // 类型转换位AudioBookVC类型
                    let vc = topVc as? ViewController
                    vc?.finshedBlcok(vc)
                }
            }else{
                percentDrivenTransition?.cancel()
            }
            isAnimating = false
            percentDrivenTransition = nil;
        default:
            isAnimating = false
            percentDrivenTransition?.cancel()
            percentDrivenTransition = nil
        }
    }
    // 处理下滑的手势
    @objc func dowmPanAction(gesture: UIPanGestureRecognizer) {
        let view = controller?.view
        let location = gesture.location(in: gesture.view)
        let translation = gesture.translation(in: gesture.view)
        
        let fraction = abs(translation.y / (view?.bounds.size.height ?? 0))
        switch gesture.state {
        case .began:
            if location.y < view?.bounds.midY ?? 0  {
                isAnimating = true
                percentDrivenTransition = UIPercentDrivenInteractiveTransition()
                controller?.dismiss(animated: true, completion: {
                })
            }
            
        case .changed:
            percentDrivenTransition?.update(fraction)
        case .ended:
            //超出屏幕比例0.3动画完成
            if fraction > 0.3 {
                percentDrivenTransition?.finish()
                // 获取当前需要dismiss的控制器
                if let topVc = (controller as? UINavigationController)?.topViewController, topVc is ViewController {
                    // 类型转换位AudioBookVC类型
                    let vc = topVc as? ViewController
                    vc?.finshedBlcok(vc)
                }
            }else{
                percentDrivenTransition?.cancel()
            }
            isAnimating = false
            percentDrivenTransition = nil;
        default:
            isAnimating = false
            percentDrivenTransition?.cancel()
            percentDrivenTransition = nil
        }
    }
}

extension YYPresentAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {        
        presentAnimator.transformType = .present
        return presentAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentAnimator.transformType = .dismiss
        return presentAnimator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animator.isKind(of: YYPresentAnminatorAction.self){
            return percentDrivenTransition
        }
        return nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animator.isKind(of: YYPresentAnminatorAction.self){
            return percentDrivenTransition
        }
        return nil
    }
    
}



// MARK: - YYPresentAnimatorManager
class YYPresentAnimatorManager {
    
    static let shared = YYPresentAnimatorManager()
    
    private lazy var animatorDict: NSMutableDictionary = NSMutableDictionary()
    
    // 存储动画器
    func addAnimtor(animator: YYPresentAnimator, key: String) {
        animatorDict.setObject(animator, forKey: key as NSString)
    }
    
    // 移除动画器
    func removeAnimator(key: String) {
        if animatorDict.count == 0 {
            return
        }
        if key.count == 0 {
            return
        }
        
        animatorDict.removeObject(forKey: key)
    }
    
}
