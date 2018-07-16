//
//  AppDelegate.swift
//  AndroidUIKitDemo
//
//  Created by Carlos Duclos on 7/12/18.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#else
    
#endif

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    static let shared = AppDelegate()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = FrameViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        print("Will close app")
    }
}
