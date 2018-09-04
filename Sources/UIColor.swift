//
//  UIColor.swift
//  Android
//
//  Created by Marco Estrella on 7/17/18.
//

import Foundation
import Android

public final class UIColor {
    
    // MARK: - Properties
    
    internal let androidColor: Android.Graphics.Drawable.ColorDrawable
    
    //public let cgColor: CGColor
    
    // MARK: - Initialization
    
    internal init(androidColor: Android.Graphics.Drawable.ColorDrawable) {
        
        self.androidColor = androidColor
    }
    
    internal init(color: Int64) {
        
        self.androidColor = Android.Graphics.Drawable.ColorDrawable(color: color)
    }
    
    /*
    public init(cgColor color: CGColor) {
        
        self.cgColor = color
    }*/
    
    /// An initialized color object. The color information represented by this object is in the device RGB colorspace.
    public init(red: CGFloat,
                green: CGFloat,
                blue: CGFloat,
                alpha: CGFloat = 1.0) {
        
        let color = Android.Graphics.Color.argb(alpha: Float(alpha), red: Float(red), green: Float(green), blue: Float(blue))
        
        self.androidColor = Android.Graphics.Drawable.ColorDrawable(color: color)
    }
    
    public static let black = UIColor(color: Android.Graphics.Color.BLACK)
    
    public static let blue = UIColor(color: Android.Graphics.Color.BLUE)
    
    public static let brown = UIColor(color: Android.Graphics.Color.argb(alpha: 1.0, red: 0.6, green: 0.4, blue: 0.2))
    
    public static let clear = UIColor(color: Android.Graphics.Color.TRANSPARENT)
    
    public static let cyan = UIColor(color: Android.Graphics.Color.CYAN)
    
    public static let darkGray = UIColor(color: Android.Graphics.Color.DKGRAY)
    
    public static let gray = UIColor(color: Android.Graphics.Color.GRAY)
    
    public static let green = UIColor(color: Android.Graphics.Color.GREEN)
    
    public static let lightGray = UIColor(color: Android.Graphics.Color.LTGRAY)
    
    public static let magenta = UIColor(color: Android.Graphics.Color.argb(alpha: 1.0, red: 1.0, green: 0.0, blue: 1.0))
    
    public static let orange = UIColor(color: Android.Graphics.Color.argb(alpha: 1.0, red: 1.0, green: 0.65, blue: 0.0))
    
    public static let purple = UIColor(color: Android.Graphics.Color.argb(alpha: 1.0, red: 0.5, green: 0.0, blue: 0.5))
    
    public static let red = UIColor(color: Android.Graphics.Color.RED)
    
    public static let white = UIColor(color: Android.Graphics.Color.WHITE)
    
    public static let yellow = UIColor(color: Android.Graphics.Color.YELLOW)
}
