//
//  UINavigationItem.swift
//  androiduikittarget
//
//  Created by Alsey Coleman Miller on 8/23/18.
//

import Foundation

open class UINavigationItem: NSObject {
    
    public var title: String?
    
    /// The mode to use when displaying the title of the navigation bar.
    public var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode?
    
    /// A single line of text displayed at the top of the navigation bar.
    public var prompt: String?
    
    public var backBarButtonItem: UIBarButtonItem?
    
    /// A Boolean value that determines whether the back button is hidden.
    public var hidesBackButton: Bool = false
    
    /// A Boolean value indicating whether the left items are displayed in addition to the back button.
    public var leftItemsSupplementBackButton: Bool!
    
    //MARK: Customizing Views
    
    /// A custom view displayed in the center of the navigation bar when the receiver is the top item.
    public var titleView: UIView?
    
    /// An array of custom bar button items to display on the left (or leading) side of the navigation bar when the receiver is the top navigation item.
    public var leftBarButtonItems: [UIBarButtonItem]?
    
    /// A custom bar button item displayed on the left (or leading) edge of the navigation bar when the receiver is the top navigation item.
    public var leftBarButtonItem: UIBarButtonItem?
    
    /// An array of custom bar button items to display on the right (or trailing) side of the navigation bar when the receiver is the top navigation item.
    public var rightBarButtonItems: [UIBarButtonItem]?
    
    /// A custom bar button item displayed on the right (or trailing) edge of the navigation bar when the receiver is the top navigation item.
    public var rightBarButtonItem: UIBarButtonItem?
    
    public init(title: String) {
        super.init()
        
        self.title = title
    }
    
    // MARK: Integrating Search Into Your Interface
    
    /// The search controller to integrate into your navigation interface.
    public var searchController: UISearchController?
    
    /// A Boolean value indicating whether the integrated search bar is hidden when scrolling any underlying content
    public var hidesSearchBarWhenScrolling: Bool = false
}

public extension UINavigationItem {
    
    /// Sets whether the back button is hidden, optionally animating the transition.
    public func setHidesBackButton(_ hide: Bool, animated: Bool) {
        
    }
    
    
}

//MARK: Customizing Views

public extension UINavigationItem {
    
    /// Sets the left bar button items, optionally animating the transition to the new items.
    func setLeftBarButtonItems(_ leftBarButtonItems: [UIBarButtonItem]?, animated: Bool) {
        
    }
    
    /// Sets the custom bar button item, optionally animating the transition to the new item.
    func setLeftBarButton(_ leftBarButton: UIBarButtonItem?, animated: Bool) {
        
    }
    
    /// Sets the right bar button items, optionally animating the transition to the new items.
    func setRightBarButtonItems(_ rightBarButtonItems: [UIBarButtonItem]?, animated: Bool) {
        
    }
    
    /// Sets the custom bar button item, optionally animating the transition to the view.
    func setRightBarButton(_ rightBarButton: UIBarButtonItem?, animated: Bool) {
        
    }
}

public extension UINavigationItem {
    
    enum LargeTitleDisplayMode {
        
        /// Inherit the display mode from the previous navigation item.
        case automatic
        
        /// Always display a large title.
        case always
        
        /// Never display a large title.
        case never
    }
}
