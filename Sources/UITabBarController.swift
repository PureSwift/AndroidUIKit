//
//  UITabBarController.swift
//  androiduikittarget
//
//  Created by Alsey Coleman Miller on 8/23/18.
//

import Foundation
import Android

/// A container view controller that manages a radio-style selection interface,
/// where the selection determines which child view controller to display.
open class UITabBarController: UIViewController, UITabBarDelegate {
    
    open override func loadView() {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.clipsToBounds = true
        self.view = view
        
        let (navigationBarRect, tabBarRect, contentRect) = self.contentRect(for: view.bounds)
        
        navigationBar.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        navigationBar.frame = navigationBarRect
        
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        tabBar.frame = tabBarRect
        
        self.contentView.frame = contentRect
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(tabBar)
        self.view.addSubview(contentView)
    }
    
    /// The tab bar controller’s delegate object.
    public var delegate: UITabBarControllerDelegate?
    
    internal lazy var navigationBar: UINavigationBar = { [unowned self] in
        
        let navBar = UINavigationBar(frame: .zero)
        navBar.delegate = self
        return navBar
        }()
    
    /// The tab bar view associated with this controller.
    public lazy var tabBar: UITabBar = { [unowned self] in
        
        let tabBar = UITabBar(frame: CGRect(x: 0,
                                            y: 0,
                                            width: UIApplication.shared.androidActivity.screen.bounds.width,
                                            height: 56))
        tabBar.delegate = self
        return tabBar
        }()
    
    internal var contentView = UIView()
    
    /// An array of the root view controllers displayed by the tab bar interface.
    public var viewControllers: [UIViewController]? {
        
        get { return _viewControllers }
        
        set {
            setViewControllers(newValue, animated: false)
        }
    }
    
    private var _viewControllers = [UIViewController]()
    
    /// Sets the root view controllers of the tab bar controller.
    public func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool){
        NSLog("\(type(of: self)) \(#function)")
        
        guard let newViewControllers = viewControllers else {
            NSLog("viewControllers is nil")
            return
        }
        
        _viewControllers = newViewControllers
        
        guard _viewControllers.count > 0 else {
            
            _viewControllers.removeAll()
            tabBar.items = nil
            return
        }
        
        viewControllers?.forEach {
            self.addChild($0)
        }
        
        updateTabBar()
        updateContent(index: 0)
    }
    
    private func updateContent(index: Int){
        
        //remove child
        
        let currentViewController = _viewControllers[selectedIndex]
        currentViewController.view.removeFromSuperview()
        
        // add new child
        selectedIndex = index
        self.selectedViewController = _viewControllers[selectedIndex]
        
        guard let selectedVC = self.selectedViewController, let view = selectedVC.view
            else { return }
        
        NSLog("\(type(of: self)) \(#function) index = \(index)")
        
        NSLog("\(type(of: self)) \(#function) children count = \(self.children.count)")
        
        self.contentView.addSubview(view)
        
        navigationBar.items = []
        
        if(selectedVC is UINavigationController) {
            
            NSLog("\(type(of: self)) \(#function) viewController is UINavigationController")
            let navViewController = selectedVC as! UINavigationController
            
            var items: [UINavigationItem] = []
            
            navViewController.viewControllers.forEach { viewController in
                
                items.append(viewController.navigationItem)
            }
            
            items.removeLast()
            
            navigationBar.items = items
            
            guard let topViewController = navViewController.topViewController
                else { return }
            
            NSLog("\(type(of: self)) \(#function) topViewController title: \(topViewController))")
            navigationBar.pushItem(topViewController.navigationItem, animated: false)
            
        } else {
            
            NSLog("\(type(of: self)) \(#function) viewController is not UINavigationController")
            navigationBar.pushItem(selectedVC.navigationItem, animated: false)
        }
    }
    
    private var tabBarItems = [UITabBarItem]()
    
    private func updateTabBar() {
        NSLog("\(type(of: self)) \(#function) vc.count \(self._viewControllers.count)")
        
        tabBarItems.removeAll()
        
        self._viewControllers.forEach { viewController in
            
            precondition(viewController is UITabBarController == false, "Cannot embed another tab bar controller")
            
            guard let tabBarItem = viewController.tabBarItem else {
                NSLog("\(type(of: self)) \(#function) item is nil")
                return
            }
            
            tabBarItems.append(tabBarItem)
        }
        
        self.tabBar.setItems(tabBarItems, animated: false)
    }
    
    private func contentRect(for bounds: CGRect) -> (navigationbar: CGRect, tabbar: CGRect, content: CGRect) {
        
        let androidToolbarHeight = CGFloat(56)
        let androidTabBarHeight = CGFloat(56)
        
        let navigationbarRect = CGRect(x: bounds.minX,
                                       y: bounds.minY,
                                       width: bounds.width,
                                       height: androidToolbarHeight)
        
        let tabBarRect = CGRect(x: bounds.minX,
                                y: navigationbarRect.height,
                                width: bounds.width,
                                height: androidTabBarHeight)
        
        let contentRect = CGRect(x: bounds.minX,
                                 y: bounds.minY + tabBarRect.height + navigationbarRect.height,
                                 width: bounds.width,
                                 height: bounds.height - androidTabBarHeight - androidToolbarHeight)
        
        NSLog("\(type(of: self)) \(#function): toolbarRect h = \(navigationbarRect.height)")
        NSLog("\(type(of: self)) \(#function): tabBarRect h = \(tabBarRect.height)")
        NSLog("\(type(of: self)) \(#function): contentRect h = \(contentRect.height)")
        
        return (navigationbarRect, tabBarRect, contentRect)
    }
    
    /// The subset of view controllers managed by this tab bar controller that can be customized.
    public var customizableViewControllers: [UIViewController]?
    
    /// The view controller that manages the More navigation interface.
    //public var moreNavigationController: UINavigationController
    
    /// Managing the Selected Tab
    
    /// The view controller associated with the currently selected tab item.
    public var selectedViewController: UIViewController?
    
    /// The index of the view controller associated with the currently selected tab item.
    public var selectedIndex: Int = 0
    
    // MARK: UITabBarDelegate implementation
    
    public func tabBar(_ uiTableBar: UITabBar, willBeginCustomizing: [UITabBarItem]) {
        
    }
    
    public func tabBar(_ uiTableBar: UITabBar, didBeginCustomizing: [UITabBarItem]) {
        
    }
    
    public func tabBar(_ uiTableBar: UITabBar, willEndCustomizing: [UITabBarItem], changed: Bool) {
        
    }
    
    public func tabBar(_ uiTableBar: UITabBar, didEndCustomizing: [UITabBarItem], changed: Bool) {
        
    }
    
    public func tabBar(_ uiTableBar: UITabBar, didSelect: UITabBarItem) {
        
        NSLog("\(type(of: self)) \(#function)")
        
        guard let index = tabBarItems.index(of: didSelect) else {
            NSLog("\(type(of: self)) \(#function) tabbaritem not found")
            return
        }
        
        updateContent(index: index)
    }
}

