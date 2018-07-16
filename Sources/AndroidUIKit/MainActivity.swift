//
//  MsinActivity.swift
//  AndroidUIKit
//
//  Created by Carlos Duclos on 7/13/18.
//

#if os(iOS)

import UIKit

class MainViewController: UIViewController {
    
}

#else

import Foundation
import java_swift
import java_lang
import java_util
import Android

// Like AppDelegate in iOS
final class MainActivity: SwiftSupportAppCompatActivity {
    
    var rootView: Android.View.SwiftView!
    
    override func onCreate(savedInstanceState: Android.OS.Bundle?) {
        
        rootView = Android.View.SwiftView(context: UIApplication.context!)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        rootView.addView(view.androidView)
        
        setContentView(view: rootView)
    }
    
}

#endif


