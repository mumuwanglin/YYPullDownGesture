//
//  YYPresentAnminatorAction.swift
//  PanDowmPresent
//
//  Created by mumu on 2020/6/13.
//  Copyright © 2020 mumu. All rights reserved.
//

import UIKit


private let MMSCreenWidth = UIScreen.main.bounds.size.width
private let MMSCreenHeight = UIScreen.main.bounds.size.height

//动画的枚举
enum YYTransformType: NSInteger {
    case present
    case dismiss
}

class YYPresentAnminatorAction: NSObject {
    
    open var transformType: YYTransformType?
    
    override init() {
        
    }
}

// MARK: 自定义动画方法
extension YYPresentAnminatorAction {
    func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        toView?.frame = transitionContext.containerView.bounds
        if let toView = toView {
            transitionContext.containerView.addSubview(toView)
        }
        
        let toWidth: CGFloat = toView?.bounds.size.width ?? 0
        let toHeight: CGFloat = toView?.bounds.size.height ?? 0
        toView?.frame = CGRect(x: 0, y: toHeight, width: toWidth, height: toHeight)
                
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView?.frame = CGRect(x: 0, y: 0, width: toWidth, height: toHeight)
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromView?.layer.zPosition = 0
            fromView?.layer.transform = CATransform3DIdentity
        }
    }
    
    func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        let alphaView = UIView()
        alphaView.backgroundColor = UIColor.black.withAlphaComponent(0.33)
        toView?.frame = transitionContext.containerView.bounds
        if let toView = toView, let fromView = fromView{
            alphaView.frame = toView.frame
            toView.addSubview(alphaView)
            transitionContext.containerView.addSubview(toView)
            transitionContext.containerView.bringSubviewToFront(fromView)
        }
                
        let toWidth: CGFloat = toView?.bounds.size.width ?? 0
        let toHeight: CGFloat = toView?.bounds.size.height ?? 0

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView?.frame = CGRect(x: 0, y: toHeight, width: toWidth, height: toHeight)
        }) { (finished) in
            alphaView.removeFromSuperview()
            fromView?.frame = CGRect(x: 0, y: 0, width: toWidth, height: toHeight)
            toView?.frame = CGRect(x: 0, y: 0, width: toWidth, height: toHeight)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    

}

// MARK: Delegate
extension YYPresentAnminatorAction: UIViewControllerAnimatedTransitioning {
    // 动画的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    // 执行动画的方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transformType {
        case .present:
            presentAnimation(transitionContext: transitionContext)
            return
        case .dismiss:
            dismissAnimation(transitionContext: transitionContext)
            return
        default:
            return
        }
    }
}
