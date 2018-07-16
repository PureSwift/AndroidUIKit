//
//  UIView.swift
//  AndroidUIKit
//
//  Created by Carlos Duclos on 7/13/18.
//

import Foundation
import Android

open class UIView {
    
    internal var androidView: Android.View.SwiftView!
    
    open var frame: CGRect {
        get { return _frame }
        set {
            _frame = newValue
            _bounds.size = newValue.size
        }
    }
    
    public final var bounds: CGRect {
        get { return _bounds }
        set {
            _bounds = newValue
            _frame.size = newValue.size
        }
    }
    
    private var _bounds = CGRect()
    
    private var _frame = CGRect()
    
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    public init(frame: CGRect) {
        
        self.frame = frame
        
        androidView = Android.View.SwiftView(context: UIApplication.context!)
        androidView.x = Float(frame.minX)
        androidView.y = Float(frame.minY)
        androidView.layoutParams = Android.View.ViewParamsLayout(width: Int(frame.width), height: Int(frame.height))
    }
    
    func addSubview(_ view: UIView) {
        
        androidView.addView(view.androidView)
    }
    
}
