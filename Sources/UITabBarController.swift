//
//  UITabBarController.swift
//  androiduikittarget
//
//  Created by Alsey Coleman Miller on 8/23/18.
//

import Foundation

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
        
        let navBar = UINavigationBar.init(frame: .zero)
        navBar.delegate = self
        return navBar
        }()
    
    /// The tab bar view associated with this controller.
    public lazy var tabBar: UITabBar = { [unowned self] in
        
        let tabBar = UITabBar.init(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: UIApplication.shared.androidActivity.screen.bounds.width,
                                                 height: 56))
        tabBar.delegate = self
        return tabBar
        }()
    
    internal var contentView = UIView.init()
    
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
        
        updateTabBar()
        updateContent(index: 0)
        navigationBar.pushItem(viewControllers![0].navigationItem, animated: false)
    }
    
    private func updateContent(index: Int){
        
        //remove child
        
        let currentViewController = _viewControllers[selectedIndex]
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        
        // add new child
        selectedIndex = index
        selectedViewController = _viewControllers[selectedIndex]
        
        guard let selectedVC = selectedViewController, let view = selectedVC.view
            else { return }
        
        self.addChild(selectedVC)
        self.contentView.addSubview(view)
    }
    
    private var tabBarItems = [UITabBarItem]()
    
    private func updateTabBar(){
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
        
        guard let viewController = viewControllers?[index]
            else { return }
        
        if(viewController is UINavigationController){
            
            NSLog("\(type(of: self)) \(#function) viewController is UINavigationController")
            let navViewController = viewController as! UINavigationController
            
            guard let navigationItems = navViewController.navigationBar.items
                else { return }
            
            guard let navigationItem = navigationItems.last
                else { return }
            
            navigationBar.pushItem(navigationItem, animated: false)
        } else {
            
            NSLog("\(type(of: self)) \(#function) viewController is not UINavigationController")
            navigationBar.pushItem(viewController.navigationItem, animated: false)
        }
    }
}

extension UITabBarController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        NSLog("navigationBar")
    }
}

public protocol UITabBarControllerDelegate {
    
    // Managing Tab Bar Selections
    
    /// Asks the delegate whether the specified view controller should be made active.
    func tabBarController(_ uiTabBatController: UITabBarController, shouldSelect: UIViewController) -> Bool
    
    /// Tells the delegate that the user selected an item in the tab bar.
    func tabBarController(_ uiTabBatController: UITabBarController, didSelect: UIViewController)
    
    // Managing Tab Bar Customizations
    
    /// Tells the delegate that the tab bar customization sheet is about to be displayed.
    func tabBarController(_ uiTabBatController: UITabBarController, willBeginCustomizing: [UIViewController])
    
    /// Tells the delegate that the tab bar customization sheet is about to be dismissed.
    func tabBarController(_ uiTabBatController: UITabBarController, willEndCustomizing: [UIViewController], changed: Bool)
    
    /// Tells the delegate that the tab bar customization sheet was dismissed.
    func tabBarController(_ uiTabBatController: UITabBarController, didEndCustomizing: [UIViewController], changed: Bool)
    
    // Overriding View Rotation Settings
    
    /// Called to allow the delegate to provide the complete set of supported interface orientations for the tab bar controller.
    func tabBarControllerSupportedInterfaceOrientations(_ uiTabBatController: UITabBarController) -> UIInterfaceOrientationMask
    
    /// Called to allow the delegate to provide the preferred orientation for presentation of the tab bar controller.
    func tabBarControllerPreferredInterfaceOrientationForPresentation(_ uiTabBatController: UITabBarController) -> UIInterfaceOrientation
    
    // Supporting Custom Tab Bar Transition Animations
    
    /// Called to allow the delegate to return a UIViewControllerAnimatedTransitioning delegate object for use during a noninteractive tab bar view controller transition.
    //func tabBarController(_ uiTabBatController: UITabBarController, animationControllerForTransitionFrom: UIViewController, to: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
    /// Called to allow the delegate to return a UIViewControllerInteractiveTransitioning delegate object for use during an animated tab bar transition.
    //func tabBarController(_ uiTabBatController: UITabBarController, interactionControllerFor: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
}

public struct UIInterfaceOrientationMask: OptionSet, RawRepresentable, Equatable {
    public let rawValue: Int
    
    public init(rawValue: Int){
        self.rawValue = rawValue
    }
    
    public static var portrait    = UIInterfaceOrientationMask(rawValue: 1 << 0)
    public static var landscapeLeft  = UIInterfaceOrientationMask(rawValue: 1 << 1)
    public static var landscapeRight   = UIInterfaceOrientationMask(rawValue: 1 << 2)
    public static var portraitUpsideDown   = UIInterfaceOrientationMask(rawValue: 1 << 3)
    public static var landscape   = UIInterfaceOrientationMask(rawValue: 1 << 4)
    
    public static var all: UIInterfaceOrientationMask = [.portrait, .landscapeLeft, .landscapeRight, .portraitUpsideDown, .landscape]
    
    public static var allButUpsideDown: UIInterfaceOrientationMask = [.portrait, .landscapeLeft, .landscapeRight, .landscape]
}

public enum UIInterfaceOrientation: Int {
    
    var isLandscape: Bool {
        
        switch self {
            
        case .portrait: return false
        case .landscapeLeft: return true
        case .landscapeRight: return true
        case .portraitUpsideDown: return false
        case .unknown: return false
        }
    }
    
    var isPortrait: Bool  {
        
        switch self {
            
        case .portrait: return true
        case .landscapeLeft: return false
        case .landscapeRight: return false
        case .portraitUpsideDown: return true
        case .unknown: return false
        }
    }
    
    case unknown = 0
    case portrait = 1
    case portraitUpsideDown = 2
    case landscapeLeft = 4
    case landscapeRight = 3
}
