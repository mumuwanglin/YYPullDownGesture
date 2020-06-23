
## 前言

因为项目需要，Present动画需要支持下滑和侧滑返回，所以自定义了present动画。

## 正文

想要实现不一般又炫酷的present过渡动画，则必须使用自定义动画了，主要就是  UIViewControllerAnimatedTransitioning这个协议中进行具体的动画操作。

网上也看过其他人写的，虽然确实挺花俏的，但是真正导入项目的时候有些不可用，最典型的问题就是 影响了原有的代码，还有就是只支持一次性展示效果，达不到多层次效果，比如present一个controllerA之后，再从controllerA present到controllerB。为了完善一下，特地整理了一下项目中的分享给大家,[Demo地址](https://github.com/mumuwanglin/YYPullDownGesture)

当然，为这个只是针对present模态展示的。总共用到的效果有定义为二种

``` swift 
enum YYTransformType: NSInteger {
    case present
    case dismiss
}
````

## 组成部分

1. 控制器分类，如果想要使用这个效果，则直接yy_present即可
``` swift
var yy_presentAnimation: Bool? { get set }
var yy_presentKey: String? { get set }
func yy_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?);
func removePresentAnimator()
```
2. 对象管理记具体实施者
``` swift
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
```
3. 具体动画实现方式

``` swift
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
```
