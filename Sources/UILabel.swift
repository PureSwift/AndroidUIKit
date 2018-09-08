//
//  UILabel.swift
//  Android
//
//  Created by Marco Estrella on 8/15/18.
//

import Foundation
import Android
import java_swift

open class UILabel: UIView {
    
    // MARK: - Initialization
    
    internal lazy private(set) var androidTextView: AndroidTextView = { [unowned self] in
        
        guard let context = AndroidContext(casting: UIScreen.main.activity)
            else { fatalError("Missing context") }
        
        let textview = AndroidTextView(context: context)
        
        textview.color = UIColor.black.androidColor.color
        
        return textview
    }()
    
    //internal var androidTextView: AndroidTextView?
    
    internal let androidTextViewId = Int.random()
    
    public var text: String? {
        set {
            androidTextView.text = newValue
        }
        get {
            return androidTextView.text
        }
    }
    
    public var textColor: UIColor! {
        set {
            androidTextView.color = newValue.androidColor.color
        }
        get {
            return UIColor.init(color: androidTextView.color)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLog("\((type: self)) \(#function) ")
        // disable user interaction
        //self.isUserInteractionEnabled = false
        
        androidTextView.setId(androidTextViewId)
        
        let frameDp = frame.applyingDP()
        
        // set origin
        androidTextView.setX(x: Float(frameDp.minX))
        androidTextView.setY(y: Float(frameDp.minY))
        
        // set size
        androidTextView.layoutParams = AndroidViewGroupLayoutParams(width: Int(frameDp.width), height: Int(frameDp.height))
    }
}
