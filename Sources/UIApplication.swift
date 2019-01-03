//
//  UIApplication.swift
//  AndroidUIKit
//
//  Created by Alsey Coleman Miller on 7/20/18.
//

import Foundation
import java_swift
import java_lang
import java_util
import Android

public final class AndroidUIKitApplication: SwiftApplication {
    
    public required init(javaObject: jobject?) {
        super.init(javaObject: javaObject)
        
        // store a singleton reference
        _androidContext = self
    }
}

internal private(set) weak var _androidContext: AndroidUIKitApplication!

internal let _UIApp = UIApplication()

public final class UIApplication: UIResponder {
    
    fileprivate override init() {
        
        super.init()
    }
    
    // MARK: - Android
    
    public var androidApplication: AndroidUIKitApplication {
        
        return _androidContext
    }
    
    public var androidActivity: AndroidUIKitMainActivity {
        
        return _androidActivity
    }
    
    // MARK: - Getting the App Instance
    
    public static var shared: UIApplication { return _UIApp }
    
    // MARK: - Getting the App Delegate
    
    public var delegate: UIApplicationDelegate?
    
    // MARK: - Getting App Windows
    
    /// The app's key window.
    public var keyWindow: UIWindow? { return keyWindow(for: UIScreen.main) }
    
    /// The app's visible and hidden windows.
    public var windows: [UIWindow] { return UIScreen.screens.reduce([UIWindow](), { $0 + $1.windows }) }
    
    // MARK: - Controlling and Handling Events
    
    /// Dispatches an event to the appropriate responder objects in the app.
    ///
    /// - Parameter event: A UIEvent object encapsulating the information about an event, including the touches involved.
    ///
    /// If you require it, you can intercept incoming events by subclassing UIApplication and overriding this method.
    /// For every event you intercept, you must dispatch it by calling super`sendEvent()`
    /// after handling the event in your implementation.
    public func sendEvent(_ event: UIEvent) {
        
        self.windows.forEach { $0.sendEvent(event) }
    }
    
    public func sendAction(_ selector: String,
                           to target: AnyObject?,
                           from sender: AnyObject?,
                           for event: UIEvent?) {
        
        
    }
    
    public func beginIgnoringInteractionEvents() {
        
        isIgnoringInteractionEvents = true
    }
    
    public func endIgnoringInteractionEvents() {
        
        isIgnoringInteractionEvents = false
    }
    
    public private(set) var isIgnoringInteractionEvents: Bool = false
    
    public var applicationSupportsShakeToEdit: Bool { return false }
    
    // MARK: - Managing Background Execution
    
    public fileprivate(set) var applicationState: UIApplicationState = .active
    
    // MARK: - Private
    
    private func keyWindow(for screen: UIScreen) -> UIWindow? {
        
        return screen.keyWindow
    }
    
    private func sendHeadsetOriginatedMediaRemoteCommand() {
        
        
    }
    
    private func sendWillEnterForegroundCallbacks() {
        
        
    }
    
    // Scroll to top
    private func scrollsToTopInitiatorView() {
        
        
    }
    
    private func shouldAttemptOpenURL() {  }
    
    private var isRunningInTaskSwitcher: Bool = false
    /*
     public override func wheelChanged(with event: UIWheelEvent) {
     
     super.wheelChanged(with: event)
     }
     
     internal func sendButtonEvent(with pressInfo: UIPressInfo) {
     
     
     }
     
     internal func handlePhysicalButtonEvent(_ event: UIPhysicalKeyboardEvent) {
     
     
     }
     */
    public override func becomeFirstResponder() -> Bool {
        
        return keyWindow?.becomeFirstResponder() ?? false
    }
    
    
}

// MARK: - Supporting Types

public protocol UIApplicationDelegate: AndroidApplicationDelegate {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool
    
    func applicationDidBecomeActive(_ application: UIApplication)
    
    func applicationDidEnterBackground(_ application: UIApplication)
    
    func applicationWillResignActive(_ application: UIApplication)
    
    func applicationWillEnterForeground(_ application: UIApplication)
    
    func applicationWillTerminate(_ application: UIApplication)
}

// Default implementations
public extension UIApplicationDelegate {
    
    // Tells the delegate that the launch process has begun but that state restoration has not yet occurred.
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool { return true }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool { return true }
    
    func applicationDidBecomeActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) { }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationWillTerminate(_ application: UIApplication) { }
}

public protocol AndroidApplicationDelegate: class {
    
    func application(_ application: UIApplication, requestPermissionsResult requestCode: Int, permissions: [String], grantResults: [Int])
    
    func application(_ application: UIApplication, activityResult requestCode: Int, resultCode: Int, data: Android.Content.Intent?)
}

public extension AndroidApplicationDelegate {
    
    func application(_ application: UIApplication, requestPermissionsResult requestCode: Int, permissions: [String], grantResults: [Int]) { }
    
    func application(_ application: UIApplication, activityResult requestCode: Int, resultCode: Int, data: Android.Content.Intent?) { }
}

public enum UIApplicationState: Int {
    
    case active
    case inactive
    case background
}

public struct UIApplicationLaunchOptionsKey: RawRepresentable {
    
    public let rawValue: String
    
    public init?(rawValue: String) {
        
        self.rawValue = rawValue
    }
}

extension UIApplicationLaunchOptionsKey: Equatable {
    
    public static func == (lhs: UIApplicationLaunchOptionsKey, rhs: UIApplicationLaunchOptionsKey) -> Bool {
        
        return lhs.rawValue == rhs.rawValue
    }
}

extension UIApplicationLaunchOptionsKey: Hashable {
    
    public var hashValue: Int {
        
        return rawValue.hashValue
    }
}
