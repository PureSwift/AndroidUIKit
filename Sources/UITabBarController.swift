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
        
        let (tabBarRect, contentRect) = self.contentRect(for: view.bounds)
        
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        tabBar.frame = tabBarRect
        
        self.contentView.frame = contentRect
        
        self.view.addSubview(tabBar)
        self.view.addSubview(contentView)
    }
    
    open override func viewDidLoad() {
        
        
    }
    
    /// The tab bar controller’s delegate object.
    public var delegate: UITabBarControllerDelegate?
    
    /// The tab bar view associated with this controller.
    public lazy var tabBar: UITabBar = {
       
        return UITabBar.init(frame: CGRect(x: 0,
                                           y: 0,
                                           width: UIApplication.shared.androidActivity.screen.bounds.width,
                                           height: 56))
    }()
    
    private var contentView = UIView.init()
    
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
        
        if _viewControllers.count == 0 {
            
            _viewControllers.removeAll()
            tabBar.items = nil
        }
        
        guard let newViewControllers = viewControllers else {
            
            return
        }
        
        _viewControllers = newViewControllers
        
        updateTabBar()
    }
    
    private func updateTabBar(){
        
        var tabBarItems = [UITabBarItem]()
        
        self._viewControllers.forEach { viewController in
            
            guard let tabBarItem = viewController.tabBarItem
                else { return }
            
            tabBarItems.append(tabBarItem)
        }
        
        self.tabBar.setItems(tabBarItems, animated: false)
        self.contentView.backgroundColor = UIColor.green
    }
    
    private func contentRect(for bounds: CGRect) -> (tabbar: CGRect, content: CGRect) {

        let androidTabBarHeight = CGFloat(56)
        
        let tabBarRect = CGRect(x: bounds.minX,
                                       y: bounds.minY,
                                       width: bounds.width,
                                       height: androidTabBarHeight)
        
        let contentRect = CGRect(x: bounds.minX,
                                 y: bounds.maxY - tabBarRect.height,
                                 width: bounds.width,
                                 height: bounds.height - androidTabBarHeight)
        
        NSLog("\(type(of: self)) \(#function): tabBarRect h = \(tabBarRect.height)")
        NSLog("\(type(of: self)) \(#function): contentRect h = \(contentRect.height)")
        
        return (tabBarRect, contentRect)
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


