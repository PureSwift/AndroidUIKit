//
//  CGFloatExtension.swift
//  Android
//
//  Created by Marco Estrella on 8/21/18.
//

import Foundation

internal extension CGRect {
    
    static func applyDP(rect: CGRect, screen: UIScreen = UIScreen.main) -> CGRect {
        
        let xDp = rect.minX * screen.scale
        let yDp = rect.minY * screen.scale
        let widthDp = rect.width * screen.scale
        let heightDp = rect.height * screen.scale
        
        return CGRect.init(x: xDp, y: yDp, width: widthDp, height: heightDp)
    }
}
