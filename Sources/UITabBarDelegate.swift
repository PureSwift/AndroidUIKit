//
//  UITabBarDelegate.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 10/19/18.
//

import Foundation

/**
 The UITabBarDelegate protocol defines optional methods for a delegate of a UITabBar object.
 The UITabBar class provides the ability for the user to reorder, remove, and add items
 to the tab bar; this process is referred to as customizing the tab bar. The tab bar
 delegate receives messages when customizing occurs.
 */
public protocol UITabBarDelegate: class {
    
    /// Sent to the delegate before the customizing modal view is displayed.
    func tabBar(_ uiTableBar: UITabBar, willBeginCustomizing: [UITabBarItem])
    
    /// Sent to the delegate after the customizing modal view is displayed.
    func tabBar(_ uiTableBar: UITabBar, didBeginCustomizing: [UITabBarItem])
    
    /// Sent to the delegate before the customizing modal view is dismissed.
    func tabBar(_ uiTableBar: UITabBar, willEndCustomizing: [UITabBarItem], changed: Bool)
    
    /// Sent to the delegate after the customizing modal view is dismissed.
    func tabBar(_ uiTableBar: UITabBar, didEndCustomizing: [UITabBarItem], changed: Bool)
    
    /// Sent to the delegate when the user selects a tab bar item.
    func tabBar(_ uiTableBar: UITabBar, didSelect: UITabBarItem)
}
