//
//  UITabBarControllerDelegate.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 10/31/18.
//

import Foundation

public protocol UITabBarControllerDelegate {
    
    // Managing Tab Bar Selections
    
    /// Asks the delegate whether the specified view controller should be made active.
    func tabBarController(_ uiTabBatController: UITabBarController, shouldSelect: UIViewController) -> Bool
    
    /// Tells the delegate that the user selected an item in the tab bar.
    func tabBarController(_ uiTabBatController: UITabBarController, didSelect: UIViewController)
    
    // Managing Tab Bar Customizations
    
    /// Tells the delegate that the tab bar customization sheet is about to be displayed.
    func tabBarController(_ uiTabBatController: UITabBarController, willBeginCustomizing: [UIViewController])
    
    /// Tells the delegate that the tab bar customization sheet is about to be dismissed.
    func tabBarController(_ uiTabBatController: UITabBarController, willEndCustomizing: [UIViewController], changed: Bool)
    
    /// Tells the delegate that the tab bar customization sheet was dismissed.
    func tabBarController(_ uiTabBatController: UITabBarController, didEndCustomizing: [UIViewController], changed: Bool)
    
    // Overriding View Rotation Settings
    
    /// Called to allow the delegate to provide the complete set of supported interface orientations for the tab bar controller.
    func tabBarControllerSupportedInterfaceOrientations(_ uiTabBatController: UITabBarController) -> UIInterfaceOrientationMask
    
    /// Called to allow the delegate to provide the preferred orientation for presentation of the tab bar controller.
    func tabBarControllerPreferredInterfaceOrientationForPresentation(_ uiTabBatController: UITabBarController) -> UIInterfaceOrientation
    
    // Supporting Custom Tab Bar Transition Animations
    
    /// Called to allow the delegate to return a UIViewControllerAnimatedTransitioning delegate object for use during a noninteractive tab bar view controller transition.
    //func tabBarController(_ uiTabBatController: UITabBarController, animationControllerForTransitionFrom: UIViewController, to: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
    /// Called to allow the delegate to return a UIViewControllerInteractiveTransitioning delegate object for use during an animated tab bar transition.
    //func tabBarController(_ uiTabBatController: UITabBarController, interactionControllerFor: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
}
