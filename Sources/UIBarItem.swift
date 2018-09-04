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
    
    /*
    public var image: UIImage?
    
    public var landScapeImagePhone: UIImage?
    
    public var largeContentSizeImage: UIImage?
    
    public var imageInsets: UIEdgeInsets!
    
    public var landscapeImagePhoneInsets: UIEdgeInsets!
    */
    
    var isEnabled: Bool!
    
    var tag: Int!
    
    public override init(){
        
    }
    
    public init?(coder: NSCoder) {
        
        return nil
    }
    
    /*
    public func setTitleTextAttributes([NSAttributedString.Key : Any]?, for: UIControl.State) {
        
    }
    
    public func titleTextAttributes(for: UIControl.State) -> [NSAttributedString.Key : Any]? {
        
    }
     */
}
