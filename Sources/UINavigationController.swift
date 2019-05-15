//
//  UINavigationController.swift
//  androiduikittarget
//
//  Created by Marco Estrella on 8/23/18.
//

import Foundation
import Android
import java_swift

open class UINavigationController: UIViewController {
    
    // MARK: - Public properties
    
    /// The view controller at the top of the navigation stack.
    public var topViewController: UIViewController? {
        
        return children.last
    }
    
    /// The view controller associated with the currently visible view in the navigation interface.
    public private(set) var visibleViewController: UIViewController?
    
    /// The view controllers currently on the navigation stack.
    public var viewControllers: [UIViewController] {
        
        get { return children }
    }
    
    //private var _viewControllers = [UIViewController]()
    
    public lazy var navigationBar = UINavigationBar()
    
    /*
     public var isNavigationBarHidden: Bool {
     
     get { return _isNavigationBarHidden }
     
     set {
     navigationBar.isHidden = newValue
     _isNavigationBarHidden = newValue
     }
     }
     */
    
    fileprivate var _isNavigationBarHidden: Bool = false
    
    public lazy var toolbar = UIToolbar()
    
    public var isToolbarHidden: Bool {
        
        get { return _isToolbarHidden }
        
        set {
            toolbar.isHidden = newValue
            _isToolbarHidden = newValue
            NSLog("_isToolbarHiddenSet = \(newValue)")
        }
    }
    
    private var _isToolbarHidden: Bool = true
    
    /// The delegate of the navigation controller object.
    public weak var delegate: UINavigationControllerDelegate?
    
    open override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        
        return false
    }
    
    /// Initializes and returns a newly created navigation controller.
    public init(rootViewController: UIViewController) {
        NSLog("111 - \(#function) ")
        #if os(iOS)
        super.init(nibName: nil, bundle: nil)
        #else
        super.init()
        #endif
        
        // setup
        rootViewController.navigationItem.hidesBackButton = true
        self.navigationBar.delegate = self
        self.setViewControllers([rootViewController], animated: false)
    }
    
    internal let content = UIView(frame: .zero)
    
    #if os(iOS)
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("Dont use \(#function)")
    }
    #endif
    
    open override func loadView() {
        NSLog("loadView here")
        let view = UIView(frame: UIScreen.main.bounds)
        view.clipsToBounds = true
        self.view = view
    }
    
    open override func viewWillLayoutSubviews() {
        
        
    }
    
    private func prepareVisibleViewController(for bounds: CGRect){
        
        guard let visibleViewController = self.visibleViewController
            else { return }
        
        let androidActionBarHeight = CGFloat.applyDP(pixels: UIScreen.main.activity.actionBarHeighPixels)
        let androidBottomNavigationBarHeight = CGFloat(56)
        
        var contentRect = bounds
        
        let navigationBarRect = CGRect(x: bounds.minX,
                                       y: bounds.minY,
                                       width: bounds.width,
                                       height: androidActionBarHeight)
        
        let toolbarRect = CGRect(x: bounds.minX,
                                 y: bounds.maxY - androidBottomNavigationBarHeight,
                                 width: bounds.width,
                                 height: androidBottomNavigationBarHeight)
        
        let parentIsTabBarController = parent is UITabBarController
        if(parentIsTabBarController){
            _isNavigationBarHidden = true
        }
        
        if !_isNavigationBarHidden {
            
            contentRect.origin.y += navigationBarRect.height
            contentRect.size.height -= navigationBarRect.height
            
            self.navigationBar.frame = navigationBarRect
            self.view.addSubview(navigationBar)
        } else {
            
            self.navigationBar.frame = .zero
            self.navigationBar.removeFromSuperview()
        }
        
        if !isToolbarHidden {
            
            contentRect.size.height -= toolbarRect.height
            
            self.toolbar.frame = toolbarRect
            self.view.addSubview(toolbar)
        } else {
            
            self.toolbar.frame = .zero
            self.toolbar.removeFromSuperview()
        }
        
        toolbar.isHidden = _isToolbarHidden
        navigationBar.isHidden = _isNavigationBarHidden
        
        visibleViewController.view.frame = contentRect
        self.view.addSubview(visibleViewController.view)
    }
    
    fileprivate func updateVisibleViewController(animated: Bool) {
        NSLog("111 \(type(of: self)) \(#function)")
        
        guard let newVisibleViewController = self.topViewController
            else { fatalError("Must have visible view controller") }
        
        let oldVisibleViewController = self.visibleViewController
        oldVisibleViewController?.view.removeFromSuperview()
        
        let isPushing = oldVisibleViewController?.parent != nil
        
        oldVisibleViewController?.beginAppearanceTransition(false, animated: animated)
        newVisibleViewController.beginAppearanceTransition(true, animated: animated)
        
        self.delegate?.navigationController(self, willShow: newVisibleViewController, animated: animated)
        
        self.visibleViewController = newVisibleViewController
        
        prepareVisibleViewController(for: self.view.bounds)
        
        // FIXME: Animate
        
        // finish animation
        
        oldVisibleViewController?.endAppearanceTransition()
        newVisibleViewController.endAppearanceTransition()
        
        if let oldVisibleViewController = oldVisibleViewController, isPushing {
            
            oldVisibleViewController.didMove(toParentViewController: nil)
            
        } else {
            
            newVisibleViewController.didMove(toParentViewController: self)
        }
        
        self.delegate?.navigationController(self, didShow: newVisibleViewController, animated: animated)
    }
    
    open override func didAttachOnParent() {
        NSLog("111 \(type(of: self)) \(#function)")
        
        guard let parent = parent
            else { return }
        
        if parent is UITabBarController {
            
            let _parentController = parent as? UITabBarController
            
            guard let tabBarController = _parentController
                else { return }
            
            let newContentFrame = CGRect(x: 0, y: 0, width: tabBarController.contentView.frame.width, height: tabBarController.contentView.frame.height)
            
            self.view.bounds = newContentFrame
            self.view.frame = newContentFrame
            
            tabBarController.contentView.addSubview(self.view)
        }
        
        updateVisibleViewController(animated: false)
    }
}

