//
//  CGFloatExtension.swift
//  Android
//
//  Created by Marco Estrella on 8/27/18.
//

import Foundation

internal extension CGFloat {
    
    static func applyDP(pixels: Int, screen: UIScreen = UIScreen.main) -> CGFloat {
        
        let xDp = CGFloat(pixels) / screen.scale
        
        return xDp
    }
}
