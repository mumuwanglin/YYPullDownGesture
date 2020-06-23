//
//  ViewController.swift
//  YYPullDownGesture
//
//  Created by mumu on 2020/6/23.
//  Copyright © 2020 mumu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var finshedBlcok: (_ controller: ViewController?) -> Void = {controller in
        controller?.removePresentAnimator()
        print("dismiss:\(String(describing: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let buttonW:CGFloat = 200
        let ButtonH:CGFloat = 55
        let buttonX = (self.view.bounds.size.width - buttonW) / 2
        
        let button = UIButton(frame: CGRect(x: buttonX, y: 200, width: buttonW, height: ButtonH))
        button.setTitle("点击跳转", for: .normal)
        button.backgroundColor = .green
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button .addTarget(self, action: #selector(clickButtonToPresent), for: .touchUpInside)
        self.view.addSubview(button)
    }

    @objc func clickButtonToPresent() {
        let vc = YYViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.yy_present(nav, animated: true) {
            
        }
    }

}