// MARK: - Accessing Items on the Navigation Stack

public extension UINavigationController {
    
    /// Replaces the view controllers currently managed by the navigation controller with the specified items.
    public func setViewControllers(_ newViewControllers: [UIViewController], animated: Bool) {
        NSLog("111 - \(type(of: self)) \(#function)")
        
        precondition(newViewControllers.isEmpty == false, "Missing root view controller")
        
        guard newViewControllers != self.viewControllers
            else { return } // no change
        
        // these view controllers are not in the new collection, so we must remove them as children
        self.viewControllers.forEach {
            if newViewControllers.contains($0) == false {
                $0.willMove(toParentViewController: nil)
                $0.removeFromParent()
            }
        }
        
        // reset navigation bar
        self.navigationBar.items = nil
        
        // add items
        newViewControllers.forEach {
            pushViewController($0, animated: animated)
        }
    }
}

// MARK: - Pushing and Popping Stack Items

public extension UINavigationController {
    
    /// Pushes a view controller onto the receiver’s stack and updates the display.
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        NSLog("111 \(type(of: self)) \(#function)")
        
        // assertions
        precondition(viewController is UITabBarController == false, "Cannot embed tab bar controller in navigation controller")
        precondition(viewControllers.contains(viewController) == false, "Already pushed view controller")
        precondition(viewController.parent == nil || viewController.parent == self, "Belongs to another parent \(viewController.parent!)")
        
        if viewController.parent !== self {
            
            addChild(viewController)
        }
        
        updateVisibleViewController(animated: animated)
        
        if( parent is UITabBarController ){
            
            let _tabBarControllerParent = parent as? UITabBarController
            
            guard let tabBarControllerParent = _tabBarControllerParent
                else { return }
            
            tabBarControllerParent.navigationBar.pushItem(viewController.navigationItem, animated: false)
        } else {
            
            navigationBar.pushItem(viewController.navigationItem, animated: animated)
        }
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        
        var popped = [UIViewController]()
        
        if self.viewControllers.contains(viewController) {
            while(self.topViewController !== viewController){
                let poppedControllerReturn = self.popViewController(animated: false)
                
                guard let poppedController = poppedControllerReturn
                    else { break }
                
                popped.append(poppedController)
            }
        }
        
        return popped
    }
    
    /// Pops the top view controller from the navigation stack and updates the display.
    @discardableResult
    func popViewController(animated: Bool) -> UIViewController? {
        
        // don't allow popping the rootViewController
        if self.viewControllers.count <= 1 {
            return nil;
        }
        
        let formerTopViewController = self.topViewController
        
        // the real thing seems to only bother calling -willMoveToParentViewController:
        // here if the popped controller is the currently visible one. I have no idea why.
        // if you pop several in a row, the ones buried in the stack don't seem to get called.
        // it is possible that the real implementation is fancier and tracks if a child has
        // been fully ever added or not before making this determination, but I haven't
        // tried to test for that case yet since this was an easy thing to do to replicate
        // the real world behavior I was seeing at the time of this writing.
        if(formerTopViewController === visibleViewController){
            willMove(toParentViewController: nil)
        }
        
        formerTopViewController?.removeFromParent()
        
        self.setNavigationBarHidden(false, animated: false)
        
        if( parent is UITabBarController ) {
            
            guard let tabBarControllerParent = parent as? UITabBarController
                else { fatalError("\(type(of: self)) \(#function) tabBarControllerParent is nil") }
            
            tabBarControllerParent.navigationBar.popItem(animated: false)
        } else {
            
            self.isToolbarHidden = false
            navigationBar.popItem(animated: false)
        }
        
        updateVisibleViewController(animated: false)
        
        return formerTopViewController
    }
    
    /// Pops all the view controllers on the stack except the root view controller and updates the display.
    func popToRootViewController(animated: Bool) -> [UIViewController]? {
        
        fatalError()
    }
}

// MARK: - Configuring Navigation Bars

extension UINavigationController {
    
    /// Sets whether the navigation bar is hidden.
    public func setNavigationBarHidden(_ hide: Bool, animated: Bool) {
        
        if(hide != _isNavigationBarHidden){
            
            _isNavigationBarHidden = hide
            navigationBar.isHidden = hide
            updateVisibleViewController(animated: false)
        }else{
            
            navigationBar.isHidden = _isNavigationBarHidden
        }
    }
}

// MARK: - UINavigationBarDelegate

extension UINavigationController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool  {
        NSLog("\(type(of: self)) \(#function)")
        
        NSLog("backbutton is nil \(item.backBarButtonItem == nil)")
        NSLog("backbutton is hidden \(item.hidesBackButton)")
        
        if(item.backBarButtonItem == nil && !item.hidesBackButton){
            showDefaultBackButton(androidToolbar: navigationBar.androidToolbar)
        }
        
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
        
        if ( navigationBarBackButtonColor != 0 ) {
            
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
            self?.popViewController(animated: false)
        }
        
        UIApplication.shared.androidActivity.backButtonAction = { [weak self] in
            
            self?.popViewController(animated: false)
        }
    }
}
