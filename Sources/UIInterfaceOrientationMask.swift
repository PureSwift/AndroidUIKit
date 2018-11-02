//
//  UIInterfaceOrientationMask.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 10/31/18.
//

import Foundation

public struct UIInterfaceOrientationMask: OptionSet, RawRepresentable, Equatable {
    public let rawValue: Int
    
    public init(rawValue: Int){
        self.rawValue = rawValue
    }
    
    public static var portrait    = UIInterfaceOrientationMask(rawValue: 1 << 0)
    public static var landscapeLeft  = UIInterfaceOrientationMask(rawValue: 1 << 1)
    public static var landscapeRight   = UIInterfaceOrientationMask(rawValue: 1 << 2)
    public static var portraitUpsideDown   = UIInterfaceOrientationMask(rawValue: 1 << 3)
    public static var landscape   = UIInterfaceOrientationMask(rawValue: 1 << 4)
    
    public static var all: UIInterfaceOrientationMask = [.portrait, .landscapeLeft, .landscapeRight, .portraitUpsideDown, .landscape]
    
    public static var allButUpsideDown: UIInterfaceOrientationMask = [.portrait, .landscapeLeft, .landscapeRight, .landscape]
}
