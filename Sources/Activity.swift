//
//  Activity.swift
//  AndroidUIKit
//
//  Created by Alsey Coleman Miller on 9/7/18.
//

import Foundation
import Android
import java_swift
import CoreFoundation

public final class AndroidUIKitMainActivity: SwiftSupportAppCompatActivity {
    
    public lazy var screen: UIScreen = UIScreen.mainScreen(for: self)
    
    public required init(javaObject: jobject?) {
        super.init(javaObject: javaObject)
        
        // store a singleton reference
        _androidActivity = self
    }
    
    public override func onCreate(savedInstanceState: Android.OS.Bundle?) {
        
        #if os(Android)
        //DispatchQueue.drainingMainQueue = true
        #endif
        
        // load app
        let app = UIApplication.shared
        
        // load screen
        let _ = screen
        
        guard let delegate = app.delegate
            else { assertionFailure("Missing UIApplicationDelegate"); return }
        
        // Tells the delegate that the launch process has begun but that state restoration has not yet occurred.
        if delegate.application(app, willFinishLaunchingWithOptions: nil) == false {
            
            
        }
        
        if delegate.application(app, didFinishLaunchingWithOptions: nil) == false {
            
            
        }
        
        drainMainQueue()
    }
    
    public override func onResume() {
        
        let app = UIApplication.shared
        app.delegate?.applicationWillEnterForeground(app)
        app.delegate?.applicationDidBecomeActive(app)
    }
    
    public override func onPause() {
        
        let app = UIApplication.shared
        
        if isFinishing() {
            
            //app.delegate?.applicationWillTerminate(app)
            
        } else {
            
            app.delegate?.applicationWillResignActive(app)
        }
    }
    
    public override func onStop() {
        
        let app = UIApplication.shared
        app.delegate?.applicationDidEnterBackground(app)
    }
    
    internal var backButtonAction: ( () -> () )?
    
    public override func onBackPressed() {
        
        if let action = backButtonAction {
            
            action()
        } else {
            
            finish()
        }
    }
    
    public override func onActivityResult(requestCode: Int, resultCode: Int, data: Android.Content.Intent?) {
        
        let app = UIApplication.shared
        app.delegate?.application(app, activityResult: requestCode, resultCode: resultCode, data: data)
    }
    
    public override func onRequestPermissionsResult(requestCode: Int, permissions: [String], grantResults: [Int]) {
        
        let app = UIApplication.shared
        app.delegate?.application(app, requestPermissionsResult: requestCode, permissions: permissions, grantResults: grantResults)
    }
    
    /// call from main thread in Java periodically
    private func drainMainQueue() {
        
        #if os(Android)
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true)
        #endif
    }
}

internal private(set) weak var _androidActivity: AndroidUIKitMainActivity!
