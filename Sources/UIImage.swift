//
//  UIImage.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 10/17/18.
//

import Foundation
import Android

public class UIImage {
    
    internal private(set) var androidDrawableId: Int?
    
    public init(named: String) {
        
        androidDrawableId = UIApplication.shared.androidActivity.getIdentifier(name: named, type: "drawable")
    }
}
