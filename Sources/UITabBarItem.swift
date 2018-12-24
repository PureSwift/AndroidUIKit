//
//  UITabBarItem.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 10/19/18.
//

import Foundation
import Android

/**
 * A tab bar operates strictly in radio mode, where one item is selected at a time—tapping a tab bar item
 * toggles the view above the tab bar. You can also specify a badge value on the tab bar item for adding additional
 * visual information—for example, the Messages app uses a badge on the item to show the number of new messages.
 * This class also provides a number of system defaults for creating items.
 */
open class UITabBarItem: UIBarItem {
    
    internal var androidId: Int!
    
    public var selectedImage: UIImage?
    
    public var titlePositionAdjustment = UIOffset.zero
    
    public var badgeValue: String?
    
    public var badgeColor: UIColor?
    
    internal var position: Int = 0
    
    public override init() {
        super.init()
        
        androidId = AndroidViewCompat.generateViewId()
    }
    
    public convenience init(tabBarSystemItem: UITabBarItem.SystemItem, tag: Int) {
        
        self.init()
        self.tag = tag
        
        //FIXME: set image according `tabBarSystemItem`
    }
    
    /// Creates and returns a new item using the specified properties.
    public convenience init(title: String?, image: UIImage?, tag: Int = -1) {
        
        self.init()
        self.title = title
        self.image = image
        self.tag = tag
        self.position = tag
    }
    
    /// Creates and returns a new item with the specified title, unselected image, and selected image.
    public convenience init(title: String?, image: UIImage?, selectedImage: UIImage?) {
        
        self.init()
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
    }
}

// MARK: UITabBarItem

public extension UITabBarItem {
    
    public enum SystemItem: Int {
        
        /// The more system item.
        case more = 0
        
        /// The favorites system item.
        case favorites = 1
        
        /// The featured system item.
        case featured = 2
        
        /// The top rated system item.
        case topRated = 3
        
        /// The recents system item.
        case recents = 4
        
        /// The contacts system item.
        case contacts = 5
        
        /// The history system item.
        case history = 6
        
        /// The bookmarks system item.
        case bookmarks = 7
        
        /// The search system item.
        case search = 8
        
        /// The downloads system item.
        case downloads = 9
        
        /// The most recent system item.
        case mostRecent = 10
        
        /// The most viewed system item
        case mostViewed = 11
    }
}
