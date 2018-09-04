//
//  UIBarButtonItem.swift
//  Android
//
//  Created by Marco Estrella on 8/31/18.
//

import Foundation
import Android

/// A button specialized for placement on a toolbar or tab bar.
open class UIBarButtonItem: UIBarItem {
    
    public var target: Any?
    
    #if os(iOS)
    public var action: Selector?
    #else
    public var action: (() -> ())?
    #endif
    public var style: UIBarButtonItem.Style?
    
    public var possibleTitles: Set<String>?
    
    public var width: CGFloat!
    
    public var customView: UIView?
    
    public var tintColor: UIColor?
    
    internal lazy var androidMenuItemId: Int = { [unowned self] in
       return AndroidViewCompat.generateViewId()
    }()
    
    public init(customView: UIView) {
        super.init()
        
        self.customView = customView
    }
    
    #if os(iOS)
    public init(barButtonSystemItem: UIBarButtonItem.SystemItem, target: Any?, action: Selector?) {
        super.init()
        
        self.target = target
        self.action = action
    }
    
    public init(title: String?, style: UIBarButtonItem.Style, target: Any?, action: Selector?) {
        super.init()
        
        self.title = title
        self.style = style
        self.action = action
    }
    #else
    public init(title: String?, style: UIBarButtonItem.Style, target: Any?, action: (() -> ())?) {
        super.init()
        
        self.title = title
        self.style = style
        self.action = action
    }
    #endif
}

public extension UIBarButtonItem {
    
    enum Style {
        
        /// Glows when tapped. The default item style.
        case plain
        
        /// (Deprecated) A simple button style with a border.
        case bordered
        
        /// The style for a done button—for example, a button that completes some task and returns to the previous view.
        case done
    }
    
    enum SystemItem {
        
        /// The system Done button. Localized.
        case done
        
        /// The system Cancel button. Localized.
        case cancel
        
        /// The system Edit button. Localized.
        case edit
        
        /// The system Save button. Localized.
        case save
        
        /// The system plus button containing an icon of a plus sign.
        case add
        
        /// Blank space to add between other items. The space is distributed equally between the other items. Other item properties are ignored when this value is set.
        case flexibleSpace
        
        /// Blank space to add between other items. Only the `width` property is used when this value is set.
        case fixedSpace
        
        /// The system compose button.
        case compose
        
        /// The system reply button.
        case reply
        
        /// The system action button.
        case action
        
        /// The system organize button.
        case organize
        
        /// The system bookmarks button.
        case bookmarks
        
        /// The system search button.
        case search
        
        /// The system refresh button.
        case refresh
        
        /// The system stop button.
        case stop
        
        /// The system camera button.
        case camera
        
        /// The system trash button.
        case trash
        
        /// The system play button.
        case play
        
        /// The system pause button.
        case pause
        
        /// The system rewind button.
        case rewind
        
        /// The system fast forward button.
        case fastForward
        
        /// The system undo button.
        case undo
        
        /// The system redo button.
        case redo
    }
}
