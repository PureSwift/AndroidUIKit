//
//  UIScreen.swift
//  androiduikittarget
//
//  Created by Alsey Coleman Miller on 7/20/18.
//

import Foundation
import Android
import java_swift

public final class UIScreen {
    
    // MARK: - Initialization
    
    // FIXME: Change to Window
    internal let activity: SwiftSupport.App.AppCompatActivity
    
    fileprivate init(activity: SwiftSupport.App.AppCompatActivity) {
        
        self.activity = activity
        
        assert(activity.javaObject != nil, "Java object not initialized")
        
        updateSize()
        update()
    }
    
    internal static func mainScreen(for activity: SwiftSupport.App.AppCompatActivity) -> UIScreen  {
        
        //assert(_main == nil, "Main screen is already initialized")
        
        let screen = UIScreen(activity: activity)
        
        _main = screen
        
        return screen
    }
    
    public static var screens: [UIScreen] { return [UIScreen.main] }
    
    public static var main: UIScreen {
        
        guard let mainScreen = _main
            else { fatalError("No main screen configured") }
        
        return mainScreen
    }
    
    internal static var _main: UIScreen?
    
    // MARK: - Properties
    
    public var mirrored: UIScreen? { return nil }
    
    // FIXME: Get size from window
    public var bounds: CGRect {
        
        return CGRect(x: 0, y: 0,
                      width: size.width,
                      height: size.height)
    }
    
    public var nativeBounds: CGRect {
        
        return CGRect(x: 0, y: 0,
                      width: bounds.size.width * scale,
                      height: bounds.size.height * scale)
    }
    
    public private(set) var scale: CGFloat = 1.0
    
    public var nativeScale: CGFloat { return scale }
    
    public var maximumFramesPerSecond: Int {
        
        return 60
    }
    
    private var size: CGSize = .zero { didSet { sizeChanged() } }
    
    internal var needsLayout: Bool = true
    internal var needsDisplay: Bool = true
    
    /// Children windows
    private var _windows = WeakArray<UIWindow>()
    internal var windows: [UIWindow] { return _windows.values() }
    
    internal private(set) weak var keyWindow: UIWindow?
    
    // MARK: - Methods
    
    internal func addWindow(_ window: UIWindow) {
        
        _windows.append(window)
        
        // add view in Android
        activity.setContentView(view: window.androidView)
    }
    
    internal func setKeyWindow(_ window: UIWindow) {
        
        guard UIScreen.main.keyWindow !== self
            else { return }
        
        if windows.contains(where: { $0 === window }) == false {
            
            addWindow(window)
        }
        
        keyWindow?.resignKey()
        keyWindow = window
        keyWindow?.becomeKey()
    }
    
    internal func updateSize() {
        
        var androidDensity: Float = 0.0
        var androidHeightPixels = 0
        var androidWidthPixels = 0
        var androidStatusBarHeightPixels = 0
        
        let displayMetrics = AndroidDisplayMetrics()
        
        activity.windowManager?.defaultDisplay?.getMetrics(outMetrics: displayMetrics)
        
        androidDensity = displayMetrics.density
        androidHeightPixels = displayMetrics.heightPixels // status bar + content
        androidWidthPixels = displayMetrics.widthPixels
        androidStatusBarHeightPixels = activity.statusBarHeightPixels

        let size: CGSize
        
        if androidHeightPixels > 0 && androidStatusBarHeightPixels > 0 {
            
            let activityHeightPixels = androidHeightPixels - androidStatusBarHeightPixels //subtract status bar height
            
            let androidWidthDp = Float(androidWidthPixels)/androidDensity
            let androidHeightDp = Float(activityHeightPixels)/androidDensity
            
            size = CGSize(width: CGFloat(androidWidthDp),
                          height: CGFloat(androidHeightDp))
        } else {
            
            size = .zero
        }
        
        self.size = size
        self.scale = CGFloat(androidDensity)
        self.needsLayout = true
        self.needsDisplay = true
    }
    
    /// Layout (if needed) and redraw the screen
    internal func update() {
        
        /*
        // apply animations
        if UIView.animations.isEmpty == false {
            
            needsDisplay = true
            needsLayout = true
            
            UIView.animations = UIView.animations.filter { $0.frameChange() }
        }*/
        
        // layout views
        if needsLayout {
            
            defer { needsLayout = false }
            
            windows.forEach { $0.layoutIfNeeded() }
            
            needsDisplay = true // also render views
        }
        /*
        // render views
        if needsDisplay {
            
            defer { needsDisplay = false }
        }*/
        
        needsDisplay = false
    }
    
    private func sizeChanged() {
        
        // update windows
        windows.forEach { $0.frame = CGRect(origin: .zero, size: size) }
        
        needsDisplay = true
        needsLayout = true
    }
}
