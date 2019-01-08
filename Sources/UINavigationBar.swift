//
//  UINavigationBar.swift
//  androiduikittarget
//
//  Created by Alsey Coleman Miller on 8/23/18.
//

import Foundation
import Android
import java_swift

open class UINavigationBar: UIView {
    
    public weak var delegate: UINavigationBarDelegate?
    
    public var items: [UINavigationItem]? {
        
        get { return _navigationStack }
        
        set { setItems(newValue, animated: false) }
    }
    
    private var _navigationStack = [UINavigationItem]()
    
    public var isTranslucent: Bool = true
    
    public var topItem: UINavigationItem? {
        
        return _navigationStack.last
    }
    
    public var backItem: UINavigationItem? {
        
        guard _navigationStack.count > 1
            else { return nil }
        
        return _navigationStack[_navigationStack.count - 2]
    }
    
    internal private(set) lazy var androidToolbar: AndroidToolbar = { [unowned self] in
        
        let toolbar = AndroidToolbar(context: UIScreen.main.activity)
        
        //FIXME: toolbar.context?.setTheme(resId: UIScreen.main.activity.getIdentifier(name: "ToolBarStyle", type: "style"))
        toolbar.popupTheme = UIScreen.main.activity.getIdentifier(name: "Light", type: "style")
        
        toolbar.title = "AndroidUIKit"
        
        // default background color
        
        var navigationBarColorId = UIScreen.main.activity.getIdentifier(name: "navigationBarColor", type: "color")
        
        if (navigationBarColorId == 0){
            
            navigationBarColorId = UIScreen.main.activity.getIdentifier(name: "colorPrimary", type: "color")
        }
        
        if(navigationBarColorId != 0){
            
            toolbar.setBackgroundColor(color: AndroidContextCompat.getColor(context: UIScreen.main.activity, colorRes: navigationBarColorId))
        }
        
        let navigationBarTitleColor = UIScreen.main.activity.getIdentifier(name: "navigationBarTitleColor", type: "color")
        
        if(navigationBarTitleColor != 0){
            
            toolbar.setTitleTextColor(color: AndroidContextCompat.getColor(context: UIScreen.main.activity, colorRes: navigationBarTitleColor))
        }
        
        return toolbar
        }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateAndroidToolbarSize()
        
        androidView.addView(androidToolbar)
        
        NSLog("\(type(of: self)) \(#function)")
    }
    
    private func updateAndroidToolbarSize() {
        
        let frameDp = frame.applyingDP()
        
        // set origin
        androidToolbar.setX(x: Float(frameDp.minX))
        androidToolbar.setY(y: Float(frameDp.minY))
        
        // set size
        androidToolbar.layoutParams = Android.Widget.FrameLayout.FLayoutParams(width: Int(frameDp.width), height: Int(frameDp.height))
    }
    
    private func addMenuItem(uiBarButtonItem: UIBarButtonItem, groundId: Int){
        
        let menuItem = androidToolbar.menu.add(groupId: groundId, itemId: uiBarButtonItem.androidMenuItemId, order: 1, title: uiBarButtonItem.title ?? "")
        menuItem.setShowAsAction(action: AndroidMenuItemForward.ShowAsAction.ifRoom)
        
        if let image = uiBarButtonItem.image,
            let androidDrawableId = image.androidDrawableId {
            
            menuItem.setIcon(resId: androidDrawableId)
        }
    }
    
    private func addSearchController(_ searchController: UISearchController){
        
        let menuItem = androidToolbar.menu.add(groupId: 0, itemId: AndroidViewCompat.generateViewId(), order: 1, title: searchController.searchBar.prompt ?? "")
        menuItem.setShowAsAction(action: AndroidMenuItemForward.ShowAsAction.always)
        menuItem.actionView = searchController.searchBar.androidSearchView
    }
    
    private func updateAndroidToolbar(){
        
        guard let item = _navigationStack.last
            else { return }
        
        // configure views
        androidToolbar.title = item.title ?? ""
        
        androidToolbar.menu.clear()
        
        if let searchController = item.searchController {
            
            addSearchController(searchController)
        }
        
        if item.leftBarButtonItem != nil {
            
            guard let leftBarButtonItem = item.leftBarButtonItem
                else { return }
            
            addMenuItem(uiBarButtonItem: leftBarButtonItem, groundId: 2)
        }
        
        item.leftBarButtonItems?.forEach { barButton in
            
            addMenuItem(uiBarButtonItem: barButton, groundId: 2)
        }
        
        if item.rightBarButtonItem != nil {
            
            guard let rightBarButtonItem = item.rightBarButtonItem
                else { return }
            
            addMenuItem(uiBarButtonItem: rightBarButtonItem, groundId: 1)
        }
        
        item.rightBarButtonItems?.forEach { barButton in
            
            addMenuItem(uiBarButtonItem: barButton, groundId: 1)
        }
        
        androidToolbar.setOnMenuItemClickListener { menuItem in
            
            if item.leftBarButtonItem != nil && item.leftBarButtonItem?.androidMenuItemId == menuItem?.itemId {
                item.leftBarButtonItem?.action?()
                return true
            }
            
            if item.rightBarButtonItem != nil && item.rightBarButtonItem?.androidMenuItemId == menuItem?.itemId {
                item.rightBarButtonItem?.action?()
                return true
            }
            
            item.leftBarButtonItems?.forEach { barButton in
                if(barButton.androidMenuItemId == menuItem?.itemId){
                    barButton.action?()
                    return
                }
            }
            
            item.rightBarButtonItems?.forEach { barButton in
                if(barButton.androidMenuItemId == menuItem?.itemId){
                    barButton.action?()
                    return
                }
            }
            
            return false
        }
    }
    
    // Pushing a navigation item displays the item's title in the center of the navigation bar.
    // The previous top navigation item (if it exists) is displayed as a "back" button on the left.
    public func pushItem(_ item: UINavigationItem, animated: Bool) {
        
        guard delegate?.navigationBar(self, shouldPush: item) ?? true
            else { return }
        
        _navigationStack.append(item)
        
        updateAndroidToolbar()
        
        delegate?.navigationBar(self, didPush: item)
    }
    
    // Returns the item that was popped.
    @discardableResult
    public func popItem(animated: Bool) -> UINavigationItem? {
        
        NSLog("\(type(of: self)) \(#function) 1")
        
        NSLog("\(type(of: self)) \(#function) count \(_navigationStack.count)")
        
        if _navigationStack.count <= 1 {
            return nil
        }
        NSLog("\(type(of: self)) \(#function) 2")
        guard let poppedItem = topItem
            else { return nil }
        
        guard delegate?.navigationBar(self, shouldPop: poppedItem) ?? true
            else { return nil }
        
        _navigationStack.removeLast()
        
        updateAndroidToolbar()
        
        NSLog("\(type(of: self)) \(#function) 3")
        
        delegate?.navigationBar(self, didPop: poppedItem)
        return poppedItem
    }
    
    public func setItems(_ items: [UINavigationItem]?, animated: Bool) {
        
        guard let items = items else {
            
            _navigationStack.removeAll()
            return
        }
        
        _navigationStack = items
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        updateAndroidToolbarSize()
    }
    
}

private extension UINavigationBar {
    
    enum Transition {
        
        case none
        case push
        case pop
    }
}
