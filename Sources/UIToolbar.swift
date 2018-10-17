//
//  UIToolbar.swift
//  androiduikittarget
//
//  Created by Alsey Coleman Miller on 8/23/18.
//

import Foundation
import Android

open class UIToolbar: UIView {
    
    internal private(set) lazy var androidBottomNavView: AndroidBottomNavigationView = { [unowned self] in
        
        let bottomNavView = AndroidBottomNavigationView(context: UIScreen.main.activity)
        
        bottomNavView.layoutParams = AndroidFrameLayoutLayoutParams(width: AndroidFrameLayoutLayoutParams.MATCH_PARENT, height: AndroidFrameLayoutLayoutParams.WRAP_CONTENT)
        
        bottomNavView.setOnNavigationItemSelectedListener { menuItem in
            
            guard self._toolbarStack.count > 0
                else { return }
            
            if let barButtonItem = self._toolbarStack.first(where: { $0.androidMenuItemId == menuItem.itemId }) {
                
                barButtonItem.action?()
            }
        }
        
        return bottomNavView
        }()
    
    
    public convenience init() {
        self.init(frame: .zero)
        
        androidView.addView(androidBottomNavView)
    }
    
    public weak var delegate: UIToolbarDelegate?
    
    /// The items displayed on the toolbar.
    public var items: [UIBarButtonItem]? {
        
        get { return _toolbarStack }
        
        set { setItems(newValue, animated: false) }
    }
    
    private var _toolbarStack = [UIBarButtonItem]()
    
    /// Sets the items on the toolbar by animating the changes.
    public func setItems(_ items: [UIBarButtonItem]?, animated: Bool) {
        
        guard let items = items else {
            
            _toolbarStack.removeAll()
            return
        }
        
        _toolbarStack = items
        
        updateAndroidBottomNavigationView()
    }
    
    private func updateAndroidBottomNavigationView(){
        
        guard _toolbarStack.count > 0
            else { return }
        
        let menu = androidBottomNavView.menu
        
        menu.clear()
        
        _toolbarStack.forEach { barButton in
            
            let menuItem = menu.add(groupId: 1, itemId: barButton.androidMenuItemId, order: 1, title: barButton.title ?? "")
            
            guard let image = barButton.image, let drawableId = image.androidDrawableId
                else { return }
            
            menuItem.setIcon(resId: drawableId)
        }
    }
    
    public var barStyle = UIBarStyle.default
    
    /// The tint color to apply to the toolbar background.
    public var barTintColor: UIColor?
    
    /// A Boolean value that indicates whether the toolbar is translucent (true) or not (false).
    public var isTranslucent: Bool = true
    
    func backgroundImage(forToolbarPosition: UIBarPosition, barMetrics: UIBarMetrics) -> UIImage? {
        fatalError("Not implemented")
    }
    
    func setBackgroundImage(_ image: UIImage?, forToolbarPosition: UIBarPosition, barMetrics: UIBarMetrics) {
        fatalError("Not implemented")
    }
    
    func shadowImage(forToolbarPosition: UIBarPosition) -> UIImage? {
        fatalError("Not implemented")
    }
    
    func setShadowImage(_ image: UIImage?, forToolbarPosition: UIBarPosition) {
        fatalError("Not implemented")
    }
}

public enum UIBarStyle: Int {
    
    case `default` = 0
    case black = 1
    case blackTranslucent = 2
}

public enum UIBarPosition: Int {
    
    /// Specifies that the position is unspecified.
    case any = 0
    
    /// Specifies that the bar is at the bottom of its containing view.
    case bottom = 1
    
    /// Specifies that the bar is at the top of its containing view.
    case top = 2
    
    /// Specifies that the bar is at the top of the screen, as well as its containing view.
    case topAttached = 3
}

public enum UIBarMetrics: Int {
    
    /// Specifies default metrics for the device.
    case `default` = 0
    
    /// Specifies metrics when using the phone idiom.
    case compact = 1
    
    /// Specifies default metrics for the device for bars with the prompt property, such as UINavigationBar and UISearchBar.
    case defaultPromt = 101
    
    /// Specifies metrics for bars with the prompt property when using the phone idiom, such as UINavigationBar and UISearchBar.
    case compactPrompt = 102
}
