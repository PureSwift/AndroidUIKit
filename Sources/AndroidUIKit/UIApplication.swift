//
//  UIApplication.swift
//  AndroidUIKit
//
//  Created by Carlos Duclos on 7/13/18.
//

import Foundation
import java_swift
import java_lang
import java_util
import Android

// Like AppDelegate in iOS
final class UIApplication: SwiftApplication {
    
    public static var context: Android.Content.Context?
    
    override func onCreate() {
        NSLog("SwiftDemoApplication \(#function)")
        
        UIApplication.context = Android.Content.Context.init(casting: self)
    }
}
