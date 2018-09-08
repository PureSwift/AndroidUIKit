//
//  CGFloatExtension.swift
//  Android
//
//  Created by Marco Estrella on 8/21/18.
//

import Foundation

internal extension CGRect {
    
    func applyingDP(screen: UIScreen = UIScreen.main) -> CGRect {
        
        let xDp = minX * screen.scale
        let yDp = minY * screen.scale
        let widthDp = width * screen.scale
        let heightDp = height * screen.scale
        
        return CGRect(x: xDp, y: yDp, width: widthDp, height: heightDp)
    }
}
