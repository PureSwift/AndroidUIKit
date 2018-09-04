//
//  UINavigationControllerDelegate.swift
//  androiduikittarget
//
//  Created by Marco Estrella on 8/23/18.
//

import Foundation

public protocol UINavigationControllerDelegate: class {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
}

public extension UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) { }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) { }
}
