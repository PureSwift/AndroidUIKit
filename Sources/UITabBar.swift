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
    
    let tabBarBackgroundId = UIScreen.main.activity.getIdentifier(name: "tabBarBackground", type: "color")
    let tabBarItemSelectedIndicatorColorId = UIScreen.main.activity.getIdentifier(name: "tabBarItemSelectedIndicatorColor", type: "color")
    let tabBarItemNormalId = UIScreen.main.activity.getIdentifier(name: "tabBarItemNormal", type: "color")
    let tabBarItemSelectedColorId = UIScreen.main.activity.getIdentifier(name: "tabBarItemSelectedColor", type: "color")
    
    internal lazy var androidTabLayout: Android.Widget.TabLayout = { [unowned self] in
        
        let context = UIApplication.shared.androidActivity
        
        let tabLayout = Android.Widget.TabLayout.init(context: context)
        
        tabLayout.layoutParams = AndroidFrameLayoutLayoutParams.init(width: AndroidFrameLayoutLayoutParams.MATCH_PARENT, height: AndroidFrameLayoutLayoutParams.WRAP_CONTENT)
        
        tabLayout.setBackgroundColor(color: AndroidContextCompat.getColor(context: UIScreen.main.activity, colorRes: tabBarBackgroundId))
        
        tabLayout.setTabTextColors(normalColor: AndroidContextCompat.getColor(context: context, colorRes: tabBarItemNormalId),
                                   selectedColor: AndroidContextCompat.getColor(context: context, colorRes: tabBarItemSelectedColorId))
        
        tabLayout.setSelectedTabIndicatorColor(color: AndroidContextCompat.getColor(context: context, colorRes: tabBarItemSelectedIndicatorColorId))
        
        tabLayout.setSelectedTabIndicatorHeight(height: Int(4 * UIScreen.main.activity.density))
        
        return tabLayout
        }()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.androidView.addView(androidTabLayout)
    }
    
    override func updateAndroidViewSize() {
        
        let frameDp = frame.applyingDP()
        
        // set origin
        self.androidView.setX(x: Float(frameDp.minX))
        self.androidView.setY(y: Float(frameDp.minY))
        NSLog("\(type(of: self)) \(#function) width:\(frameDp.width)  ")
        // set size
        self.androidView.layoutParams = Android.Widget.FrameLayout.FLayoutParams(width: Int(frameDp.width), height: Int(frameDp.height))
        androidTabLayout.layoutParams = AndroidFrameLayoutLayoutParams.init(width: AndroidFrameLayoutLayoutParams.MATCH_PARENT, height: AndroidFrameLayoutLayoutParams.WRAP_CONTENT)
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
            
            let androidId =  java_lang.Integer(casting: androidTab.tag!)
            let _uiTabBarItem = self.cache[(androidId?.intValue())!]
            
            guard let uiTabBarItem = _uiTabBarItem
                else { return }
            
            self.selectedItem = uiTabBarItem
            self.delegate?.tabBar(tabBar, didSelect: uiTabBarItem)
        }
        
        let onSelectedListener = OnTabClicklistener.init(action: action)
        
        self.androidTabLayout.addOnTabSelectedListener(onSelectedListener)
    }
    
    private func androidTintDrawable(iconId: Int, colorId: Int) -> AndroidGraphicsDrawableDrawable? {
        
        let context = UIApplication.shared.androidActivity
        
        guard let resource = context.resources
            else { return nil }
        
        var iconVectorDrawable: AndroidGraphicsDrawableDrawable? = AndroidVectorDrawableCompat.create(res: resource, resId: iconId, theme: nil)
        guard let iconVector = iconVectorDrawable else { return nil }
        
        let iconDrawable = iconVector as AndroidGraphicsDrawableDrawable
        
        iconVectorDrawable = AndroidDrawableCompat.wrap(drawable: iconDrawable)
        
        guard let finalIconVectorDrawable = iconVectorDrawable
            else { return nil }
        
        AndroidDrawableCompat.setTint(drawable: finalIconVectorDrawable, color: AndroidContextCompat.getColor(context: context, colorRes: colorId))
        
        return finalIconVectorDrawable
    }
    
    /// The items displayed by the tab bar.
    public var items: [UITabBarItem]? {
        get { return _items }
        set { return setItems(newValue, animated: false) }
    }
    
    private var _items = [UITabBarItem]()
    
    private var cache = [Int: UITabBarItem]()
    
    /// Sets the items on the tab bar, optionally animating any changes into position.
    public func setItems(_ uiTabBarItem: [UITabBarItem]?, animated: Bool) {
        
        if _items.count > 0 {
            _items.removeAll()
            androidTabLayout.removeAllTabs()
        }
        
        guard let items = uiTabBarItem else {
            _items.removeAll()
            androidTabLayout.removeAllTabs()
            return
        }
        
        self._items = items
        updateAndroidTabLayout()
    }
    
    private func updateAndroidTabLayout(){
        
        self._items.forEach{ uiTabBarItem in
            
            let tab = self.androidTabLayout.newTab()
            tab.tag = java_lang.Integer(uiTabBarItem.androidId)
            
            if let title = uiTabBarItem.title {
                
                tab.text = title
            }
            
            if let image = uiTabBarItem.image, let androidDrawableId = image.androidDrawableId {
                
                tab.icon = androidTintDrawable(iconId: androidDrawableId, colorId: tabBarItemNormalId)
            }
            
            if uiTabBarItem.position == -1 {
                
                self.androidTabLayout.addTab(tab)
            } else {
                
                self.androidTabLayout.addTab(tab, position: uiTabBarItem.position)
            }
            
            cache[uiTabBarItem.androidId] = uiTabBarItem
        }
        
        guard self._items.count > 0,
            self.androidTabLayout.getTabCount() > 0
            else { return }
        
        self.selectedItem = self._items[0]
        androidTabLayout.getTabAt(index: 0).select()
    }
    
    /// The currently selected item on the tab bar.
    public var selectedItem: UITabBarItem?
    
    /// The tab bar style that specifies its appearance.
    public var barStyle: UIBarStyle = .`default`
    
    /// A Boolean value that indicates whether the tab bar is translucent.
    public var isTranslucent: Bool = true
    
    /// The tint color to apply to the tab bar background.
    public var barTintColor: UIColor? {
        get {
            return UIColor.init(androidColor: androidTabLayout.background as! Android.Graphics.Drawable.ColorDrawable)
        }
        set {
            androidTabLayout.background = barTintColor?.androidColor
        }
    }
    
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
        
        let tabBarItemNormalId = UIScreen.main.activity.getIdentifier(name: "tabBarItemNormal", type: "color")
        let tabBarItemSelectedColorId = UIScreen.main.activity.getIdentifier(name: "tabBarItemSelectedColor", type: "color")
        
        var action: ((AndroidTab) -> ())!
        
        public convenience init(action: @escaping (AndroidTab) -> ()) {
            
            self.init(javaObject: nil)
            self.bindNewJavaObject()
            
            self.action = action
        }
        
        override func onTabSelected(tab: AndroidTab) {
            
            self.action(tab)
            
            guard let icon = tab.icon
                else { return }
            
            androidTintDrawable(iconVector: icon, colorId: tabBarItemSelectedColorId)
        }
        
        override func onTabUnselected(tab: AndroidTab) {
            
            guard let icon = tab.icon
                else { return }
            
            androidTintDrawable(iconVector: icon, colorId: tabBarItemNormalId)
        }
        
        fileprivate func androidTintDrawable(iconVector: AndroidGraphicsDrawableDrawable, colorId: Int){
            
            let context = UIApplication.shared.androidActivity
            
            let iconDrawable = iconVector as AndroidGraphicsDrawableDrawable
            
            AndroidDrawableCompat.setTint(drawable: AndroidDrawableCompat.wrap(drawable: iconDrawable), color: AndroidContextCompat.getColor(context: context, colorRes: colorId))
        }
    }
}
