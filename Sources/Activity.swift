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
    
    public var reduceHeigthRecyclerView: ( () -> () )?
    public var enlargeRecyclerView: ( () -> () )?
    public var keyBoardHeightGotten: ( (Int) -> () )?
    fileprivate var activityRootView: AndroidView?
    fileprivate var counter = 0
    fileprivate var layoutListener: AndroidViewTreeObserver.OnGlobalLayoutListener?
    fileprivate var r = AndroidRect()
    fileprivate var wasOpened = false
    
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
        
        activityRootView = getActivityRootView()
    }
    
    public override func onResume() {
        
        let app = UIApplication.shared
        app.delegate?.applicationWillEnterForeground(app)
        app.delegate?.applicationDidBecomeActive(app)
        
        registerGlobalLayoutListener()
    }
    
    public override func onPause() {
        
        unregisterGlobalLayoutListener()
        
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
    
    public func showKeyboard(_ view: AndroidView){
        
        let imm = UIApplication.shared.androidActivity.systemService(AndroidInputMethodManager.self)
        imm?.showSoftInput(view: view, flags: AndroidInputMethodManager.SHOW_IMPLICIT)
    }
    
    public func hideKeyboard(_ view: AndroidView){
        
        let imm = UIApplication.shared.androidActivity.systemService(AndroidInputMethodManager.self)
        imm?.hideSoftInputFromWindow(windowToken: view.getWindowToken(), flags: 0)
    }
}

fileprivate extension AndroidUIKitMainActivity {
    
    fileprivate func registerGlobalLayoutListener() {
        
        let softInputMethod = self.window?.attributes?.softInputMode
        
        if AndroidWindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE != softInputMethod &&
            AndroidWindowManager.LayoutParams.SOFT_INPUT_ADJUST_UNSPECIFIED != softInputMethod {
            
            NSLog("Parameter:activity window SoftInputMethod is not ADJUST_RESIZE")
            return
        }
        
        layoutListener = AndroidViewTreeObserver.OnGlobalLayoutListener {
            
            guard let activityRootView = self.activityRootView
                else { return }
            
            activityRootView.getWindowVisibleDisplayFrame(self.r)
            
            let screenHeight = activityRootView.rootView!.getHeight()
            
            let heightDiff = screenHeight - self.r.height()
            NSLog("rv:: OnGlobalLayoutListener: hd: \(heightDiff) = sh: \(screenHeight) - kh: \(self.r.height())")
            let isOpen = Double(heightDiff) > ( Double(screenHeight) * 0.15)
            
            if isOpen == self.wasOpened {
                
                return
            }
            
            self.wasOpened = isOpen
            
            if !isOpen {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.150){
                    
                    self.runOnMainThread {
                        
                        NSLog("rv:: reduceRecycler returning bigger after 0.150")
                        self.enlargeRecyclerView?()
                    }
                }
            } else {
                
                if self.counter == 0 {
                    
                    NSLog("rv:: reduceRecycler: isOpen KBH: \(self.r.height())")
                    self.keyBoardHeightGotten?(self.r.height())
                    self.counter = self.counter + 1
                }
            }
            
            NSLog("rv:: OnGlobalLayoutListener: isOpen: \(isOpen)")
        }
        
        activityRootView?.viewTreeObserver?.addOnGlobalLayoutListener(layoutListener!)
    }
    
    fileprivate func unregisterGlobalLayoutListener() {
        
        guard let layoutListener = layoutListener
            else { return }
        
        activityRootView?.viewTreeObserver?.removeGlobalOnLayoutListener(layoutListener)
    }
    
    private func getActivityRootView() -> AndroidView? {
        
        guard let resources = resources
            else { return nil }
        
        let contentId = resources.getIdentifier(name: "content", type: "id", defPackage: "android")
        
        guard let contentVG = self.findViewById(contentId),
            let viewGroup = AndroidViewGroup(casting: contentVG)
            else { return nil }
        
        return viewGroup.getChildAt(index: 0)
    }
}

internal private(set) weak var _androidActivity: AndroidUIKitMainActivity!
