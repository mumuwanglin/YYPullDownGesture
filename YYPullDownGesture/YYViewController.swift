//
//  YYViewController.swift
//  YYPullDownGesture
//
//  Created by mumu on 2020/6/23.
//  Copyright © 2020 mumu. All rights reserved.
//

import UIKit

private let YYSCreenWidth = UIScreen.main.bounds.size.width
private let YYSCreenHeight = UIScreen.main.bounds.size.height
private var instanceShouldRecognizeSimultaneously: Bool = false

class YYViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第二个页面"
        self.view.backgroundColor = .gray
            
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: YYSCreenWidth, height: YYSCreenHeight)) // Frame属性
        scrollView.contentSize = CGSize(width: YYSCreenWidth, height: YYSCreenHeight * 2) // ContentSize属性
        scrollView.backgroundColor = .gray
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(clickDismissAction))
    }
    

    @objc func clickDismissAction() {
        self.dismiss(animated: true) {
            self.removePresentAnimator()
        }
    }
}

extension YYViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        // 管理状态不允许下拉刷新
        if offsetY <= 0 {
            instanceShouldRecognizeSimultaneously = true
            scrollView.contentOffset = .zero
        }else {
            instanceShouldRecognizeSimultaneously = false
        }
    }
}

extension UIScrollView: UIGestureRecognizerDelegate {
    // 允许同时触发多个手势
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return instanceShouldRecognizeSimultaneously
    }
}
