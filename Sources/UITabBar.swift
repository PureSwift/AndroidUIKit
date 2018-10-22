//
//  UITabBar.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 10/19/18.
//

import Foundation
import Android
import java_lang

/// A control that displays one or more buttons in a tab bar for selecting between different subtasks, views, or modes in an app.
open class UITabBar: UIView {
    
    internal lazy var androidTabLayout: Android.Widget.TabLayout = { [unowned self] in
        let tabLayout = Android.Widget.TabLayout.init(context: UIApplication.shared.androidActivity)
        
        tabLayout.layoutParams = AndroidFrameLayoutLayoutParams.init(width: AndroidFrameLayoutLayoutParams.MATCH_PARENT, height: AndroidFrameLayoutLayoutParams.WRAP_CONTENT)
        
        return tabLayout
    }()
    
    public init() {
        super.init(frame: .zero)
    }
    
    /// The tab bar’s delegate object.
    public var delegate: UITabBarDelegate? {
        
        didSet {
            
            addOnTabSelectedListener()
        }
    }
    
    private func addOnTabSelectedListener() {
        
        let tabBar = self
        
        let action: (AndroidTab) -> () = { androidTab in
            
            let _uiTabBarItem = self.cache[androidTab]
            
            guard let uiTabBarItem = _uiTabBarItem
                else { return }
            
            self.delegate?.tabBar(tabBar, didSelect: uiTabBarItem)
        }
        
        let onSelectedListener = OnTabClicklistener.init(action: action)
        //let onSelectedListener = OnTabClicklistener.init(cache: cache, delegate: delegate, tabBar: self)
        
        self.androidTabLayout.addOnTabSelectedListener(onSelectedListener)
    }
    
    /// The items displayed by the tab bar.
    public var items: [UITabBarItem]? {
        get { return _items }
        set { return setItems(newValue, animated: false) }
    }
    
    public var _items = [UITabBarItem]()
    
    private var cache = [AndroidTab: UITabBarItem]()
    
    /// Sets the items on the tab bar, optionally animating any changes into position.
    public func setItems(_ uiTabBarItem: [UITabBarItem]?, animated: Bool) {
        
        if _items.count > 0 {
            _items.removeAll()
            androidTabLayout.removeAllTabs()
        }
        
        guard let items = uiTabBarItem
            else { return }
        
        self._items = items
        updateAndroidTabLayout()
    }
    
    private func updateAndroidTabLayout(){
        
        self._items.forEach{ uiTabBarItem in
            
            let tab = self.androidTabLayout.newTab()
            
            if let title = uiTabBarItem.title {
                
                tab.text = title
            }
            
            if let image = uiTabBarItem.image, let androidDrawableId = image.androidDrawableId {
                
                tab.setIcon(resId: androidDrawableId)
            }
            
            if uiTabBarItem.position == -1 {
                
                self.androidTabLayout.addTab(tab)
            } else {
                
                self.androidTabLayout.addTab(tab, position: uiTabBarItem.position)
            }
            
            cache[tab] = uiTabBarItem
        }
    }
    
    /// The currently selected item on the tab bar.
    public var selectedItem: UITabBarItem?
    
    /// The tab bar style that specifies its appearance.
    public var barStyle: UIBarStyle = .`default`
    
    /// A Boolean value that indicates whether the tab bar is translucent.
    public var isTranslucent: Bool = true
    
    /// The tint color to apply to the tab bar background.
    public var barTintColor: UIColor?
    
    /// The tint color to apply to unselected tabs.
    public var unselectedItemTintColor: UIColor?
    
    /// The custom background image for the tab bar.
    public var backgroundImage: UIImage?
    
    /// The shadow image to use for the tab bar.
    public var shadowImage: UIImage?
    
    /// The image to use for the selection indicator.
    public var selectionIndicatorImage: UIImage?
    
    /// The positioning scheme for the tab bar items in the tab bar.
    public var itemPositioning: ItemPositioning = .fill
    
    /// The amount of space (in points) to use between tab bar items.
    public var itemSpacing: CGFloat = 0
    
    /// The width (in points) of tab bar items.
    public var itemWidth: CGFloat = 0
    
    /// Presents a standard interface that lets the user customize the contents of the tab bar.
    public func beginCustomizingItems(_ items: [UITabBarItem]) {
        
        fatalError("not implemented")
    }
    
    /// Dismisses the standard interface used to customize the tab bar.
    func endCustomizing(animated: Bool) -> Bool {
        
        fatalError("not implemented")
    }
    
    /// A Boolean value indicating whether the user is currently customizing the tab bar.
    public var isCustomizing: Bool = false
}

public extension UITabBar {
    
    /// Constants that specify tab bar item positioning.
    public enum ItemPositioning: Int {
        
        /// Specifies automatic tab bar item positioning according to the user interface idiom.
        case automatic = 0
        
        /// Distribute items across the entire width of the tab bar. When the UITabBar.ItemPositioning.
        /// automatic option is selected, the tab bar uses this behavior in horizontally compact environments.
        case fill      = 1
        
        /// Center items in the available space. With this option, the tab bar uses the
        /// itemWidth and itemSpacing properties to set the width of items and the spacing between items,
        /// positioning those items in the center of the available space When the UITabBar.ItemPositioning.
        /// automatic option is selected, the tab bar uses this behavior in horizontally regular environments.
        case centered  = 2
    }
}

fileprivate extension UITabBar {
    
    fileprivate class OnTabClicklistener: AndroidTabLayout.OnTabSelectedListener {
        
        var action: ((AndroidTab) -> ())!
        
        public convenience init(action: @escaping (AndroidTab) -> ()) {
            
            self.init(javaObject: nil)
            self.bindNewJavaObject()
            
            self.action = action
        }
        
        override func onTabSelected(tab: AndroidTab) {
            
            self.action(tab)
        }
    }
    
    /*
    fileprivate class OnTabClicklistener: AndroidTabLayout.OnTabSelectedListener {
        
        private var cache = [AndroidTab:UITabBarItem]()
        private var delegate: UITabBarDelegate?
        private var tabBar: UITabBar!
        
        public convenience init(cache: [AndroidTab:UITabBarItem], delegate: UITabBarDelegate?, tabBar: UITabBar) {
            
            self.init(javaObject: nil)
            self.bindNewJavaObject()
            
            self.cache = cache
            self.delegate = delegate
            self.tabBar = tabBar
        }
        
        override func onTabSelected(tab: AndroidTab) {
            
            
        }
    }*/
}
