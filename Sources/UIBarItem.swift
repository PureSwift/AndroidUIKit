//
//  UIBarItem.swift
//  Android
//
//  Created by Marco Estrella on 8/31/18.
//

import Foundation

/**
 * An abstract superclass for items that can be added to a bar that appears at the bottom of the screen.
 */
 open class UIBarItem: NSObject {
    
    public var title: String?
    
    public var image: UIImage?
    
    public var landScapeImagePhone: UIImage?
    
    public var largeContentSizeImage: UIImage?
    
    public var imageInsets: UIEdgeInsets! {
        get { return UIEdgeInsets.init() }
    }
    
    public var landscapeImagePhoneInsets: UIEdgeInsets! {
        get { return UIEdgeInsets.init() }
    }
    
    public var isEnabled: Bool = true
    
    public var tag: Int = 0
    
    #if os(iOS)
    public init?(coder: NSCoder) {
        
        return nil
    }
    #endif
    
    /*
    public func setTitleTextAttributes([NSAttributedString.Key : Any]?, for: UIControl.State) {
        
    }
    
    public func titleTextAttributes(for: UIControl.State) -> [NSAttributedString.Key : Any]? {
        
    }
     */
}

public struct UIEdgeInsets {
    
    /// The bottom edge inset value.
    public var bottom: CGFloat
    
    /// The left edge inset value.
    public var left: CGFloat
    
    /// The right edge inset value.
    public var right: CGFloat
    
    /// The top edge inset value.
    public var top: CGFloat
    
    /// Initializes the edge inset struct to default values.
    public init() {
        bottom = 0.0
        left = 0.0
        right = 0.0
        top = 0.0
    }
    
    /// Creates an edge inset for a button or view.
    public init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        
        self.bottom = bottom
        self.left = left
        self.right = right
        self.top = top
    }
}
