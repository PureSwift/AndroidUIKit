//
//  UIButton.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 12/7/18.
//

import Foundation
import Android
import java_swift

open class UIButton: UIView {
    
    internal lazy private(set) var androidButton: AndroidButton = { [unowned self] in
        
        guard let context = AndroidContext(casting: UIScreen.main.activity)
            else { fatalError("Missing context") }
        
        let button = AndroidButton(context: context)
        
        return button
        }()
    
    public var buttonType: UIButton.ButtonType = .plain
    public var currentTitle: String? {
        
        didSet {
            
            androidButton.text = currentTitle
        }
    }
    
    public var currentTitleColor: UIColor? {
        
        didSet {
            //
        }
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        androidView.addView(androidButton)
    }
    
    public convenience init(type: UIButton.ButtonType){
        
        self.init(frame: .zero)
        self.buttonType = type
    }
    
    public func title(for state: UIControlState) -> String? {
        
        return currentTitle
    }
    
    public func setTitle(_ title: String?, for state: UIControlState){
        
        currentTitle = title
    }
    
    public func setTitleColor(_ titleColor: UIColor?, for state: UIControlState) {
        
        currentTitleColor = titleColor
    }
    
    /*public final var backgroundColor: UIColor? {
     get {
     guard let bg = androidButton.background
     else { return nil }
     
     guard let bgColor = bg as? Android.Graphics.Drawable.ColorDrawable
     else { return nil }
     
     return UIColor(androidColor: bgColor)
     }
     set {
     androidButton.background = newValue?.androidColor
     }
     }*/
    open override func updatedBackgroundColor() {
        
        androidButton.background = backgroundColor?.androidColor
    }
    
    private func updateAndroidButtonLayoutFrame(){
        
        let frameDp = frame.applyingDP()
        
        // set origin
        androidButton.setX(x: Float(frameDp.minX))
        androidButton.setY(y: Float(frameDp.minY))
        
        // set size
        let widthDp = Int(frameDp.width)
        let heightDp = Int(frameDp.height)
        NSLog("\(type(of: self)) \(#function) widthDp: \(widthDp) - heightDp: \(heightDp)")
        androidButton.layoutParams = AndroidFrameLayoutLayoutParams(width: widthDp, height: heightDp)
    }
    
    public func addTarget(action: @escaping () -> (), for event: UIControlEvents) {
        
        androidButton.setOnClickListener {
            action()
        }
    }
    
    public func removeTarget(actionId: UInt, for event: UIControlEvents) {
        
        androidButton.setOnClickListener(nil)
    }
}

public extension UIButton {
    
    public enum ButtonType : Int {
        
        // No button style.
        case custom = 0
        
        // A system style button, such as those shown in navigation bars and toolbars.
        case system = 1
        
        // A detail disclosure button.
        case detailDisclosure = 2
        
        // An information button that has a light background.
        case infoLight = 3
        
        // An information button that has a dark background.
        case infoDark = 4
        
        // A contact add button.
        case contactAdd = 5
        
        // A standard system button without a blurred background view.
        case plain = 6
        
    }
}
