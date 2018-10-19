//
//  UIOffset.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 10/19/18.
//

import Foundation

/// Defines a structure that specifies an amount to offset a position.
public struct UIOffset {
    
    public var horizontal: CGFloat
    public var vertical: CGFloat
    
    static let zero = UIOffset()
    
    public init(){
        horizontal = 0
        vertical = 0
    }
    
    public init(horizontal: CGFloat, vertical: CGFloat){
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    static func ==(_ o1: UIOffset, _ o2: UIOffset) -> Bool {
        
        return o1.vertical == o2.vertical && o1.horizontal == o2.horizontal
    }
    
    /// Returns a string formatted to contain the data from an offset structure.
    static func string(for: UIOffset) -> String {
        fatalError("not implemented")
    }
    
    /// Returns a UIKit offset structure corresponding to the data in a given string.
    static func uiOffset(for: String) -> UIOffset{
        fatalError("not implemented")
    }
}
