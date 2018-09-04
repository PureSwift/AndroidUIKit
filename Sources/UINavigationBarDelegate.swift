//
//  UINavigationBarDelegate.swift
//  androiduikittarget
//
//  Created by Alsey Coleman Miller on 8/23/18.
//

/***
 * The UINavigationBarDelegate protocol defines optional methods that a
 * UINavigationBar delegate should implement to update its views when
 * items are pushed and popped from the stack. The navigation bar represents
 * only the bar at the top of the screen, not the view below. It’s the application’s
 * responsibility to implement the behavior when the top item changes.
 */
public protocol UINavigationBarDelegate: class {
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool
    
    func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem)
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool
    
    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem)
}

public extension UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool  {
        
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        
        
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        
        
    }
}
