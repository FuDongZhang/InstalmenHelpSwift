//
//  UIView+Extension.swift
//  InstalmenHelpSwift
//
//  Created by XQT-zfd on 2017/8/18.
//  Copyright © 2017年 XQT-zfd. All rights reserved.
//

import UIKit

// MARK: - 尺寸frame
extension UIView {
    
    /* origin的x */
    var x: CGFloat! {
        
        get {
            return self.frame.origin.x
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newValue
            frame                 = tmpFrame
        }
    }
    
    /* origin的y */
    var y: CGFloat! {
        
        get {
            return self.frame.origin.y
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newValue
            frame                 = tmpFrame
        }
    }
    
    /* 中心点 */
    var swiftCenter: CGPoint {
        
        get {
            return center
        }
        set {
            var tmpCenter : CGPoint = center
            tmpCenter             = newValue
            center                  = tmpCenter
        }
    }
    
    /* 中心点的x */
    var centerX: CGFloat! {
        
        get {
            return self.center.x
        }
        set {
            var tmpCenter : CGPoint = center
            tmpCenter.x             = newValue
            center                  = tmpCenter
        }
    }
    
    /* 中心点的y */
    var centerY: CGFloat! {
        
        get {
            return self.center.y
        }
        set {
            var tmpCenter : CGPoint = center
            tmpCenter.y             = newValue
            center                  = tmpCenter
        }
    }
    
    /* 控件的宽度 */
    var swiftWidth: CGFloat! {
        
        get {
            return self.frame.size.width
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width  = newValue
            frame                 = tmpFrame
        }
    }
    
    /* 控件的高度 */
    var swiftHeight: CGFloat {
        
        get {
            return self.frame.size.height
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newValue
            frame                 = tmpFrame
        }
    }
    
    /* 控件的origin */
    var swiftOrigin: CGPoint! {
        
        get {
            return self.frame.origin
        }
        set{
            var tmpFrame : CGRect = frame
            tmpFrame.origin       = newValue
            frame                 = tmpFrame
        }
    }
    
    var swiftRect: CGRect! {
        return self.frame
    }
    
    /* 控件的尺寸 */
    var swiftSize: CGSize! {
        
        get {
            return self.frame.size
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.size         = newValue
            frame                 = tmpFrame
        }
    }
    

    
    
    //------------------------ MARK: -Layer相关属性方法 ------------------------//
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
           return self.layer.cornerRadius
        }
        set {
           layer.cornerRadius = newValue
           layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        
        get {
            
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        
        get{
            return self.layer.shadowOpacity
        }set {
            self.layer.shadowOpacity = newValue
        }
    }
    
}


// MARK: - 方法
extension UIView {
    
    /**
     *  给控件添加圆角
     */
    func radiousLayer(cornerRadius: CGFloat) -> CAShapeLayer {
        
        let maskPath = UIBezierPath(roundedRect: self.frame, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.frame;
        maskLayer.path = maskPath.cgPath
        return maskLayer
    }
    
    /**
     *  获取最后一个Window
     */
    func lastWindow() -> UIWindow {
        
        let windows = UIApplication.shared.windows as [UIWindow]
        for window in windows.reversed() {
            if window.isKind(of: UIWindow.self) && window.bounds.equalTo(UIScreen.main.bounds) {
                return window
            }
        }
        return UIApplication.shared.keyWindow!
    }
    
    /**
     *  自定义一个view的时候和父控制器隔了几层，需要刷新或者对父控制器做出一些列修改，
     *  这时候可以使用响应者连直接拿到父控制器，避免使用多重block嵌套或者通知这种情况
     */
    func topViewControllerTest() -> UIViewController? {
        var viewController: UIViewController?
        var next = self.superview
        while next != nil {
            let nextResponder: UIResponder = (next?.next)!
            if nextResponder.isKind(of: UIViewController.self) {
                viewController = nextResponder as? UIViewController
                break
            }
            next = next?.superview
        }
        return viewController
    }
    
    func topViewController()  -> UIViewController? {
        var viewController: UIViewController?
        var next = self.next
        while next != nil {
            if next!.isKind(of: UIViewController.classForCoder()) {
                viewController = next as? UIViewController
                break
            }
            next = next!.next
        }
        return viewController
    }
}

// MARK: - 查找一个视图的所有子视图
extension UIView {
    func allSubViewsForView(view: UIView) -> [UIView] {
        var array = [UIView]()
        for subView in view.subviews {
            array.append(subView)
            if (subView.subviews.count > 0) {
                // 递归
                let childView = self.allSubViewsForView(view: subView)
                array += childView
            }
        }
        return array
    }
}

// MARK: - 快速从XIB创建一个View (仅限于XIB中只有一个View的时候)
extension UIView {
    class func loadViewFromXib1<T>() -> T {
        let fullViewName: String = NSStringFromClass(self.classForCoder())
        let viewName: String = fullViewName.components(separatedBy: ".").last!
        return Bundle.main.loadNibNamed(viewName, owner: nil, options: nil)?.last! as! T
    }
}
























