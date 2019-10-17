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
        textview.gravity = AndroidGravity.startCenterVertical.rawValue
        textview.color = UIColor.black.androidColor.color
        
        return textview
        }()
    
    //internal var androidTextView: AndroidTextView?
    
    internal let androidTextViewId = AndroidViewCompat.generateViewId()
    
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
    
    /// The technique to use for aligning the text.
    public var textAlignment: NSTextAlignment {
        get {
            return .left
        }
        set{
            
            androidTextView.gravity = getGravityFromNSTextAlignment(newValue)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        NSLog("\(Swift.type(of: self)) \(#function) ")
        // disable user interaction
        //self.isUserInteractionEnabled = false
        
        androidTextView.setId(androidTextViewId)
        updateTextViewFrame()
        
        androidView.addView(androidTextView)
    }
    
    override func updateAndroidViewSize() {
        super.updateAndroidViewSize()
        
        updateTextViewFrame()
    }
    
    private func updateTextViewFrame() {
        
        let frameDp = frame.applyingDP()
        
        // set origin
        androidTextView.setX(x: Float(frameDp.minX))
        androidTextView.setY(y: Float(frameDp.minY))
        
        // set size
        androidTextView.layoutParams = AndroidViewGroupLayoutParams(width: Int(frameDp.width), height: Int(frameDp.height))
        
    }
    
    private func getGravityFromNSTextAlignment(_ textAlignment: NSTextAlignment) -> Int {
        
        switch textAlignment {
        case NSTextAlignment.left:
            return AndroidGravity.startCenterVertical.rawValue
        case NSTextAlignment.right:
            return AndroidGravity.endCenterVertical.rawValue
        case NSTextAlignment.center:
            return AndroidGravity.center.rawValue
        default:
            return AndroidGravity.startCenterVertical.rawValue
        }
    }
    
    private func getNSTextAlignmentFromGravity(_ gravity: AndroidGravity) -> NSTextAlignment {
        
        switch gravity {
        case AndroidGravity.startCenterVertical:
            return NSTextAlignment.left
        case AndroidGravity.endCenterVertical:
            return NSTextAlignment.right
        case AndroidGravity.center:
            return NSTextAlignment.center
        default:
            return NSTextAlignment.left
        }
    }
}

/// These constants specify text alignment.
public enum NSTextAlignment {
    
    /// Text is visually left aligned.
    case left
    
    /// Text is visually right aligned.
    case right
    
    /// Text is visually center aligned.
    case center
    
    /// Text is justified.
    case justified
    
    /// Use the default alignment associated with the current localization of the app.
    /// The default alignment for left-to-right scripts is NSTextAlignment.left,
    /// and the default alignment for right-to-left scripts is NSTextAlignment.right.
    case natural
}


