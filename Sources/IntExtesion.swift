//
//  ExpressibleByIntegerLiteralExtesion.swift
//  Android
//
//  Created by Marco Estrella on 8/20/18.
//

import Foundation

internal extension Int {
    internal static func random() -> Int {
        return Int(arc4random_uniform(UInt32(Int.max))+1)
    }
}