// MARK: - UINavigationBarDelegate

extension UITabBarController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool  {
        NSLog("\(type(of: self)) \(#function)")
        
        NSLog("backbutton is nil \(item.backBarButtonItem == nil)")
        NSLog("backbutton is hidden \(item.hidesBackButton)")
        
        guard let selectedVC = self.selectedViewController
            else { return false }
        
        if selectedVC is UINavigationController && item.backBarButtonItem == nil && !item.hidesBackButton {
            
            showDefaultBackButton(androidToolbar: navigationBar.androidToolbar)
            return true
        }
        
        navigationBar.androidToolbar.navigationIcon = nil
        UIApplication.shared.androidActivity.backButtonAction = nil
        
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        NSLog("\(type(of: self)) \(#function)")
        
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        NSLog("\(type(of: self)) \(#function)")
        
        if(item.backBarButtonItem == nil && !item.hidesBackButton){
            navigationBar.androidToolbar.navigationIcon = nil
            UIApplication.shared.androidActivity.backButtonAction = nil
        }
        
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        NSLog("\(type(of: self)) \(#function)")
        
        guard let topItem = navigationBar.topItem else {
            return
        }
        
        if(topItem.backBarButtonItem == nil && !topItem.hidesBackButton ){
            showDefaultBackButton(androidToolbar: navigationBar.androidToolbar)
        }
    }
    
    private func showDefaultBackButton(androidToolbar: AndroidToolbar) {
        
        let arrowBackId = UIScreen.main.activity.getIdentifier(name: "ic_arrow_back", type: "drawable")
        
        let navigationBarBackButtonColor = UIScreen.main.activity.getIdentifier(name: "navigationBarBackButtonColor", type: "color")
        
        if ( navigationBarBackButtonColor != 0 ){
            
            let navigationVectorDrawableIcon = AndroidVectorDrawableCompat.create(res:  UIScreen.main.activity.resources!, resId: arrowBackId, theme: nil)
            
            guard let navigationVectorIcon = navigationVectorDrawableIcon
                else { return }
            
            var navIconDrawable = navigationVectorIcon as AndroidGraphicsDrawableDrawable
            navIconDrawable = AndroidDrawableCompat.wrap(drawable: navIconDrawable)
            AndroidDrawableCompat.setTint(drawable: navIconDrawable, color: AndroidContextCompat.getColor(context: UIScreen.main.activity, colorRes: navigationBarBackButtonColor))
            
            navigationBar.androidToolbar.navigationIcon = navIconDrawable
        } else {
            
            navigationBar.androidToolbar.setNavigationIcon(resId: arrowBackId)
        }
        
        navigationBar.androidToolbar.setNavigationOnClickListener { [weak self] in
            
            self?.navigationPopViewController()
        }
        
        UIApplication.shared.androidActivity.backButtonAction = { [weak self] in
            
            self?.navigationPopViewController()
        }
    }
    
    private func navigationPopViewController() {
        
        guard let selectedVC = self.selectedViewController
            else { return }
        
        if selectedVC is UINavigationController {
            
            guard let navViewController = selectedVC as? UINavigationController
                else { return }
            
            navViewController.popViewController(animated: false)
        }
    }
}
