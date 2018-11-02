//
//  UIInterfaceOrientation.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 10/31/18.
//

import Foundation

public enum UIInterfaceOrientation: Int {
    
    var isLandscape: Bool {
        
        switch self {
            
        case .portrait: return false
        case .landscapeLeft: return true
        case .landscapeRight: return true
        case .portraitUpsideDown: return false
        case .unknown: return false
        }
    }
    
    var isPortrait: Bool  {
        
        switch self {
            
        case .portrait: return true
        case .landscapeLeft: return false
        case .landscapeRight: return false
        case .portraitUpsideDown: return true
        case .unknown: return false
        }
    }
    
    case unknown = 0
    case portrait = 1
    case portraitUpsideDown = 2
    case landscapeLeft = 4
    case landscapeRight = 3
}
