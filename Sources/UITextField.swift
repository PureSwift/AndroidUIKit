//
//  UITextField.swift
//  Android
//
//  Created by Marco Estrella on 10/4/18.
//

import Foundation
import Android

open class UITextField {
    
    internal let androidEditTextId = AndroidViewCompat.generateViewId()
    
    internal lazy var androidEditText: AndroidEditText = {
        
        let density = UIScreen.main.activity.density
        
        let dp6 = Int(6 * density)
        
        let editText = AndroidEditText(context: UIApplication.shared.androidActivity)
        editText.setId(androidEditTextId)
        editText.color = AndroidGraphicsColor.BLACK
        
        let params = AndroidLinearLayoutLayoutParams.init(width: AndroidLinearLayoutLayoutParams.MATCH_PARENT, height: AndroidLinearLayoutLayoutParams.WRAP_CONTENT)
        params.setMargins(left: 0, top: 0, right: 0, bottom: dp6)
        editText.layoutParams = params
        return editText
    }()
    
    public var text: String? {
        get {
            return self.androidEditText.getText()?.toString()
        }
        
        set {
            self.androidEditText.text = newValue
        }
    }
    
    public var placeholder: String? {
        
        get {
            return self.androidEditText.hint
        }
        
        set {
            self.androidEditText.hint = newValue
        }
    }
}

